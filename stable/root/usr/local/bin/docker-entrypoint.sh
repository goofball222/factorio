#!/usr/bin/env bash

# Init script for Factorio headless server Docker container
# License: Apache-2.0
# Github: https://github.com/goofball222/factorio.git
SCRIPT_VERSION="1.2.1"
# Last updated date: 2019-09-27

set -Eeuo pipefail

if [ "${DEBUG}" == 'true' ];
    then
        set -x
fi

log() {
    echo "$(date -u +%FT$(nmeter -d0 '%3t' | head -n1)) <docker-entrypoint> $*"
}

log "INFO - Script version ${SCRIPT_VERSION}"

FACTORIO_GID=${FACTORIO_GID:-}
FACTORIO_UID=${FACTORIO_UID:-}

FACTORIO_OPTS="${FACTORIO_OPTS:-}"

FACTORIO_PORT=${FACTORIO_PORT:-}

FACTORIO_RCON_PASSWORD=${FACTORIO_RCON_PASSWORD:-}

FACTORIO_RCON_PORT=${FACTORIO_RCON_PORT:-27015}

FACTORIO_SCENARIO=${FACTORIO_SCENARIO:-}

if [ ! -z "${FACTORIO_GID}" ]; then
    log "INFO - FACTORIO_GID is set to '${FACTORIO_GID}'. Please update to the PGID env variable."
    log "INFO - Automatically converting FACTORIO_GID to PGID."
    PGID=${FACTORIO_GID}
fi
if [ ! -z "${FACTORIO_UID}" ]; then
    log "INFO - FACTORIO_UID is set to '${FACTORIO_UID}'. Please update to the PUID env variable."
    log "INFO - Automatically converting FACTORIO_UID to PUID."
    PUID=${FACTORIO_UID}
fi

BASEDIR="/opt/factorio"
BINDIR=${BASEDIR}/bin
DATADIR=${BASEDIR}/data
CONFIGDIR=${BASEDIR}/config
MODDIR=${BASEDIR}/mods
SAVEDIR=${BASEDIR}/saves
SCENARIODIR=${BASEDIR}/scenarios

FACTORIO=${BINDIR}/x64/factorio

VOLDIR="/factorio"

cd ${BASEDIR}

do_chown() {
    if [ "${RUN_CHOWN}" == 'false' ]; then
        if [ ! "$(stat -c %u ${BASEDIR})" = "${PUID}" ] || [ ! "$(stat -c %u ${VOLDIR})" = "${PUID}" ] \
        || [ ! "$(stat -c %u ${CONFIGDIR})" = "${PUID}" ] || [ ! "$(stat -c %u ${DATADIR})" = "${PUID}" ] \
        || [ ! "$(stat -c %u ${MODDIR})" = "${PUID}" ] || [ ! "$(stat -c %u ${SAVEDIR})" = "${PUID}" ] \
        || [ ! "$(stat -c %u ${SCENARIODIR})" = "${PUID}" ]; then
            log "WARN - Configured PUID doesn't match owner of a required directory. Ignoring RUN_CHOWN=false"
            log "INFO - Ensuring permissions are correct before continuing - 'chown -R factorio:factorio ${BASEDIR}'"
            log "INFO - Running recursive 'chown' on Docker overlay2 storage is **really** slow. This may take a bit."
            chown -R factorio:factorio ${BASEDIR} ${VOLDIR}
        else
            log "INFO - RUN_CHOWN set to 'false' - Not running 'chown -R factorio:factorio ${BASEDIR}', assume permissions are right."
        fi
    else
        log "INFO - Ensuring permissions are correct before continuing - 'chown -R factorio:factorio ${BASEDIR}'"
        log "INFO - Running recursive 'chown' on Docker overlay2 storage is **really** slow. This may take a bit."
        chown -R factorio:factorio ${BASEDIR} ${VOLDIR}
    fi
}

