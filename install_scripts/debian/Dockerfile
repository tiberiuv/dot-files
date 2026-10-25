# Coder workspace image with the apt prerequisites baked in, so the dotfiles
# run (setup.sh via dotfiles_uri) starts from step 2 instead of spending its
# first minutes in apt.
#
#   docker build -t dot-files-workspace install_scripts/debian
#
# The package list stays in apt-install.sh -- running the script here rather
# than copying its list is what keeps the image and a bare-box setup.sh from
# drifting apart.
FROM ubuntu:26.04

# CI passes the date. Any change to a build arg invalidates the RUNs below, so
# a daily rebuild re-runs `apt upgrade` instead of replaying yesterday's cached
# layer, while builds within the same day still share it.
ARG APT_REFRESH

# What the k8s-kata Coder template needs before any dotfiles run, and so not
# apt-install.sh's business:
#   - sudo, curl, jq: its startup and Claude scripts. apt-install.sh itself
#     also starts with sudo.
#   - the docker CLI and plugins, pointed at the dind sidecar by DOCKER_HOST.
#     Ubuntu only packages the CLI inside docker.io, daemon and all, hence
#     Docker's own repo.
#   - coder at uid 1000 with passwordless sudo. The ubuntu user already holds
#     that uid.
# blkid, mount, runuser and the rest of util-linux come with the base image.
#
# pebble ships in the base as a bare binary, outside dpkg, so apt never updates
# it and Trivy reports its Go stdlib. Nothing here runs it as an entrypoint.
RUN rm -rf /usr/bin/pebble /var/lib/pebble \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl sudo jq \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
    && . /etc/os-release \
    && echo "deb [signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $VERSION_CODENAME stable" \
        > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce-cli docker-buildx-plugin docker-compose-plugin \
    && userdel -r ubuntu \
    && useradd coder --create-home --shell /bin/bash --uid 1000 --user-group \
    && echo "coder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nopasswd \
    && chmod 0440 /etc/sudoers.d/nopasswd \
    && rm -rf /var/lib/apt/lists/*

COPY apt-install.sh /tmp/apt-install.sh
RUN APT_STRICT=1 APT_NO_RECOMMENDS=1 bash /tmp/apt-install.sh \
    && rm -rf /tmp/apt-install.sh /var/lib/apt/lists/*

USER coder
WORKDIR /home/coder
