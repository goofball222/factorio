# Containerized Factorio Headless Server

[![Latest Build Status](https://github.com/goofball222/factorio/actions/workflows/build-latest.yml/badge.svg)](https://github.com/goofball222/factorio/actions/workflows/build-latest.yml) [![Docker Pulls](https://img.shields.io/docker/pulls/goofball222/factorio.svg)](https://hub.docker.com/r/goofball222/factorio/) [![Docker Stars](https://img.shields.io/docker/stars/goofball222/factorio.svg)](https://hub.docker.com/r/goofball222/factorio/) [![License](https://img.shields.io/github/license/goofball222/factorio.svg)](https://github.com/goofball222/factorio)

| Docker Tag                                                                                |               Factorio Version               | Description                                    | Release Date |
| ----------------------------------------------------------------------------------------- | :------------------------------------------: | ---------------------------------------------- | :----------: |
| [latest, stable](https://github.com/goofball222/factorio/blob/main/stable/Dockerfile)     | [1.1.80](https://forums.factorio.com/105761) | Factorio headless server stable release        |  2023-03-30  |
| [experimental](https://github.com/goofball222/factorio/blob/main/experimental/Dockerfile) | [1.1.80](https://forums.factorio.com/105761) | Factorio headless server experimental release  |  2023-03-30  |
| [1.1.80](https://github.com/goofball222/factorio/releases/tag/1.1.80)                     | [1.1.80](https://forums.factorio.com/105761) | Factorio headless server stable static release |  2023-03-30  |

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

The following is instructions on how to create a server, load it with your own scenario, save, mods, and configs. The [docker-compose.yml example](https://raw.githubusercontent.com/goofball222/factorio/main/examples/docker-compose.yml) shown below is in the `examples` folder of this repo.

```bash
# docker-compose.yml

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

Create a folder that contains the things you want copied into the server, like so:

```bash
user@computer:~/my-factorio-server$ tree
.
├── config
│   ├── RCON.pwd
│   ├── config.ini
│   ├── map-gen-settings.json
│   └── server-settings.json
├── docker-compose.yml
├── mods
│   ├── mod-list.json
│   ├── mod-settings.dat
│   ├── space-exploration-graphics_0.6.13.zip
│   └── space-exploration_0.6.90.zip
└── saves
    └── save.zip

3 directories, 13 files
```

All of these files are optional. You can put the docker-compose.yml in an empty folder and start it and be fine. However doing this would be equivalent to the `docker run` command shown above.

If no `save.zip` is provided, a new game will be made. 

  > Note: the savegame must be named save.zip in the saves/ folder.

If no mods are provided, it will be vanilla.

  > Note: the server will not sync mods to the savegame like it does in singleplayer. You need to get the mods and put them in the `mods/` folder.

If any of the files in config/ is not provided, they will be loaded from default.

  > Note: If you want to make this a public server, you need to edit server-settings.json with your username and token. See [the wiki page.](https://wiki.factorio.com/Multiplayer#How_to_list_a_server-hosted_game_on_the_matching_server)

  > If there is no config/RCON.pwd, or a FACTORIO_RCON_PASSWORD environment variable, a random RCON password will be generated and saved in `/factorio/config/RCON.pwd`. This randomly generated password can be found at the start of the container log file at each launch.

You do not need to clone this repo or download the image from dockerhub. The docker-compose.yml saying `image: goofball222/factorio` means docker will download it for you.

Once the folders and everything is loaded up like the tree, omitting anything you don't mind being the default:

 `cd` into that folder (in the above example, it would be `cd ~/my-factorio-server`)

To start the server: `docker-compose up`

To stop the server: `docker-compose down`

To rebuild the server (for example after making a config change, or changing the `save.zip`): `docker compose up --force-rebuild -d`

To inspect server logs: `docker-compose logs`

To inspect server logs without being cd'd into the folder: `docker logs factorio`

> Note: if you want running logs, use `docker-compose logs -f` or `docker logs factorio -f`, replacing `factorio` with whatever the name of the image was set to in docker-compose.yml.

Also note that doing this, the `save.zip`, and everything else will be mirrored on either side. The docker image will write to its version of `save.zip`, which logically is the same file byte-for-byte as the one in `my-factorio-server`. This means you can backup your savegame easily.


---

**Environment variables:**

| Variable                 |   Default   | Description                                                                                                                                                                                                                                                                              |
| :----------------------- | :---------: | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `DEBUG`                  | ***false*** | Set to *true* for extra container verbosity for debugging                                                                                                                                                                                                                                |
| `FACTORIO_OPTS`          | ***unset*** | Add custom command line options to factorio server executable at runtime                                                                                                                                                                                                                 |
| `FACTORIO_PORT`          | ***unset*** | Override server default port for game client connections                                                                                                                                                                                                                                 |
| `FACTORIO_RCON_PASSWORD` | ***unset*** | Specifiy the server RCON password                                                                                                                                                                                                                                                        |
| `FACTORIO_RCON_PORT`     | ***27015*** | Specifies the server RCON admin port                                                                                                                                                                                                                                                     |
| `FACTORIO_SCENARIO`      | ***unset*** | Specifies a scenario name for the server to run                                                                                                                                                                                                                                          |
| `PGID`                   |  ***999***  | Specifies the GID for the container internal factorio group (used for file ownership)                                                                                                                                                                                                    |
| `PUID`                   |  ***999***  | Specifies the UID for the container internal factorio user (used for process and file ownership)                                                                                                                                                                                         |
| `RUN_CHOWN`              | ***true***  | Set to *false* to disable the container automatic `chown` at startup. Speeds up startup process on overlay2 Docker hosts. **NB/IMPORTANT:** It's critical that you insure directory/data permissions on all mapped volumes are correct before disabling this or Factorio will not start. |
| `RUNAS_UID0`             | ***false*** | Set to *true* to force the container to run the Factorio server process as UID=0 (root) - **NB/IMPORTANT:** running with this set to "true" is insecure                                                                                                                                  |

---

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
