#!/usr/bin/env bash

# Init script for Factorio headless server Docker container
# License: Apache-2.0
# Github: https://github.com/JustEdro/factorio
SCRIPT_VERSION="1.4.1"
# Last updated date: 2022-03-12

set -Eeuo pipefail

if [ "${DEBUG}" == 'true' ];
    then
        set -x
fi

. /usr/local/bin/entrypoint-functions.sh

BASEDIR="/opt/factorio"
BINDIR=${BASEDIR}/bin
DATADIR=${BASEDIR}/data
CONFIGDIR=${BASEDIR}/config
MODDIR=${BASEDIR}/mods
SAVEDIR=${BASEDIR}/saves
SCENARIODIR=${BASEDIR}/scenarios

FACTORIO=${BINDIR}/x64/factorio

VOLDIR=${VOLDIR:-"/factorio"}
VOLCONFIGDIR=${VOLDIR}/config
VOLMODDIR=${VOLDIR}/mods
VOLSAVEDIR=${VOLDIR}/saves
VOLSCENARIODIR=${VOLDIR}/scenarios

f_log "INFO - Script version ${SCRIPT_VERSION}"
f_log "INFO - Entrypoint functions version ${ENTRYPOINT_FUNCTIONS_VERSION}"

cd ${BASEDIR}

f_exit_handler() {
    f_log "INFO - Exit signal received, commencing shutdown"
    pkill -15 -f ${FACTORIO}
    for i in `seq 0 299`;
        do
            [ -z "$(pgrep -f ${FACTORIO})" ] && break
            # kill it with fire if it hasn't stopped itself after 5 minutes
            [ $i -gt 298 ] && pkill -9 -f ${FACTORIO} || true
            sleep 1
    done
    f_log "INFO - Shutdown complete. Nothing more to see here. Have a nice day!"
    f_log "INFO - Exit with status code ${?}"
    exit ${?};
}

f_idle_handler() {
    while true
    do
        tail -f /dev/null & wait ${!}
    done
}

trap 'kill ${!}; f_exit_handler' SIGHUP SIGINT SIGQUIT SIGTERM

if [ "$(id -u)" = '0' ]; then
    f_log "INFO - Entrypoint running with UID 0 (root)"
    if [[ "${@}" == 'factorio' ]]; then
        f_giduid
        f_chkdir
        f_chown
        f_setup
        if [ "${RUNAS_UID0}" == 'true' ]; then
            f_log "INFO - RUNAS_UID0 = 'true', running Factorio Headless as UID 0 (root)"
            f_log "WARN - ======================================================================"
            f_log "WARN - *** Running app as UID 0 (root) is an insecure configuration ***"
            f_log "WARN - ======================================================================"
            f_log "EXEC - ${FACTORIO} ${FACTORIO_OPTS}"
            exec 0<&-
            exec ${FACTORIO} ${FACTORIO_OPTS} &
            f_idle_handler
        else
            if [ -x "/sbin/su-exec" ]; then
                f_log "INFO - Use su-exec to drop priveleges and start Factorio Headless as GID=${PGID}, UID=${PUID}"
                f_log "EXEC - su-exec factorio:factorio ${FACTORIO} ${FACTORIO_OPTS}"
                exec 0<&-
                exec su-exec factorio:factorio ${FACTORIO} ${FACTORIO_OPTS} &
                f_idle_handler
            elif [ -x "/usr/sbin/gosu" ]; then
                f_log "INFO - Use gosu to drop privileges and start Factorio Headless as GID=${PGID}, UID=${PUID}"
                f_log "EXEC - gosu factorio:factorio ${FACTORIO} ${FACTORIO_OPTS}"
                exec 0<&-
                exec gosu factorio:factorio ${FACTORIO} ${FACTORIO_OPTS} &
                f_idle_handler
            else
                f_log "ERROR - su-exec/gosu NOT FOUND. Run state is invalid. Exiting."
                exit 1;
            fi
        fi
    else
        f_log "EXEC - ${@} as UID 0 (root)"
        exec "${@}"
    fi
else
    f_log "WARN - Container/entrypoint not started as UID 0 (root)"
    f_log "WARN - Unable to change permissions or set custom GID/UID if configured"
    f_log "WARN - Process will be spawned with GID=$(id -g), PID=$(id -u)"
    f_log "WARN - Depending on permissions requested command may not work"
    if [[ "${@}" == 'factorio' ]]; then
        f_chkdir
        f_setup
        f_log "EXEC - ${FACTORIO} ${FACTORIO_OPTS}"
        exec 0<&-
        exec ${FACTORIO} ${FACTORIO_OPTS} &
        f_idle_handler
    else
        f_log "EXEC - ${@}"
        exec "${@}"
    fi
fi

# Script should never make it here, but just in case exit with a generic error code if it does
exit 1;
