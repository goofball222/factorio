* **2017-11-24:**
    * Bump experimental VERSION to [0.15.38](https://forums.factorio.com/54181)
---
* **2017-10-23:**
    * Add GitHub docs folder
        * Move CONTRIBUTING.md from root
        * Create ISSUE_TEMPLATE.md
        * Create PULL_REQUEST_TEMPLATE.md
    * Update .dockerignore to exclude docs folder
---
* **2017-10-17:**
    * Bump stable VERSION to [0.15.37](https://forums.factorio.com/53453)
    * Bump experimental VERSION to [0.15.37](https://forums.factorio.com/53453)
    * Tag release-0.15.37
---
* **2017-10-10:**
    * Bump experimental VERSION to [0.15.36](https://forums.factorio.com/53280)
---
* **2017-09-28:**
    * Bump experimental VERSION to [0.15.35](https://forums.factorio.com/53019)
    * Rename factorio-init to docker-entrypoint.sh, move to root/usr/local/bin
    * Remove factorio.crt
    * docker-entrypoint.sh changes:
        * Change functionality to run application as limited user for security
        * Add variables for changing baked-in factorio user/group UID/GID, FACTORIO_GID, FACTORIO_UID
        * Add functionality to ensure correct file permissions/ownership for data, mods, configs, etc.
        * Add variable RUNAS_UID0 to allow to revert to running as root/UID=0 if needed
        * Add termination signal handling and shutdown routine
        * Functionize logging stamper
        * Add support for running container with non-default CMD
    * Dockerfile changes:
        * Change WORKDIR to /opt/factorio
        * Add FACTORIO_GID=999 and FACTORIO_UID=999 defaults
        * Add RUNAS_UID0=false default
        * Switch to COPY root folder instead of individual files
        * Add "set -x" and reformat RUN section for clarity
        * Add packages shadow & su-exec to support running as non-UID=0 user
        * Add -C /opt to tar to force extract of factorio folder to correct location
        * Create volume folders via bash to ensure they're chowned to container factorio UID/GID
        * Add 'chown -R factorio:factorio /opt/factorio'
        * Change ENTRYPOINT to use renamed docker-entrypoint.sh
        * Add CMD "factorio" to set default docker-entrypoint.sh action
    * docker-compose.yml moved to examples folder, updated to remove init and switch back to version 2
    * README.md updates to document new variables and functionality
---
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
