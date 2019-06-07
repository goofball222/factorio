* **2019-06-07**
    * Bump experimental VERSION to [0.17.46](https://forums.factorio.com/71655)
---
* **2019-05-31**
    * Bump experimental VERSION to [0.17.45](https://forums.factorio.com/71434)
---
* **2019-05-24**
    * Accept pull request #6 - Bump experimental VERSION to [0.17.43](https://forums.factorio.com/71197)
    * Thanks to [BlackDwarfUK](https://github.com/BlackDwarfUK)
---
* **2019-05-21**
    * Bump experimental VERSION to [0.17.42](https://forums.factorio.com/71100)
---
* **2019-05-17**
    * Bump experimental VERSION to [0.17.41](https://forums.factorio.com/70937)
---
* **2019-05-16**
    * Bump experimental VERSION to [0.17.40](https://forums.factorio.com/70898)
---
* **2019-05-14**
    * Bump experimental VERSION to [0.17.39](https://forums.factorio.com/70822)
---
* **2019-05-12**
    * Bump experimental VERSION to [0.17.38](https://forums.factorio.com/70641)
---
* **2019-05-08**
    * Bump experimental VERSION to [0.17.37](https://forums.factorio.com/70527)
---
* **2019-05-03**
    * Bump experimental VERSION to [0.17.36](https://forums.factorio.com/70314)
---
* **2019-05-02**
    * Bump experimental VERSION to [0.17.35](https://forums.factorio.com/70256)
---
* **2019-04-27**
    * Bump experimental VERSION to [0.17.34](https://forums.factorio.com/70006)
---
* **2019-04-24**
    * Bump experimental VERSION to [0.17.33](https://forums.factorio.com/69916)
---
* **2019-04-18**
    * Bump experimental VERSION to [0.17.32](https://forums.factorio.com/69672)
---
* **2019-04-13**
    * Bump experimental VERSION to [0.17.31](https://forums.factorio.com/69440)
---
* **2019-04-12**
    * Bump experimental VERSION to [0.17.29](https://forums.factorio.com/69397)
---
* **2019-04-09**
    * Bump experimental VERSION to [0.17.28](https://forums.factorio.com/69275)
---
* **2019-04-08**
    * Bump experimental VERSION to [0.17.26](https://forums.factorio.com/69229)
---
* **2019-04-04**
    * Bump experimental VERSION to [0.17.25](https://forums.factorio.com/69031)
---
* **2019-04-02**
    * Bump experimental VERSION to [0.17.24](https://forums.factorio.com/68909)
    * Update Dockerfile headless package link. Factorio CDN not behaving with Docker Cloud in the last couple of builds.
---
* **2019-03-29**
    * Bump experimental VERSION to [0.17.23](https://forums.factorio.com/68710)
    * Touch changelog to bump git commit, attempting to get Docker Hub to stop caching bad data.
---
* **2019-03-26**
    * ~~Bump experimental VERSION to [0.17.19](https://forums.factorio.com/68509)~~
    * ~~Bump experimental VERSION to [0.17.20](https://forums.factorio.com/68525)~~
    * Bump experimental VERSION to [0.17.21](https://forums.factorio.com/68548)
---
* **2019-03-25**
    * Bump experimental VERSION to [0.17.18](https://forums.factorio.com/68443)
---
* **2019-03-21**
    * Bump experimental VERSION to [0.17.17](https://forums.factorio.com/68235)
---
* **2019-03-19**
    * Bump experimental VERSION to [0.17.16](https://forums.factorio.com/68126)
---
* **2019-03-18**
    * Bump experimental VERSION to [0.17.15](https://forums.factorio.com/68030)
---
* **2019-03-15**
    * ~~Bump experimental VERSION to [0.17.13](https://forums.factorio.com/67758)~~
    * Bump experimental VERSION to [0.17.14](https://forums.factorio.com/67782)
---
* **2019-03-14**
    * Bump experimental VERSION to [0.17.12](https://forums.factorio.com/67694)
---
* **2019-03-11**
    * ~~Bump experimental VERSION to [0.17.10](https://forums.factorio.com/67424)~~
    * Bump experimental VERSION to [0.17.11](https://forums.factorio.com/67480)
---
* **2019-03-08**
    * Bump experimental VERSION to [0.17.9](https://forums.factorio.com/67151)
    * Update script to resolve GitHub issue #5 - Allow setting game and RCON port by ENV
        * Update documentation to reflect additional ENV variables for server ports
---
* **2019-03-07**
    * Bump experimental VERSION to [0.17.8](https://forums.factorio.com/67041)
---
* **2019-03-06**
    * Bump experimental VERSION to [0.17.7](https://forums.factorio.com/66956)
---
* **2019-03-05**
    * Bump experimental VERSION to [0.17.6](https://forums.factorio.com/66854)
---
* **2019-03-04**
    * Bump experimental VERSION to [0.17.5](https://forums.factorio.com/66705)
---
* **2019-03-01**
    * Bump experimental VERSION to [0.17.4](https://forums.factorio.com/66156)
    * Update change log and push to github to test webhook changes, nothing to see here...
---
* **2019-02-28**
    * Bump experimental VERSION to [0.17.3](https://forums.factorio.com/65940)
---
* **2019-02-27**
    * Bump experimental VERSION to [0.17.2](https://forums.factorio.com/65580)
---
* **2019-02-26**
    * ~~Bump experimental VERSION to [0.17.0](https://forums.factorio.com/65070)~~
    * Bump experimental VERSION to [0.17.1](https://forums.factorio.com/65227)
---
* **2018-08-24**
    * Update Dockerfile
        * Change FACTORIO_GID and FACTORIO_UID to PGID/PUID
        * Change apk commands to stop caching package lists and use virtual for build deps
        * Rework post-build cleanup
        * Add support for RUN_CHOWN flag
        * Add tzdata package
    * docker-entrypoint.sh
        * Add support for RUN_CHOWN flag
        * Change FACTORIO_GID and FACTORIO_UID to PGID/PUID
        * Add -o flag to groupmod/usermod - allow setting custom GID/UID when already exists
    * Update documentation to reflect variable changes
    * Update build hooks script
---
* **2018-06-19**
    * Bump stable VERSION to [0.16.51](https://forums.factorio.com/61009)
---
* **2018-06-15**
    * Bump experimental VERSION to [0.16.51](https://forums.factorio.com/61009)
---
* **2018-06-14**
    * Update Dockerfile to remove depreciated "MAINTAINER", move info to LABEL "vendor" value
---
* **2018-06-11**
    * Bump experimental VERSION to [0.16.50](https://forums.factorio.com/60929)
---
* **2018-06-08**
    * Bump experimental VERSION to [0.16.49](https://forums.factorio.com/60868)
---
* **2018-06-07**
    * Bump experimental VERSION to [0.16.48](https://forums.factorio.com/60839)
---
* **2018-05-31**
    * Bump experimental VERSION to [0.16.47](https://forums.factorio.com/60713)
---
* **2018-05-22**
    * Bump experimental VERSION to [0.16.44](https://forums.factorio.com/60548)
    * Bump experimental VERSION to [0.16.45](https://forums.factorio.com/60556)
---
* **2018-05-14**
    * Bump experimental VERSION to [0.16.43](https://forums.factorio.com/60361)
---
* **2018-05-13**
    * Bump experimental VERSION to [0.16.42](https://forums.factorio.com/60266)
---
* **2018-05-03**
    * Bump experimental VERSION to [0.16.41](https://forums.factorio.com/60051)
---
* **2018-05-02**
    * Bump experimental VERSION to [0.16.40](https://forums.factorio.com/60039)
---
* **2018-04-30**
    * Bump experimental VERSION to [0.16.39](https://forums.factorio.com/59984)
---
* **2018-04-26**
    * Bump experimental VERSION to [0.16.38](https://forums.factorio.com/59877)
---
* **2018-04-23**
    * Bump experimental VERSION to [0.16.37](https://forums.factorio.com/59802)
---
* **2018-03-29**
    * Bump stable VERSION to [0.16.36](https://forums.factorio.com/59134)
    * Tag stable release 0.16.36
---
* **2018-03-26**
    * Bump experimental VERSION to [0.16.35](https://forums.factorio.com/59005)
---
* **2018-03-22**
    * Bump experimental VERSION to [0.16.34](https://forums.factorio.com/58962)
---
* **2018-03-20**
    * Bump experimental VERSION to [0.16.32](https://forums.factorio.com/58890)
---
* **2018-03-19**
    * Bump experimental VERSION to [0.16.31](https://forums.factorio.com/58853)
---
* **2018-03-12**
    * Bump experimental VERSION to [0.16.30](https://forums.factorio.com/58649)
---
* **2018-03-05**
    * Bump experimental VERSION to [0.16.28](https://forums.factorio.com/58417)
---
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
