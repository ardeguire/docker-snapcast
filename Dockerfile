FROM ghcr.io/linuxserver/baseimage-alpine:edge

# set version label
ARG BUILD_DATE
ARG SNAPCAST_RELEASE
ARG LIBRESPOT_RELEASE

LABEL build_version="version:- snapcast-${SNAPCAST_RELEASE}-librespot-${LIBRESPOT_RELEASE} Build-date:- ${BUILD_DATE}"
LABEL maintainer="ardeguire"

# install pacakges
RUN set -ex \
  echo "**** setup apk testing mirror ****" \
  && echo "@testing https://nl.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories \
  && cat /etc/apk/repositories \
  && echo "**** install runtime packages ****" \
  && apk update && apk upgrade \
  && apk add --no-cache \
    alsa-utils \
    dbus \
    librespot@testing=~${LIBRESPOT_RELEASE} \
    shairport-sync@testing \
    snapcast=~${SNAPCAST_RELEASE} \
    snapweb@testing \
  && echo "**** cleanup ****" \
  && rm -rf \
    /tmp/*

# apk add alsa-utils alsa-lib alsaconf alsa-ucm-conf
# environment settings
ENV \
START_SNAPSERVER=true \
START_SNAPCLIENT=false \
START_AIRPLAY=false \
SNAPCLIENT_OPTS="" \
SNAPSERVER_OPTS=""

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 1704
EXPOSE 1705
EXPOSE 1780
#
VOLUME /config /data
