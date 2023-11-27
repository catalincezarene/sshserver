# sshserver

```bash
#!/bin/bash
set -Eeuo pipefail

project="projectname"
port="2200"
authorized_keys="$(cat ~/.ssh/authorized_keys)"
hash="$(md5sum <<< ${project} | awk '{ print $1 }')"

docker run \
    --rm \
    --detach \
    --name "sshserver_${project}_${hash}" \
    --env PUID="${UID}" \
    --env PGID="${UID}" \
    --env USER_NAME="${project}" \
    --env AUTHORIZED_KEYS="${authorized_keys}" \
    --publish "127.0.0.1:${port}:22" \
    --volume "sshserver_${project}_${hash}:/home" \
    --volume "${PWD}:/src/${project}" \
    ghcr.io/catalincezarene/sshserver:latest
```
