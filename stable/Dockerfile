FROM frolvlad/alpine-glibc:latest
MAINTAINER The Goofball "goofball222@gmail.com"

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL \
    org.label-schema.vendor=goofball222 \
    org.label-schema.url="https://github.com/goofball222/factorio" \
    org.label-schema.name="Factorio Headless Server" \
    org.label-schema.version=$VERSION \
    org.label-schema.vcs-url="https://github.com/goofball222/factorio.git" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.license="Apache-2.0" \
    org.label-schema.schema-version="1.0"

ENV \
    DEBUG=false \
    FACTORIO_RCON_PASSWORD= \
    FACTORIO_OPTS= \
    FACTORIO_GID=999 \
    FACTORIO_UID=999 \
    RUNAS_UID0=false

WORKDIR /opt/factorio

COPY root /

RUN \
    set -x \
    && delgroup ping \
    && addgroup -g $FACTORIO_GID factorio \
    && adduser -D -G factorio -u $FACTORIO_UID factorio \
    && apk --update add bash curl shadow su-exec \
    && curl -sSL https://www.factorio.com/get-download/$VERSION/headless/linux64 -o /tmp/factorio_headless_x64_$VERSION.tar.xz \
    && tar -xJf /tmp/factorio_headless_x64_$VERSION.tar.xz -C /opt \
    && rm /tmp/factorio_headless_x64_$VERSION.tar.xz \
    && apk del curl \
    && bash -c 'mkdir -p {config,mods,saves}' \
    && chown -R factorio:factorio /opt/factorio

EXPOSE 34197/udp 27015/tcp

VOLUME ["/opt/factorio/config", "/opt/factorio/mods", "/opt/factorio/saves"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["factorio"]
