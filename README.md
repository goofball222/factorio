# Factorio Docker Container

[![Docker Build Status](https://img.shields.io/docker/build/goofball222/factorio.svg)](https://hub.docker.com/r/goofball222/factorio/) [![Docker Pulls](https://img.shields.io/docker/pulls/goofball222/factorio.svg)](https://hub.docker.com/r/goofball222/factorio/) [![Docker Stars](https://img.shields.io/docker/stars/goofball222/factorio.svg)](https://hub.docker.com/r/goofball222/factorio/) [![MB Layers](https://images.microbadger.com/badges/image/goofball222/factorio.svg)](https://microbadger.com/images/goofball222/factorio) [![MB Commit](https://images.microbadger.com/badges/commit/goofball222/factorio.svg)](https://microbadger.com/images/goofball222/factorio) [![MB License](https://images.microbadger.com/badges/license/goofball222/factorio.svg)](https://microbadger.com/images/goofball222/factorio)

## Docker tags:
| Tag | Factorio Version | Description | Release Date |
| --- | :---: | --- | :---: |
| [latest](https://github.com/goofball222/factorio/blob/master/stable/Dockerfile) | [0.16.51](https://forums.factorio.com/61009) | Factorio headless server stable release | 2018-08-24 |
| [experimental](https://github.com/goofball222/factorio/blob/master/experimental/Dockerfile) | [0.17.9](https://forums.factorio.com/67151) | Factorio headless server experimental release | 2019-03-08 |
| [release-0.16.51](https://github.com/goofball222/factorio/releases/tag/0.16.51) | [0.16.51](https://forums.factorio.com/61009) | Factorio headless server stable static release | 2018-06-19 |
| [release-0.15.40](https://github.com/goofball222/factorio/releases/tag/0.15.40) | [0.15.40](https://forums.factorio.com/54307) | Factorio headless server stable static release | 2017-12-04 |

---

* [Recent changes, see: GitHub CHANGELOG.md](https://github.com/goofball222/factorio/blob/master/CHANGELOG.md)
* [Report any bugs, issues or feature requests on GitHub](https://github.com/goofball222/factorio/issues)

---

For security/attack surface reduction the container is configured to run the Factorio headless server with an internal user & group `factorio` having a pre-set UID & GID of 999.
The container will attempt to adjust permissions on mapped volumes and data to match before dropping privileges to start the Factorio server processes.
If the container is being run with a different Docker --user setting permissions may need to be fixed manually.

IE: `chown -R 999:999 ./{config,mods,saves}`

A custom UID and GID can be configured for the container internal factorio user and group. For more information see the "Environment variables" section in this document.

---

**Always stop the existing container and make a VERIFIED backup copy of your Factorio save data before installing newer images.**

---

## Usage

**The container exposes three volumes:**
* `/opt/factorio/config` - Factorio headless server config files
* `/opt/factorio/mods` - Factorio mods default directory for non-standard add-ins
* `/opt/factorio/saves` - Factorio save/map file storage location

**The container exposes two ports:**
* `27015/tcp`: Factorio RCON port
* `34197/udp`: Factorio default server port

---

**The most basic way to run this container:**

```bash
$ docker run --name factorio -d \
    -p 34197:34197/udp \
    goofball222/factorio
```

---

**Recommended: run via [Docker Compose](https://docs.docker.com/compose/):**

Have the container store the config, mods and saves on a local file-system or in a specific, known data volume (recommended for persistence and troubleshooting) and expose the RCON port for admin:

```bash

version: '3'

services:
  factorio:
    image: goofball222/factorio
    container_name: factorio
    restart: unless-stopped
    ports:
      - "27015:27015"
      - "34197:34197/udp"
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./config:/opt/factorio/config
      - ./mods:/opt/factorio/mods
      - ./saves:/opt/factorio/saves
    environment:
      - TZ=UTC

```

[Example basic `docker-compose.yml` file](https://raw.githubusercontent.com/goofball222/factorio/master/examples/docker-compose.yml)

---

**Logs are available directly from the running container, IE: "docker logs factorio"**

---

**Environment variables:**

| Variable | Default | Description |
| :--- | :---: | --- |
| `DEBUG` | ***false*** | Set to *true* for extra container verbosity for debugging |
| `FACTORIO_OPTS` | ***unset*** | Add custom command line options to factorio server executable at runtime |
| `FACTORIO_PORT` | ***unset*** | Override server default port for game client connections |
| `FACTORIO_RCON_PASSWORD` | ***unset*** | Specifiy the server RCON password |
| `FACTORIO_RCON_PORT` | ***27015*** | Specifies the server RCON admin port |
| `PGID` | ***999*** | Specifies the GID for the container internal factorio group (used for file ownership) |
| `PUID` | ***999*** | Specifies the UID for the container internal factorio user (used for process and file ownership) |
| `RUN_CHOWN` | ***true*** | Set to *false* to disable the container automatic `chown` at startup. Speeds up startup process on overlay2 Docker hosts. **NB/IMPORTANT:** It's critical that you insure directory/data permissions on all mapped volumes are correct before disabling this or Factorio will not start. |
| `RUNAS_UID0` | ***false*** | Set to *true* to force the container to run the Factorio server process as UID=0 (root) - **NB/IMPORTANT:** running with this set to "true" is insecure |

---

During the first launch of the container the server-settings.json and map-gen-settings.json config files will be populated with the Factorio sample/defaults if they don't already exist. It is highly recommended to edit these files and relaunch the container afterwards or provide pre-setup copies in the config directory prior to first launch. The config sample files are available in the headless server tar.gz file in the "data" folder. The container will also generate a default map / save.zip in the saves folder if one is not found on launch.

The RCON password can be set via the FACTORIO_RCON_PASSWORD ENV flag or loaded from `/opt/factorio/config/RCON.pwd` each time the container is started. If the FACTORIO_RCON_PASSWORD ENV var is not set or the RCON.pwd file is not present a random RCON password will be generated and saved in `/opt/factorio/config/RCON.pwd`. The active RCON password can also be found at the start of the container log file at each launch.

[//]: # (Licensed under the Apache 2.0 license)
[//]: # (Copyright 2018 The Goofball - goofball222@gmail.com)
