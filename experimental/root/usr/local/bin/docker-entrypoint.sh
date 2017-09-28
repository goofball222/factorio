#!/usr/bin/env bash

# Init script for Factorio headless server Docker container
# License: Apache-2.0
# Github: https://github.com/goofball222/factorio.git
SCRIPT_VERSION="0.2.5"
# Last updated date: 2017-09-28

set -Eeuo pipefail

if [ "${DEBUG}" == 'true' ];
    then
        set -x
fi

log() {
    echo "$(date -u +%FT$(nmeter -d0 '%3t' | head -n1)) <docker-entrypoint> $*"
}

log "INFO - Script version ${SCRIPT_VERSION}"

BASEDIR="/opt/factorio"
BINDIR=${BASEDIR}/bin
CONFIGDIR=${BASEDIR}/config
DATADIR=${BASEDIR}/data
SAVEDIR=${BASEDIR}/saves

FACTORIO=${BINDIR}/x64/factorio

FACTORIO_RCON_PORT="27015"

FACTORIO_OPTS="${FACTORIO_OPTS}"

cd ${BASEDIR}

factorio_setup() {

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
                else
                    log "INFO - Using existing RCON.pwd found in ${CONFIGDIR}"
                    FACTORIO_RCON_PASSWORD=$(cat ${CONFIGDIR}/RCON.pwd)
            fi
    fi

    log "INFO - RCON password is '${FACTORIO_RCON_PASSWORD}'"
    FACTORIO_OPTS="${FACTORIO_OPTS} --rcon-password $FACTORIO_RCON_PASSWORD --rcon-port ${FACTORIO_RCON_PORT}"

    # Copy example configs to CONFIGDIR
    cp ${DATADIR}/server-settings.example.json ${CONFIGDIR}/server-settings.example.json
    log "INFO - Copied latest server-settings.example.json to ${CONFIGDIR}"
    cp ${DATADIR}/map-gen-settings.example.json ${CONFIGDIR}/map-gen-settings.example.json
    log "INFO - Copied latest map-gen-settings.example.json to ${CONFIGDIR}"

    # Copy example configs to working configuration if they don't exist
    if [ ! -f "${CONFIGDIR}/server-settings.json" ];
        then
            log "WARN - No server-settings.json found in ${CONFIGDIR}, copying from example"
            cp ${DATADIR}/server-settings.example.json ${CONFIGDIR}/server-settings.json
        else
            log "INFO - Using existing server-settings.json found in ${CONFIGDIR}"
    fi

    if [ ! -f "${CONFIGDIR}/map-gen-settings.json" ];
        then
            log "WARN - No map-gen-settings.json found in ${CONFIGDIR}, copying from example"
            cp ${DATADIR}/map-gen-settings.example.json ${CONFIGDIR}/map-gen-settings.json
        else
            log "INFO - Using existing map-gen-settings.json found in ${CONFIGDIR}"
    fi

    # Check for existing map / save.zip, use if found. Generate new with settings if not.
    if [ ! -f "${SAVEDIR}/save.zip" ];
        then
            log "WARN - No save.zip found in ${SAVEDIR}"
            log "INFO - Creating new map / save.zip in ${SAVEDIR} with settings from ${CONFIGDIR}/map-gen-settings.json"
            ${FACTORIO} --create ${SAVEDIR}/save.zip --map-gen-settings ${CONFIGDIR}/map-gen-settings.json
        else
            log "INFO - Loading save.zip found in ${SAVEDIR}"
    fi

    log "INFO - Ensuring file permissions for factorio user/group - 'chown -R factorio:factorio ${BASEDIR}'"
    chown -R factorio:factorio ${BASEDIR}

    FACTORIO_OPTS="${FACTORIO_OPTS} --start-server-load-latest --server-settings ${CONFIGDIR}/server-settings.json"
}

exit_handler() {
    log "INFO - Exit signal received, commencing shutdown"
    pkill -15 -f ${BINDIR}/x64/factorio
    for i in `seq 0 9`;
        do
            [ -z "$(pgrep -f ${BINDIR}/x64/factorio)" ] && break
            # kill it with fire if it hasn't stopped itself after 9 seconds
            [ $i -gt 8 ] && pkill -9 -f ${BINDIR}/x64/factorio || true
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
        if [ "$(id factorio -u)" != "${FACTORIO_UID}" ] || [ "$(id factorio -g)" != "${FACTORIO_GID}" ];
            then
                log "INFO - Setting custom factorio UID/GID: UID=${FACTORIO_UID}, GID=${FACTORIO_GID}"
                usermod -u ${FACTORIO_UID} factorio && groupmod -g ${FACTORIO_GID} factorio
            else
                log "INFO - UID/GID for factorio are unchanged: UID=${FACTORIO_UID}, GID=${FACTORIO_GID}"
        fi

        if [[ "${@}" == 'factorio' ]];
            then
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

                log "INFO - Use su-exec to drop priveleges and start Factorio Headless as UID=${FACTORIO_UID}, GID=${FACTORIO_GID}"
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
        log "WARN - Unable to change permissions or set custom UID/GID if configured"
        log "WARN - Process will be spawned with UID=$(id -u), GID=$(id -g)"
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