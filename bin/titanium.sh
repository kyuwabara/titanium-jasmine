#!/bin/bash

# Utility script to start Titanium Mobile project from the command line.
# More info at http://github.com/guilhermechapiewski/titanium-jasmine

PROJECT_NAME=${PROJECT_NAME}
PROJECT_ROOT=${PROJECT_ROOT:-../}
APP_DEVICE=${DEVICE_TYPE}
TI_SDK_VERSION="1.7.3"
TI_DIR="/Library/Application\ Support/Titanium"

# Both iOS and Android SDKs are linked in this directory
TI_ASSETS_DIR="${TI_DIR}/mobilesdk/osx/${TI_SDK_VERSION}"

# iPhone settings
IPHONE_SDK_VERSION="4.2"
TI_IPHONE_DIR="${TI_ASSETS_DIR}/iphone"
TI_IPHONE_BUILD="${TI_IPHONE_DIR}/builder.py"

# Android settings
ANDROID_SDK_VERSION="2.3"
ANDROID_ADB_ID="10"
TI_ANDROID_DIR="${TI_ASSETS_DIR}/android"
TI_ANDROID_BUILD="${TI_ANDROID_DIR}/builder.py"
ANDROID_SDK_PATH='/usr/local/Cellar/android-sdk/r12'

if [ "PROJECT_NAME" == "" ]; then
	echo "[ERROR] Please inform PROJECT_NAME."
	exit 1
fi

if [ "DEVICE_TYPE" == "" ]; then
	echo "[ERROR] Please inform DEVICE_TYPE ('ipad' or 'iphone' or 'android')."
	exit 1
fi

# Get APP parameters from current tiapp.xml
APP_ID=`cat ${PROJECT_NAME}/tiapp.xml | grep "<id>" | sed -e "s/<\/*id>//g"`
APP_NAME=`cat ${PROJECT_NAME}/tiapp.xml | grep "<name>" | sed -e "s/<\/*name>//g"`

if [ "APP_ID" == "" ] || [ "APP_NAME" == "" ]; then
	echo "[ERROR] Could not obtain APP parameters from tiapp.xml file (does the file exist?)."
	exit 1
fi

if [ ${APP_DEVICE} == "iphone" ]; then
	killall "iPhone Simulator"
	bash -c "${TI_IPHONE_BUILD} run ${PROJECT_ROOT}/${PROJECT_NAME}/ ${IPHONE_SDK_VERSION} ${APP_ID} ${APP_NAME} ${APP_DEVICE}"
elif [ ${APP_DEVICE} == "android" ]; then
	ARGS="${APP_NAME}  ${ANDROID_SDK_PATH} ${PROJECT_ROOT}/${PROJECT_NAME}/ ${APP_ID} ${ANDROID_ADB_ID"
	bash -c "${TI_ANDROID_BUILD} simulator ${ARGS}"
else
	echo "not supported!"
	echo ${APP_DEVICE}
fi

perl -pe 's/^\[DEBUG\].*$/\e[35m$&\e[0m/g;s/^\[INFO\].*$/\e[36m$&\e[0m/g;s/^\[WARN\].*$/\e[33m$&\e[0m/g;s/^\[ERROR\].*$/\e[31m$&\e[0m/g;'