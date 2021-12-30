FROM debian:buster-slim

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL \
    org.opencontainers.image.vendor="The Goofball - goofball222@gmail.com" \
    org.opencontainers.image.url="https://github.com/goofball222/factorio" \
    org.opencontainers.image.title="Factiorio Headless Server" \
    org.opencontainers.image.description="Factiorio Headless Server" \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.source="https://github.com/goofball222/factorio" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.licenses="Apache-2.0"

ENV \
    DEBIAN_FRONTEND=noninteractive \
    DEBUG=false \
    PGID=999 \
    PUID=999 \
    RUN_CHOWN=true \
    RUNAS_UID0=false

WORKDIR /opt/factorio

COPY root /

RUN \
    set -x \
    && groupadd -r factorio -g $PGID \
    && useradd --no-log-init -r -u $PUID -g $PGID factorio \
    && mkdir -p /usr/share/man/man1 \
    && apt-get -qqy update \
    && apt-get -qqy install apt-utils \
    && apt-get -qqy --no-install-recommends install \
        ca-certificates curl gosu procps xz-utils > /dev/null \
    && curl -sSL https://www.factorio.com/get-download/$VERSION/headless/linux64 -o /tmp/factorio_headless_x64_$VERSION.tar.xz \
    && tar -xJf /tmp/factorio_headless_x64_$VERSION.tar.xz -C /opt \
    && bash -c 'mkdir -p {/factorio,/factorio/config,/factorio/mods,/factorio/saves,/factorio/scenarios}' \
    && ln -s /factorio/config /opt/factorio/config \
    && ln -s /factorio/mods /opt/factorio/mods \
    && ln -s /factorio/saves /opt/factorio/saves \
    && ln -s /factorio/scenarios /opt/factorio/scenarios \
    && apt-get -qqy purge \
        apt-utils ca-certificates curl xz-utils > /dev/null \
    && chown -R factorio:factorio /opt/factorio /factorio \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/*

EXPOSE 34197/udp 27015/tcp

VOLUME ["/factorio"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["factorio"]
