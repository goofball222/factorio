#!/usr/bin/env bash

# entrypoint-functions.sh script for Factorio headless server Docker container
# License: Apache-2.0
# Github: https://github.com/JustEdro/factorio
ENTRYPOINT_FUNCTIONS_VERSION="1.1.0"
# Last updated date: 2021-06-17

f_chkdir() {
    # Make sure required directories exist in ${VOLDIR} - IE: new install with empty volume on host mapped over default volume
    [ -d ${VOLDIR}/config ] || mkdir -p ${VOLDIR}/config
    [ -d ${VOLDIR}/mods ] || mkdir -p ${VOLDIR}/mods
    [ -d ${VOLDIR}/saves ] || mkdir -p ${VOLDIR}/saves
    [ -d ${VOLDIR}/scenarios ] || mkdir -p ${VOLDIR}/scenarios
}

f_chown() {
    if [ "${RUN_CHOWN}" == 'false' ]; then
        if [ ! "$(stat -c %u ${BASEDIR})" = "${PUID}" ] || [ ! "$(stat -c %u ${VOLDIR})" = "${PUID}" ] \
        || [ ! "$(stat -c %u ${VOLCONFIGDIR})" = "${PUID}" ] || [ ! "$(stat -c %u ${DATADIR})" = "${PUID}" ] \
        || [ ! "$(stat -c %u ${VOLMODDIR})" = "${PUID}" ] || [ ! "$(stat -c %u ${VOLSAVEDIR})" = "${PUID}" ] \
        || [ ! "$(stat -c %u ${VOLSCENARIODIR})" = "${PUID}" ]; then
            f_log "WARN - Configured PUID doesn't match owner of a required directory. Ignoring RUN_CHOWN=false"
            f_log "INFO - Ensuring permissions are correct before continuing - 'chown -R factorio:factorio ${BASEDIR} ${VOLDIR}'"
            f_log "INFO - Running recursive 'chown' on Docker overlay2 storage is **really** slow. This may take a bit."
            chown -R factorio:factorio ${BASEDIR} ${VOLDIR}
        else
            f_log "INFO - RUN_CHOWN set to 'false' - Not running 'chown -R factorio:factorio ${BASEDIR}', assume permissions are right."
        fi
    elif [ "${RUNAS_UID0}" == 'true' ]; then
        f_log "INFO - RUNAS_UID0=true - Not running 'chown -R factorio:factorio ${BASEDIR} ${VOLDIR}', no need to worry about permissions."
    else
        f_log "INFO - Ensuring permissions are correct before continuing - 'chown -R factorio:factorio ${BASEDIR}'"
        f_log "INFO - Running recursive 'chown' on Docker overlay2 storage is **really** slow. This may take a bit."
        chown -R factorio:factorio ${BASEDIR} ${VOLDIR}
    fi
}

f_giduid() {
    FACTORIO_GID=${FACTORIO_GID:-}
    FACTORIO_UID=${FACTORIO_UID:-}
    if [ ! -z "${FACTORIO_GID}" ]; then
        f_log "INFO - FACTORIO_GID is set. Please use the updated PGID variable. Automatically converting to PGID."
        PGID=${FACTORIO_GID}
    fi
    if [ ! -z "${FACTORIO_UID}" ]; then
        f_log "INFO - FACTORIO_UID is set. Please use the updated PUID variable. Automatically converting to PUID."
        PUID=${FACTORIO_UID}
    fi
    if [ "$(id factorio -g)" != "${PGID}" ] || [ "$(id factorio -u)" != "${PUID}" ]; then
        f_log "INFO - Setting custom factorio GID/UID: GID=${PGID}, UID=${PUID}"
        groupmod -o -g ${PGID} factorio
        usermod -o -u ${PUID} factorio
    else
        f_log "INFO - GID/UID for factorio are unchanged: GID=${PGID}, UID=${PUID}"
    fi
}

f_load_save() {
    # We avoid using --start-server-load-latest here, as the latest save might not be the desired one
    # Ex: If you change from scenario to default gameplay but forgot to delete scenario.zip it would be loaded instead of save.zip
    FACTORIO_OPTS="${FACTORIO_OPTS} --start-server ${SAVE_NAME} --server-settings ${CONFIGDIR}/server-settings.json --server-id ${CONFIGDIR}/server-id.json"
}

f_log() {
    echo "$(date +"[%Y-%m-%d %T,%3N]") <docker-entrypoint> $*"
}

