# ----------------------------------
# Environment: debian:buster-slim
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM quay.io/parkervcp/pterodactyl-images:base_debian

LABEL author="Torsten Widmann" maintainer="info@goover.de"

## install reqs
RUN dpkg --add-architecture i386 \
 && wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb \
 && dpkg -i packages-microsoft-prod.deb \
 && apt update \
 && apt upgrade -y \
 && apt install -y libssl1.1:i386 libtinfo6:i386 libsdl2-2.0-0:i386 libtinfo5:i386 libcurl4-gnutls-dev:i386 libcurl4:i386 libncurses5:i386 libcurl3-gnutls:i386 libtcmalloc-minimal4:i386 faketime:i386 libtbb2:i386 \
    lib32tinfo6 lib32stdc++6 lib32z1 libtbb2 libtinfo5 libstdc++6 libreadline5 libncursesw5 libfontconfig1 libnss-wrapper gettext-base dotnet-sdk-5.0
 
## install rcon
RUN cd /tmp/ \
 && curl -sSL https://github.com/gorcon/rcon-cli/releases/download/v0.9.0/rcon-0.9.0-amd64_linux.tar.gz > rcon.tar.gz \
 && tar xvf rcon.tar.gz \
 && mv rcon-0.9.0-amd64_linux/rcon /usr/local/bin/

USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY ./entrypoint.sh /entrypoint.sh