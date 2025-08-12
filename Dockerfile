FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN <<EOF
userdel -r ubuntu

apt-get update
apt-get upgrade -y

apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    sudo \
    net-tools \
    openssh-server

# OpenSSH
mkdir /var/run/sshd

# Install Docker and Docker Compose clients
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/ubuntu noble stable" > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin

# Clean up APT cache
rm -rf /var/lib/apt/lists/*
EOF

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD []
