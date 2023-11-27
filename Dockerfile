FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN <<EOF
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

# Clean up APT cache
rm -rf /var/lib/apt/lists/*
EOF

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD []
