# ----------------------------------
# Environment: debian:buster-slim
# Minimum Panel Version: 0.7.X
# Debian Source Image for Valheim Plus
# ----------------------------------
FROM quay.io/parkervcp/pterodactyl-images:base_debian

LABEL author="Torsten Widmann" maintainer="info@goover.de"

## install reqs
RUN dpkg --add-architecture i386 \
 && apt update \
 && apt upgrade -y \
 && apt install -y libssl1.1:i386 libtinfo6:i386 libtbb2:i386 libtinfo5:i386 libcurl4-gnutls-dev:i386 libcurl4:i386 libncurses5:i386 libcurl3-gnutls:i386 libtcmalloc-minimal4:i386 faketime:i386 libtbb2:i386 \
    lib32tinfo6 lib32stdc++6 lib32z1 libtbb2 libtinfo5 libstdc++6 libreadline5 libncursesw5 libfontconfig1 libnss-wrapper gettext-base

USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD     ["/bin/bash", "/entrypoint.sh"]
