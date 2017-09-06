* **2017-08-23:**
    * Bump stable VERSION to [0.15.34](https://forums.factorio.com/52108)
        * Devs silently moved this from experimental to stable, not sure of exact date
    * Tag release-0.15.34
---
* **2017-08-23:**
    * Change experimental VERSION to [0.15.34](https://forums.factorio.com/52108)
    * Add docker-compose.yml example
    * Update documentation to recommend use of --init flag for container run/term signal handling
    * Update Makefiles to use --init flag for "make start"
---
* **2017-08-15:**
    * Where possible switched from 2 spaces to 4 spaces for indent, readability.
    * Add clean process to Makefiles
---
* **2017-08-15:**
    * Update stable VERSION to Factorio [v0.15.33](https://forums.factorio.com/51695)
    * Tagged release-0.15.33
    * Change to Makefiles for local builds. Automates injecting build args including VERSION
    * Add hooks/build script for Docker Hub automated labels
    * Rename factorio_launch.sh to factorio-init
    * Change Dockerfile to support build args and labels
    * Switch Dockerfile to start factorio-init via entrypoint
    * Change Dockerfile to support ENV/-e flags at build and run
    * Change factorio-init to support ENV/-e flags at build and run
    * Move changelog to CHANGELOG.md file
    * Update README.md
---
* **2018-08-09:**
    * Updated experimental tag to Factorio [v0.15.33](https://forums.factorio.com/51695)
---
* **2017-08-06:**
    * Updated factorio_launch.sh to use RCON.pwd file in `/opt/factorio/config`
    * If `/opt/factorio/config/RCON.pwd' is not found a random password will be generated and saved in it
    * All versions remain unchanged, no other changes of note
---
* **2017-08-02:**
    * Rename "unstable" tag to "experimental"
