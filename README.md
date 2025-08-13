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
    --env DOCKER_GID="$(getent group docker | cut --delimiter=: --fields=3)" \
    --publish "127.0.0.1:${port}:22" \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume "sshserver_${project}_${hash}:/home" \
    --volume "${PWD}:/src/${project}" \
    ghcr.io/catalincezarene/sshserver:latest
```
