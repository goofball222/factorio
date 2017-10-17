# Factorio Docker Container

[![Docker Build Status](https://img.shields.io/docker/build/goofball222/factorio.svg)](https://hub.docker.com/r/goofball222/factorio/) [![Docker Pulls](https://img.shields.io/docker/pulls/goofball222/factorio.svg)](https://hub.docker.com/r/goofball222/factorio/) [![Docker Stars](https://img.shields.io/docker/stars/goofball222/factorio.svg)](https://hub.docker.com/r/goofball222/factorio/) [![MB Layers](https://images.microbadger.com/badges/image/goofball222/factorio.svg)](https://microbadger.com/images/goofball222/factorio) [![MB Commit](https://images.microbadger.com/badges/commit/goofball222/factorio.svg)](https://microbadger.com/images/goofball222/factorio) [![MB License](https://images.microbadger.com/badges/license/goofball222/factorio.svg)](https://microbadger.com/images/goofball222/factorio)

## Docker tags:
| Tag | Factorio Version | Description | Release Date |
| --- | :---: | --- | :---: |
| [latest](https://github.com/goofball222/factorio/blob/master/stable/Dockerfile) | [0.15.37](https://forums.factorio.com/53453) | Factorio headless server stable release | 2017-10-17 |
| [experimental](https://github.com/goofball222/factorio/blob/master/experimental/Dockerfile) | [0.15.37](https://forums.factorio.com/53453) | Factorio headless server experimental release | 2017-10-17 |
| [release-0.15.37](https://github.com/goofball222/factorio/releases/tag/0.15.37) | [0.15.37](https://forums.factorio.com/53453) | Factorio headless server stable static release | 2017-10-17 |
| [release-0.14.23](https://github.com/goofball222/factorio/releases/tag/0.14.23) | [0.14.23](https://forums.factorio.com/44504) | Factorio headless server stable static release | 2017-04-24 |

---

* [Recent changes, see: GitHub CHANGELOG.md](https://github.com/goofball222/factorio/blob/master/CHANGELOG.md)
* [Report any bugs, issues or feature requests on GitHub](https://github.com/goofball222/factorio/issues)

---

### **ALL BUILDS CREATED AFTER 2017-09-28:** For attack surface reduction and increased security the container is built to run the Factorio headless server with an internal user & group `factorio` having a default UID & GID of 999.
The container will attempt to adjust the permissions on mapped volumes and data before dropping privileges to start the Factorio server process.
If the container is being run with a different Docker --user setting permissions may need to be fixed manually.

IE: `chown -R 999:999 /DATA_VOLUME/factorio/{config,mods,saves}`

A custom UID and GID can be configured for the container internal factorio user and group. For more information see the "Environment variables" section in this document.

---

**Always stop the existing container and make a VERIFIED backup copy of your Factorio data before installing newer images.**
**Make a backup of your v0.14.X saves before upgrading to v0.15.X. A lot has changed and may break existing maps/saves.**

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

**Recommended run command line -**

Have the container store the config, mods and saves on a local file-system or in a specific, known data volume (recommended for persistence and troubleshooting) and expose the RCON port for admin:

```bash
$ docker run --name factorio -d \
    -p 27015:27015 -p 34197:34197/udp \
    -v /DATA_VOLUME/factorio/config:/opt/factorio/config \
    -v /DATA_VOLUME/factorio/mods:/opt/factorio/mods \
    -v /DATA_VOLUME/factorio/saves:/opt/factorio/saves \
	goofball222/factorio
```
---

**Logs are available directly from the running container, IE: "docker logs factorio"**

---

**Environment variables:**

| Variable | Default | Description |
| :--- | :---: | --- |
| `DEBUG` | ***false*** | Set to *true* for extra container verbosity for debugging |
| `FACTORIO_RCON_PASSWORD` | ***unset*** | Specifiy the RCON password |
| `FACTORIO_OPTS` | ***unset*** | Add custom command line options to factorio server executable at runtime |
| `FACTORIO_GID` | ***999*** | Specifies the GID for the container internal factorio group (used for file ownership) |
| `FACTORIO_UID` | ***999*** | Specifies the UID for the container internal factorio user (used for process and file ownership) |
| `RUNAS_UID0` | ***false*** | Set to *true* to force the container to run the Factorio server process as UID=0 (root) - **NB/IMPORTANT:** running with this set to "true" is insecure |

---

**[Docker Compose](https://docs.docker.com/compose/):**

[Example basic `docker-compose.yml` file](https://raw.githubusercontent.com/goofball222/factorio/master/examples/docker-compose.yml)

---

During the first launch of the container the server-settings.json and map-gen-settings.json config files will be populated with the Factorio sample/defaults if they don't already exist. It is highly recommended to edit these files and relaunch the container afterwards or provide pre-setup copies in the config directory prior to first launch. The config sample files are available in the headless server tar.gz file in the "data" folder. The container will also generate a default map / save.zip in the saves folder if one is not found on launch.

The RCON password can be set via the FACTORIO_RCON_PASSWORD ENV flag or loaded from `/opt/factorio/config/RCON.pwd` each time the container is started. If the FACTORIO_RCON_PASSWORD ENV var is not set or the RCON.pwd file is not present a random RCON password will be generated and saved in `/opt/factorio/config/RCON.pwd`. The active RCON password can also be found at the start of the container log file at each launch.

[//]: # (Licensed under the Apache 2.0 license)
[//]: # (Copyright 2017 The Goofball - goofball222@gmail.com)