f_setup() {
    FACTORIO_OPTS="${FACTORIO_OPTS:-}"
    FACTORIO_PORT=${FACTORIO_PORT:-}
    FACTORIO_RCON_PASSWORD=${FACTORIO_RCON_PASSWORD:-}
    FACTORIO_RCON_PORT=${FACTORIO_RCON_PORT:-27015}
    FACTORIO_SCENARIO=${FACTORIO_SCENARIO:-}
    if [ ! -z "${FACTORIO_PORT}" ]; then
        FACTORIO_OPTS="${FACTORIO_OPTS} --port ${FACTORIO_PORT}"
    fi

    f_log "INFO - Remove any incomplete *.tmp.zip from crash/forced exit in ${SAVEDIR}"
    rm -f ${SAVEDIR}/*.tmp.zip

    if [ ! -z "${FACTORIO_RCON_PASSWORD}" ]; then
        f_log "INFO - Using RCON password found in ENV"
        FACTORIO_RCON_PASSWORD=${FACTORIO_RCON_PASSWORD}
    else
        # Check for RCON password file, generate random and set if doesn't exist
        if [ ! -f "${CONFIGDIR}/RCON.pwd" ]; then
            f_log "INFO - No RCON.pwd found in ${CONFIGDIR}, generating random"
            set +o pipefail
            FACTORIO_RCON_PASSWORD=$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c16)
            set -o pipefail
            echo "${FACTORIO_RCON_PASSWORD}" > "${CONFIGDIR}/RCON.pwd"
            chown factorio:factorio ${CONFIGDIR}/RCON.pwd
        else
            f_log "INFO - Using existing RCON.pwd found in ${CONFIGDIR}"
            FACTORIO_RCON_PASSWORD=$(cat ${CONFIGDIR}/RCON.pwd)
        fi
    fi

    f_log "INFO - RCON password is '${FACTORIO_RCON_PASSWORD}'"
    FACTORIO_OPTS="${FACTORIO_OPTS} --rcon-port=${FACTORIO_RCON_PORT} --rcon-password ${FACTORIO_RCON_PASSWORD}"

    # Copy example configs to CONFIGDIR
    cp -p ${DATADIR}/server-settings.example.json ${CONFIGDIR}/server-settings.example.json
    f_log "INFO - Copied latest server-settings.example.json to ${CONFIGDIR}"
    cp -p ${DATADIR}/map-gen-settings.example.json ${CONFIGDIR}/map-gen-settings.example.json
    f_log "INFO - Copied latest map-gen-settings.example.json to ${CONFIGDIR}"

    # Copy example configs to working configuration if they don't exist
    if [ ! -f "${CONFIGDIR}/server-settings.json" ]; then
        f_log "WARN - No server-settings.json found in ${CONFIGDIR}, copying from example"
        cp -p ${DATADIR}/server-settings.example.json ${CONFIGDIR}/server-settings.json
    else
        f_log "INFO - Using existing server-settings.json found in ${CONFIGDIR}"
    fi

    if [ ! -f "${CONFIGDIR}/map-gen-settings.json" ]; then
        f_log "WARN - No map-gen-settings.json found in ${CONFIGDIR}, copying from example"
        cp -p ${DATADIR}/map-gen-settings.example.json ${CONFIGDIR}/map-gen-settings.json
    else
        f_log "INFO - Using existing map-gen-settings.json found in ${CONFIGDIR}"
    fi

    # Check for banlist file in config dir, set launch options to use if found
    if [ ! -f "${CONFIGDIR}/server-banlist.json" ]; then
        f_log "INFO - No server-banlist.json found in ${CONFIGDIR}, ignoring"
    else
        f_log "INFO - Using server-banlist.json found in ${CONFIGDIR}"
        FACTORIO_OPTS="${FACTORIO_OPTS} --server-banlist ${CONFIGDIR}/server-banlist.json"
    fi

    # Check for whitelist file in config dir, set launch options to use if found
    if [ ! -f "${CONFIGDIR}/server-whitelist.json" ]; then
        f_log "INFO - No server-whitelist.json found in ${CONFIGDIR}, ignoring"
    else
        f_log "INFO - Using server-whitelist.json found in ${CONFIGDIR}"
        FACTORIO_OPTS="${FACTORIO_OPTS} --server-whitelist ${CONFIGDIR}/server-whitelist.json --use-server-whitelist"
    fi

    # Check for admin list file in config dir, set launch options to use if found
    if [ ! -f "${CONFIGDIR}/server-adminlist.json" ]; then
        f_log "INFO - No server-adminlist.json found in ${CONFIGDIR}, ignoring"
    else
        f_log "INFO - Using server-adminlist.json found in ${CONFIGDIR}"
        FACTORIO_OPTS="${FACTORIO_OPTS} --server-adminlist ${CONFIGDIR}/server-adminlist.json"
    fi

    # Choose save file name. Scenario saves are named as the scenario itself.
    if [ ! -z "${FACTORIO_SCENARIO}" ]; then
        SAVE_NAME="${FACTORIO_SCENARIO}"
    else
        SAVE_NAME="save"
    fi

    # Check for existing save file, use if found. Generate new with settings if not.
    if [ ! -f "${SAVEDIR}/${SAVE_NAME}.zip" ]; then
        f_log "WARN - No ${SAVE_NAME}.zip found in ${SAVEDIR}"
        f_log "INFO - Creating new map / ${SAVE_NAME}.zip in ${SAVEDIR} with settings from ${CONFIGDIR}/map-gen-settings.json"
        if [ ! -z "${FACTORIO_SCENARIO}" ]; then
            FACTORIO_OPTS="${FACTORIO_OPTS} --start-server-load-scenario ${FACTORIO_SCENARIO} --server-settings ${CONFIGDIR}/server-settings.json --server-id ${CONFIGDIR}/server-id.json"
        else
            if [ -x "/sbin/su-exec" ]; then
                su-exec factorio:factorio ${FACTORIO} --create ${VOLSAVEDIR}/save.zip --map-gen-settings ${CONFIGDIR}/map-gen-settings.json
                f_load_save
            elif [ -x "/usr/sbin/gosu" ]; then
                gosu factorio:factorio ${FACTORIO} --create ${VOLSAVEDIR}/save.zip --map-gen-settings ${CONFIGDIR}/map-gen-settings.json
                f_load_save
            else
                f_log "ERROR - su-exec/gosu NOT FOUND. Run state is invalid. Exiting."
                exit 1;
            fi
        fi
    else
        f_log "INFO - Loading ${SAVE_NAME}.zip found in ${SAVEDIR}"
        f_load_save
    fi

}
