#!/bin/bash
cd /home/container
sleep 1
# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH

# BepInEx-specific settings
export DOORSTOP_ENABLE=TRUE
export DOORSTOP_INVOKE_DLL_PATH="$PATH:$HOME/BepInEx/core/BepInEx.Preloader.dll"
export DOORSTOP_INVOKE_DLL_PATH="$PATH:$HOME/BepInEx/core/BepInEx.Preloader.dll"
export DOORSTOP_CORLIB_OVERRIDE_PATH="$PATH:$HOME/unstripped_corlib"

export LD_LIBRARY_PATH="$PATH:$HOME/doorstop_libs:$LD_LIBRARY_PATH"
export LD_PRELOAD=libdoorstop_x64.so:$LD_PRELOAD

export templdpath=$LD_LIBRARY_PATH

## just in case someone removed the defaults.
if [ "${STEAM_USER}" == "" ]; then
    echo -e "Steam User is not set.\n"
    echo -e "Using anonymous user.\n"
    STEAM_USER=anonymous
    STEAM_PASS=""
    STEAM_AUTH=""
else
    echo -e "user set to ${STEAM_USER}"
fi

## if auto_update is not set or to 1 update
if [ -z ${AUTO_UPDATE} ] || [ "${AUTO_UPDATE}" == "1" ]; then
    # Update Source Server
    if [ ! -z ${SRCDS_APPID} ]; then
        ./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH}  +force_install_dir /home/container +app_update ${SRCDS_APPID} $( [[ -z ${SRCDS_BETAID} ]] || printf %s "-beta ${SRCDS_BETAID}" ) $( [[ -z ${SRCDS_BETAPASS} ]] || printf %s "-betapassword ${SRCDS_BETAPASS}" ) $( [[ -z ${HLDS_GAME} ]] || printf %s "+app_set_config 90 mod ${HLDS_GAME}" ) $( [[ -z ${VALIDATE} ]] || printf %s "validate" ) +quit
    else
        echo -e "No appid set. Starting Server"
    fi

else
    echo -e "Not updating game server as auto update was set to 0. Starting Server"
fi

# Replace Startup Variables
MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
