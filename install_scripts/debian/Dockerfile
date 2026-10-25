# Coder workspace image with the apt prerequisites baked in, so the dotfiles
# run (setup.sh via dotfiles_uri) starts from step 2 instead of spending its
# first minutes in apt.
#
#   docker build -t dot-files-workspace install_scripts/debian
#
# The package list stays in apt-install.sh -- running the script here rather
# than copying its list is what keeps the image and a bare-box setup.sh from
# drifting apart.
FROM codercom/enterprise-base:ubuntu

# CI passes the date. Any change to a build arg invalidates the RUN below, so a
# daily rebuild re-runs `apt upgrade` instead of replaying yesterday's cached
# layer, while builds within the same day still share it.
ARG APT_REFRESH

USER root

COPY apt-install.sh /tmp/apt-install.sh
RUN APT_STRICT=1 APT_NO_RECOMMENDS=1 bash /tmp/apt-install.sh \
    && rm -rf /tmp/apt-install.sh /var/lib/apt/lists/*

USER coder