factorio_setup() {

    if [ ! -z "${FACTORIO_PORT}" ];
        then
            FACTORIO_OPTS="${FACTORIO_OPTS} --port ${FACTORIO_PORT}"
    fi

    log "INFO - Remove any incomplete *.tmp.zip from crash/forced exit in ${SAVEDIR}"
    rm -f ${SAVEDIR}/*.tmp.zip

    if [ ! -z "${FACTORIO_RCON_PASSWORD}" ];
        then
            log "INFO - Using RCON password found in ENV"
            FACTORIO_RCON_PASSWORD=${FACTORIO_RCON_PASSWORD}
        else
            # Check for RCON password file, generate random and set if doesn't exist
            if [ ! -f "${CONFIGDIR}/RCON.pwd" ];
                then
                    log "INFO - No RCON.pwd found in ${CONFIGDIR}, generating random"
                    set +o pipefail
                    FACTORIO_RCON_PASSWORD=$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c16)
                    set -o pipefail
                    echo "${FACTORIO_RCON_PASSWORD}" > "${CONFIGDIR}/RCON.pwd"
                    chown factorio:factorio ${CONFIGDIR}/RCON.pwd
                else
                    log "INFO - Using existing RCON.pwd found in ${CONFIGDIR}"
                    FACTORIO_RCON_PASSWORD=$(cat ${CONFIGDIR}/RCON.pwd)
            fi
    fi

    log "INFO - RCON password is '${FACTORIO_RCON_PASSWORD}'"
    FACTORIO_OPTS="${FACTORIO_OPTS} --rcon-port=${FACTORIO_RCON_PORT} --rcon-password ${FACTORIO_RCON_PASSWORD}"

    # Copy example configs to CONFIGDIR
    cp -p ${DATADIR}/server-settings.example.json ${CONFIGDIR}/server-settings.example.json
    log "INFO - Copied latest server-settings.example.json to ${CONFIGDIR}"
    cp -p ${DATADIR}/map-gen-settings.example.json ${CONFIGDIR}/map-gen-settings.example.json
    log "INFO - Copied latest map-gen-settings.example.json to ${CONFIGDIR}"

    # Copy example configs to working configuration if they don't exist
    if [ ! -f "${CONFIGDIR}/server-settings.json" ];
        then
            log "WARN - No server-settings.json found in ${CONFIGDIR}, copying from example"
            cp -p ${DATADIR}/server-settings.example.json ${CONFIGDIR}/server-settings.json
        else
            log "INFO - Using existing server-settings.json found in ${CONFIGDIR}"
    fi

    if [ ! -f "${CONFIGDIR}/map-gen-settings.json" ];
        then
            log "WARN - No map-gen-settings.json found in ${CONFIGDIR}, copying from example"
            cp -p ${DATADIR}/map-gen-settings.example.json ${CONFIGDIR}/map-gen-settings.json
        else
            log "INFO - Using existing map-gen-settings.json found in ${CONFIGDIR}"
    fi

    # Check for banlist file in config dir, set launch options to use if found
    if [ ! -f "${CONFIGDIR}/server-banlist.json" ];
        then
            log "INFO - No server-banlist.json found in ${CONFIGDIR}, ignoring"
        else
            log "INFO - Using server-banlist.json found in ${CONFIGDIR}"
            FACTORIO_OPTS="${FACTORIO_OPTS} --server-banlist ${CONFIGDIR}/server-banlist.json"
    fi

    # Check for whitelist file in config dir, set launch options to use if found
    if [ ! -f "${CONFIGDIR}/server-whitelist.json" ];
        then
            log "INFO - No server-whitelist.json found in ${CONFIGDIR}, ignoring"
        else
            log "INFO - Using server-whitelist.json found in ${CONFIGDIR}"
            FACTORIO_OPTS="${FACTORIO_OPTS} --server-whitelist ${CONFIGDIR}/server-whitelist.json --use-server-whitelist"
    fi

    # Check for admin list file in config dir, set launch options to use if found
    if [ ! -f "${CONFIGDIR}/server-adminlist.json" ];
        then
            log "INFO - No server-adminlist.json found in ${CONFIGDIR}, ignoring"
        else
            log "INFO - Using server-adminlist.json found in ${CONFIGDIR}"
            FACTORIO_OPTS="${FACTORIO_OPTS} --server-adminlist ${CONFIGDIR}/server-adminlist.json"
    fi

    if [ ! -z "${FACTORIO_SCENARIO}" ];
        then
            log "INFO - Scenario ${FACTORIO_SCENARIO} configured, starting Factorio in scenario loading mode"
            FACTORIO_OPTS="${FACTORIO_OPTS} --start-server-load-scenario ${FACTORIO_SCENARIO} --server-settings ${CONFIGDIR}/server-settings.json --server-id ${CONFIGDIR}/server-id.json"
        else
            # Check for existing save.zip, use if found. Generate new with settings if not.
            if [ ! -f "${SAVEDIR}/save.zip" ];
                then
                    log "WARN - No save.zip found in ${SAVEDIR}"
                    log "INFO - Creating new map / save.zip in ${SAVEDIR} with settings from ${CONFIGDIR}/map-gen-settings.json"
                    su-exec factorio:factorio ${FACTORIO} --create ${SAVEDIR}/save.zip --map-gen-settings ${CONFIGDIR}/map-gen-settings.json
                else
                    log "INFO - Loading save.zip found in ${SAVEDIR}"
            fi
            FACTORIO_OPTS="${FACTORIO_OPTS} --start-server-load-latest --server-settings ${CONFIGDIR}/server-settings.json --server-id ${CONFIGDIR}/server-id.json"
    fi

}

exit_handler() {
    log "INFO - Exit signal received, commencing shutdown"
    pkill -15 -f ${FACTORIO}
    for i in `seq 0 9`;
        do
            [ -z "$(pgrep -f ${FACTORIO})" ] && break
            # kill it with fire if it hasn't stopped itself after 9 seconds
            [ $i -gt 8 ] && pkill -9 -f ${FACTORIO} || true
            sleep 1
    done
    log "INFO - Shutdown complete. Nothing more to see here. Have a nice day!"
    log "INFO - Exit with status code ${?}"
    exit ${?};
}

# Wait indefinitely on tail until killed
idle_handler() {
    while true
    do
        tail -f /dev/null & wait ${!}
    done
}

trap 'kill ${!}; exit_handler' SIGHUP SIGINT SIGQUIT SIGTERM

if [ "$(id -u)" = '0' ];
    then
        log "INFO - Entrypoint running with UID 0 (root)"
        if [ "$(id factorio -g)" != "${PGID}" ] || [ "$(id factorio -u)" != "${PUID}" ];
            then
                log "INFO - Setting custom factorio GID/UID: GID=${PGID}, UID=${PUID}"
                groupmod -o -g ${PGID} factorio
                usermod -o -u ${PUID} factorio
            else
                log "INFO - GID/UID for factorio are unchanged: GID=${PGID}, UID=${PUID}"
        fi

        if [[ "${@}" == 'factorio' ]];
            then
                do_chown
                factorio_setup
                if [ "${RUNAS_UID0}" == 'true' ];
                    then
                       log "INFO - RUNAS_UID0 = 'true', running Factorio Headless as UID 0 (root)"
                       log "WARN - ======================================================================"
                       log "WARN - *** Running app as UID 0 (root) is an insecure configuration ***"
                       log "WARN - ======================================================================"
                       log "EXEC - ${FACTORIO} ${FACTORIO_OPTS}"
                       exec 0<&-
                       exec ${FACTORIO} ${FACTORIO_OPTS} &
                       idle_handler
                fi

                log "INFO - Use su-exec to drop priveleges and start Factorio Headless as GID=${PGID}, UID=${PUID}"
                log "EXEC - su-exec factorio:factorio ${FACTORIO} ${FACTORIO_OPTS}"
                exec 0<&-
                exec su-exec factorio:factorio ${FACTORIO} ${FACTORIO_OPTS} &
                idle_handler
            else
                log "EXEC - ${@} as UID 0 (root)"
                exec "${@}"
        fi
    else
        log "WARN - Container/entrypoint not started as UID 0 (root)"
        log "WARN - Unable to change permissions or set custom GID/UID if configured"
        log "WARN - Process will be spawned with GID=$(id -g), PID=$(id -u)"
        log "WARN - Depending on permissions requested command may not work"
        if [[ "${@}" == 'factorio' ]];
            then
                factorio_setup
                exec 0<&-
                log "EXEC - ${FACTORIO} ${FACTORIO_OPTS}"
                exec ${FACTORIO} ${FACTORIO_OPTS} &
                idle_handler
            else
                log "EXEC - ${@}"
                exec "${@}"
        fi
fi

# Script should never make it here, but just in case exit with a generic error code if it does
exit 1;
