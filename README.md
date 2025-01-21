# Containerized Factorio Headless Server

[![Latest Build Status](https://github.com/goofball222/factorio/actions/workflows/build-latest.yml/badge.svg)](https://github.com/goofball222/factorio/actions/workflows/build-latest.yml) [![Docker Pulls](https://img.shields.io/docker/pulls/goofball222/factorio.svg)](https://hub.docker.com/r/goofball222/factorio/) [![Docker Stars](https://img.shields.io/docker/stars/goofball222/factorio.svg)](https://hub.docker.com/r/goofball222/factorio/) [![License](https://img.shields.io/github/license/goofball222/factorio.svg)](https://github.com/goofball222/factorio)

| Docker Tag | Factorio Version | Description | Release Date |
| --- | :---: | --- | :---: |
| [latest, stable](https://github.com/goofball222/factorio/blob/main/stable/Dockerfile) | [2.0.30](https://forums.factorio.com/125799) | Factorio headless server stable release | 2025-01-21 |
| [experimental](https://github.com/goofball222/factorio/blob/main/experimental/Dockerfile) | [2.0.32](https://forums.factorio.com/126165) | Factorio headless server experimental release | 2025-01-21 |
| [2.0.28](https://github.com/goofball222/factorio/releases/tag/2.0.30) | [2.0.30](https://forums.factorio.com/125799) | Factorio headless server stable static release | 2025-01-21 |

---

* [Recent changes, see: GitHub CHANGELOG.md](https://github.com/goofball222/factorio/blob/main/CHANGELOG.md)
* [Report any bugs, issues or feature requests on GitHub](https://github.com/goofball222/factorio/issues)

---

For security/attack surface reduction the container is configured to run the Factorio headless server with an internal user & group `factorio` having a pre-set UID & GID of 999.
The container will attempt to adjust permissions on mapped volumes and data to match before dropping privileges to start the Factorio server processes.
If the container is being run with a different Docker --user setting permissions may need to be fixed manually.

IE: `chown -R 999:999 factorio`

A custom UID and GID can be configured for the container internal factorio user and group. For more information see the "Environment variables" section in this document.

---

**Always stop the existing container and make a VERIFIED backup copy of your Factorio save data before installing newer images.**

---

## Usage

**The container has a single volume `/factorio` with the following structure:**

    factorio
    |-- config
    |   |-- map-gen-settings.json
    |   |-- map-gen-settings.example.json
    |   |-- map-settings.json
    |   |-- map-settings.example.json
    |   |-- RCON.pw
    |   |-- server-adminlist.json
    |   |-- server-banlist.json
    |   |-- server-settings.json
    |   `-- server-whitelist.json
    |-- mods
    |   `-- mod.zip
    |-- saves
    |   `-- save.zip
    `-- scenarios
        `-- scenario.zip

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

Have the container store the config, mods, saves, and scenarios on a local file-system or in a specific, known data volume (recommended for persistence and troubleshooting) and expose the RCON port for admin:

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
      - .:/factorio
    environment:
      - TZ=UTC

```

[Example basic `docker-compose.yml` file](https://raw.githubusercontent.com/goofball222/factorio/main/examples/docker-compose.yml)

---

**Logs are available directly from the running container, IE: "docker logs factorio"**

---

**Environment variables:**

| Variable | Default | Description |
| :--- | :---: | --- |
| `DEBUG` | ***false*** | Set to *true* for extra container verbosity for debugging |
| `FACTORIO_OPTS` | ***unset*** | Add custom command line options to factorio server executable at runtime |
| `FACTORIO_PORT` | ***unset*** | Override server default port for game client connections |
| `FACTORIO_RCON_PASSWORD` | ***unset*** | Specify the server RCON password |
| `FACTORIO_RCON_PORT` | ***27015*** | Specifies the server RCON admin port |
| `FACTORIO_SCENARIO` | ***unset*** | Specifies a scenario name for the server to run |
| `PGID` | ***999*** | Specifies the GID for the container internal factorio group (used for file ownership) |
| `PUID` | ***999*** | Specifies the UID for the container internal factorio user (used for process and file ownership) |
| `RUN_CHOWN` | ***true*** | Set to *false* to disable the container automatic `chown` at startup. Speeds up startup process on overlay2 Docker hosts. **NB/IMPORTANT:** It's critical that you insure directory/data permissions on all mapped volumes are correct before disabling this or Factorio will not start. |
| `RUNAS_UID0` | ***false*** | Set to *true* to force the container to run the Factorio server process as UID=0 (root) - **NB/IMPORTANT:** running with this set to "true" is insecure |

---

During the first launch of the container the server-settings.json and map-gen-settings.json config files will be populated with the Factorio sample/defaults if they don't already exist. It is highly recommended to edit these files and relaunch the container afterwards or provide pre-setup copies in the config directory prior to first launch. The config sample files are available in the headless server tar.gz file in the "data" folder. The container will also generate a default map / save.zip in the saves folder if one is not found on launch.

The RCON password can be set via the FACTORIO_RCON_PASSWORD ENV flag or loaded from `/factorio/config/RCON.pwd` each time the container is started. If the FACTORIO_RCON_PASSWORD ENV var is not set or the RCON.pwd file is not present a random RCON password will be generated and saved in `/factorio/config/RCON.pwd`. The active RCON password can also be found at the start of the container log file at each launch.

---

## Optional config examples

`config/server-whitelist.json` - **if present only the configured Factorio users will be allowed access**

    [
        "user1",
        "user2",
        "user3"
    ]

`config/server-banlist.json` - if present the configured Factorio user IDs will be denied access

    [
        "banneduser1",
        "banneduser2",
        "banneduser3",
        "banneduser4"
    ]

`config/server-adminlist.json` - if present the configured Factorio user IDs will have admin access

    [
        "adminuser1",
        "adminuser2"
    ]

[//]: # (Licensed under the Apache 2.0 license)
[//]: # (Copyright 2019 The Goofball - goofball222@gmail.com)
