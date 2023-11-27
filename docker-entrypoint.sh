#!/bin/bash
set -Eeuo pipefail

port=${PORT:-22}
puid=${PUID:-1000}
pgid=${PGID:-1000}
user_name=${USER_NAME:-dev}
user_password=${USER_PASSWORD:-}
authorized_keys=${AUTHORIZED_KEYS:-}

groupadd -g $pgid $user_name
useradd -u $puid -g $pgid -s /bin/bash -m $user_name

if [ ! -z "$user_password" ]; then
    echo "${user_name}:${user_password}" | chpasswd
fi

if [ ! -z "$authorized_keys" ]; then
    mkdir -p "/home/${user_name}/.ssh"
    echo "$authorized_keys" > "/home/${user_name}/.ssh/authorized_keys"
fi

chown -R $puid:$pgid "/home/${user_name}"

usermod -aG sudo $user_name
echo "${user_name} ALL=(ALL) NOPASSWD:ALL" | tee "/etc/sudoers.d/${user_name}" > /dev/null

if [ -z "${1:-}" ]; then
    exec /usr/sbin/sshd -p "${port}" -D
fi

exec "$@"

