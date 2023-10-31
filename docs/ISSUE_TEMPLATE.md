## Reporting bugs/issues

* When reporting a bug/issue:
    * Ensure that you are using the latest release.
    * Revert any custom modifications or environment varibles to insure they're not the cause.

* Please provide the following information:
    * OS/distribution version (command for your OS may differ):
    IE:
    ```bash
    user@host:~$ lsb_release -a
    No LSB modules are available.
    Distributor ID: Ubuntu
    Description:    Ubuntu 16.04.3 LTS
    Release:        16.04
    Codename:       xenial
    ```

    * Docker version:
    IE:
    ```bash
    user@host:~$ docker --version
    Docker version 17.05.0-ce, build 89658be
    ```

    * Labels from container:
    IE:
    ```bash
    user@host:~$ docker inspect edro/factorio:latest
    ...
                "Labels": {
                    "org.label-schema.build-date": "2017-10-17T18:24:31Z",
                    "org.label-schema.license": "Apache-2.0",
                    "org.label-schema.name": "Factorio Headless Server",
                    "org.label-schema.schema-version": "1.0",
                    "org.label-schema.url": "https://github.com/JustEdro/factorio",
                    "org.label-schema.vcs-ref": "003adec",
                    "org.label-schema.vcs-url": "https://github.com/JustEdro/factorio.git",
                    "org.label-schema.vendor": "Edro",
                    "org.label-schema.version": "0.15.37"
                }
    ...
    ```

    * Details on how to reproduce the trouble, if available:
