FROM frolvlad/alpine-glibc:latest

MAINTAINER Goofball222 <goofball222@gmail.com>

WORKDIR /opt

ENV VERSION=0.15.33

COPY ./factorio.crt /opt/

RUN apk --update add bash curl && \
    curl -sSL --cacert /opt/factorio.crt https://www.factorio.com/get-download/$VERSION/headless/linux64 -o /tmp/factorio_headless_x64_$VERSION.tar.xz && \
    tar -xJf /tmp/factorio_headless_x64_$VERSION.tar.xz && \
    rm /tmp/factorio_headless_x64_$VERSION.tar.xz && \
    apk del curl

RUN mkdir /opt/factorio/config

COPY ./factorio_launch.sh /opt/

VOLUME ["/opt/factorio/config", "/opt/factorio/mods", "/opt/factorio/saves"]

EXPOSE 34197/udp 27015/tcp

CMD ["./factorio_launch.sh"]
