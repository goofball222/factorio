# Factorio Docker Container

[![Docker Build Status](https://img.shields.io/docker/build/goofball222/factorio.svg)](https://hub.docker.com/r/goofball222/factorio/) [![Docker Pulls](https://img.shields.io/docker/pulls/goofball222/factorio.svg)](https://hub.docker.com/r/goofball222/factorio/) [![Docker Stars](https://img.shields.io/docker/stars/goofball222/factorio.svg)](https://hub.docker.com/r/goofball222/factorio/) [![MB Layers](https://images.microbadger.com/badges/image/goofball222/factorio.svg)](https://microbadger.com/images/goofball222/factorio) [![MB Commit](https://images.microbadger.com/badges/commit/goofball222/factorio.svg)](https://microbadger.com/images/goofball222/factorio) [![MB License](https://images.microbadger.com/badges/license/goofball222/factorio.svg)](https://microbadger.com/images/goofball222/factorio)

## Docker tags:
| Tag | Factorio Version | Description | Release Date |
| --- | :---: | --- | :---: |
| [latest](https://github.com/goofball222/factorio/blob/master/stable/Dockerfile) | [0.15.33](https://forums.factorio.com/51695) | Factorio headless server stable release | 2017-08-14 |
| [experimental](https://github.com/goofball222/factorio/blob/master/experimental/Dockerfile) | [0.15.33](https://forums.factorio.com/51695) | Factorio headless server experimental release | 2017-08-09 |
| [release-0.15.33](https://github.com/goofball222/factorio/releases/tag/0.15.31) | [0.15.33](https://forums.factorio.com/51695) | Factorio headless server stable static release | 2017-08-14 |
| [release-0.14.23](https://github.com/goofball222/factorio/releases/tag/0.14.23) | [0.14.23](https://forums.factorio.com/44504) | Factorio headless server stable static release | 2017-04-24 |

---

* **2017-08-15:**
    * Moved "Changes" to [GitHub CHANGELOG.md](https://github.com/goofball222/factorio/blob/master/CHANGELOG.md) file.
    * Please report any bugs and/or issues on GitHub: https://github.com/goofball222/factorio/issues
---

**Always stop the existing container and make a backup copy of your Factorio data before installing newer images.**
**Make a backup of your v0.14.X saves before upgrading to v0.15.X. A lot has changed and may break existing maps/saves.**

## Usage

This container is configured to look for the save.zip file in `/opt/factorio/saves`,
mods in `/opt/factorio/mods`, and server/map generation settings in `/opt/factorio/config`.

Logs are available directly from the running container, IE: "docker logs factorio"

**The most basic way to launch this container is as follows:**
```bash
$ docker run --name factorio -d -p 34197:34197/udp \
	goofball222/factorio
```

**The container exposes two ports:**
* `27015/tcp`: Factorio RCON port
* `34197/udp`: Factorio default server port

**The container exposes three volumes:**
* `/opt/factorio/config` - Factorio headless server config files
* `/opt/factorio/mods` - Factorio mods default directory for non-standard add-ins
* `/opt/factorio/saves` - Factorio save/map file default storage location

**The container has 3 ENV (-e/--env) variables that can be set:**
* `DEBUG` sets "-x" in factorio-init for debugging, defaults to false. Set to true to activate.
* `FACTORIO_RCON_PASSWORD` sets the RCON password.
* `FACTORIO_OPTS` feed additional command line options to factorio server executable at runtime.
        

To have the container store the config, mods and saves (recommended for persistence)
and expose the RCON port for admin, run:

```bash
$ docker run --name factorio -d -p 34197:34197/udp -p 27015:27015/tcp \
	-v /path/to/config:/opt/factorio/config \
	-v /path/to/mods:/opt/factorio/mods \
	-v /path/to/saves:/opt/factorio/saves \
	goofball222/factorio
```

---

During the first launch of the container the server-settings.json and map-gen-settings.json config files will be populated with the Factorio sample/defaults if they don't already exist. It is highly recommended to edit these files and relaunch the container afterwards or provide pre-setup copies in the config directory prior to first launch. The config sample files are available in the headless server tar.gz file in the "data" folder. The container will also generate a default map / save.zip in the saves folder if one is not found on launch.

The RCON password can be set via the FACTORIO_RCON_PASSWORD ENV flag or loaded from `/opt/factorio/config/RCON.pwd` each time the container is started. If the FACTORIO_RCON_PASSWORD ENV var is not set or the RCON.pwd file is not present a random RCON password will be generated and saved in `/opt/factorio/config/RCON.pwd`. The active RCON password can also be found at the start of the container log file at each launch.
