* **2018-02-28:**
    * Bump experimental VERSION to [0.16.27](https://forums.factorio.com/58281)
---
* **2018-02-26:**
    * Bump experimental VERSION to [0.16.26](https://forums.factorio.com/58199)
---
* **2018-02-19:**
    * Bump experimental VERSION to [0.16.25](https://forums.factorio.com/57993)
---
* **2018-02-15:**
    * Bump experimental VERSION to [0.16.24](https://forums.factorio.com/57846)
---
* **2018-02-12:**
    * Bump experimental VERSION to [0.16.23](https://forums.factorio.com/57752)
---
* **2018-02-02:**
    * Bump experimental VERSION to [0.16.22](https://forums.factorio.com/57402)
---
* **2018-02-01:**
    * Bump experimental VERSION to [0.16.21](https://forums.factorio.com/57372)
---
* **2018-01-26:**
    * Bump experimental VERSION to [0.16.20](https://forums.factorio.com/57181)
---
* **2018-01-25:**
    * Bump experimental VERSION to [0.16.19](https://forums.factorio.com/57117)
---
* **2018-01-23:**
    * Bump experimental VERSION to [0.16.18](https://forums.factorio.com/56998)
---
* **2018-01-22:**
    * Bump experimental VERSION to [0.16.17](https://forums.factorio.com/56919)
---
* **2018-01-10:**
    * Bump experimental VERSION to [0.16.16](https://forums.factorio.com/56444)
---
* **2018-01-05:**
    * Bump experimental VERSION to [0.16.15](https://forums.factorio.com/56222)
    * Update README.md formatting and wording
---
* **2018-01-04:**
    * Bump experimental VERSION to [0.16.14](https://forums.factorio.com/56182)
---
* **2018-01-03:**
    * Bump experimental VERSION to [0.16.13](https://forums.factorio.com/56126)
---
* **2017-12-31:**
    * Bump experimental VERSION to [0.16.12](https://forums.factorio.com/55966)
---
* **2017-12-30:**
    * Bump experimental VERSION to [0.16.11](https://forums.factorio.com/55929)
---
* **2017-12-30:**
    * Bump experimental VERSION to [0.16.10](https://forums.factorio.com/55905)
---
* **2017-12-21:**
    * Bump experimental VERSION to [0.16.7](https://forums.factorio.com/55505)
---
* **2017-12-18:**
    * Bump experimental VERSION to [0.16.6](https://forums.factorio.com/55316)
---
* **2017-12-17:**
    * Bump experimental VERSION to [0.16.5](https://forums.factorio.com/55165)
---
* **2017-12-16:**
    * Bump experimental VERSION to [0.16.4](https://forums.factorio.com/55030)
---
* **2017-12-15:**
    * Bump experimental VERSION to [0.16.3](https://forums.factorio.com/54890)
---
* **2017-12-14:**
    * Bump experimental VERSION to [0.16.2](https://forums.factorio.com/54754)
---
* **2017-12-13:**
    * Bump experimental VERSION to [0.16.0](https://forums.factorio.com/54538)
---
* **2017-12-04:**
    * Bump stable VERSION to [0.15.40](https://forums.factorio.com/54307)
    * Tag release-0.15.40
---
* **2017-11-30:**
    * Bump experimental VERSION to [0.15.40](https://forums.factorio.com/54307)
---
* **2017-11-27:**
    * Bump experimental VERSION to [0.15.39](https://forums.factorio.com/54257)
---
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
