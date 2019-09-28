FROM frolvlad/alpine-glibc:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL \
    org.label-schema.vendor="The Goofball - goofball222@gmail.com" \
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
    PGID=999 \
    PUID=999 \
    RUN_CHOWN=true \
    RUNAS_UID0=false

WORKDIR /opt/factorio

COPY root /

RUN \
    set -x \
    && delgroup ping \
    && addgroup -g $PGID factorio \
    && adduser -D -G factorio -u $PUID factorio \
    && apk add -q --no-cache --virtual .build-deps \
        curl \
    && apk add -q --no-cache \
        bash curl shadow su-exec tzdata \
    && curl -sSL https://www.factorio.com/get-download/$VERSION/headless/linux64 -o /tmp/factorio_headless_x64_$VERSION.tar.xz \
    && tar -xJf /tmp/factorio_headless_x64_$VERSION.tar.xz -C /opt \
    && bash -c 'mkdir -p {/factorio,/factorio/config,/factorio/mods,/factorio/saves,/factorio/scenarios}' \
    && ln -s /factorio/config /opt/factorio/config \
    && ln -s /factorio/mods /opt/factorio/mods \
    && ln -s /factorio/saves /opt/factorio/saves \
    && ln -s /factorio/scenarios /opt/factorio/scenarios \
    && chown -R factorio:factorio /opt/factorio /factorio \
    && apk del -q --purge .build-deps \
    && rm -rf /tmp/* /var/cache/apk/*

EXPOSE 34197/udp 27015/tcp

VOLUME ["/factorio"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["factorio"]
