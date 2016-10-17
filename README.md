# Factorio Docker

## Description

#### This is a Docker container built to run a Factorio headless server

## Docker tags:
| Tag | Description |
| --- | --- |
| latest | Factorio headless server stable release (v0.13.20 as of 2016-08-29) |
| unstable | Factorio headless server experimental release (v0.14.14 as of 2016-10-14) |

## Important notes

**Always stop the existing container and make a backup copy of your Factorio data before installing newer images.**

Changes 2016-10-17:
* Initial release/github checkin. Basic usage guide and README.md documentation.

## Usage

This container is configured to look for the save.zip file in `/opt/factorio/saves`,
mods in `/opt/factorio/mods`, and server/map generation settings in `/opt/factorio/config`.

Logs are available directly from the running container, IE: "docker logs factorio"

The most basic way to launch this container is as follows:

```bash
$ docker run --name factorio -d -p 34197:34197/udp \
	goofball222/factorio
```

The container exposes two ports:
27105/tcp: Factorio RCON port
34197/udp: Factorio default server port

The container exposes three volumes:
* /opt/factorio/config - Factorio headless server config files
* /opt/factorio/mods - Factorio mods default directory for non-standard add-ins
* /opt/factorio/saves - Factorio save/map file default storage location

To have the container store the config, mods and saves (recommended for persistence)
and expose the RCON port for admin, run:

```bash
$ docker run --name factorio -d -p 34197:34197/udp -p 27015:27015/tcp \
	-v /path/to/config:/opt/factorio/config \
	-v /path/to/mods:/opt/factorio/mods \
	-v /path/to/saves:/opt/factorio/saves \
	goofball222/factorio
```

During the first launch of the container the server-settings.json and map-gen-settings.json config files will be populated with the Factorio sample/defaults if they don't already exist. It is highly recommended to edit these files and relaunch the container afterwards or provide pre-setup copies in the config directory prior to first launch. The config sample files are available in the headless server tar.gz file in the "data" folder. The container will also generate a default map / save.zip in the saves folder if one is not found on launch.

The RCON password is regenerated randomly each time the container is started. It can be found at the start of the container log file.

