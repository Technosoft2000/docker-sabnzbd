#!/bin/bash

# get or update all parts for the APP

# download the latest version of the SABnzbd
# see at https://github.com/sabnzbd/sabnzbd
APP_VERSION_FILE=$APP_HOME/app/sabnzbd/version.py
if [ -f $APP_VERSION_FILE ]; then
   echo "[INFO] Revert the patched $APP_VERSION_FILE to have the possibility to get the updated sources"
   gosu $PUSER:$PGROUP bash -c "git checkout -- $APP_VERSION_FILE"
fi
source /init/checkout.sh "$APP_NAME" "$APP_BRANCH" "$APP_REPO" "$APP_HOME/app"

# update the version information at SABnzbd
echo "[INFO] ... update the version information at SABnzbd - patching $APP_VERSION_FILE"
sed -i -e 's/__version__ = ".*"/__version__ = "'$APP_BRANCH'"/g' $APP_VERSION_FILE
APP_VERSION_HASH_LONG=`git rev-parse HEAD`
APP_VERSION_HASH_SHORT=`git rev-parse --short HEAD`
sed -i -e 's/__baseline__ = ".*"/__baseline__ = "'$APP_VERSION_HASH_LONG'"/g' $APP_VERSION_FILE
echo "[INFO] ... $APP_NAME version: $APP_BRANCH [$APP_VERSION_HASH_SHORT]"

# build multi-language support
echo "[INFO] ... build multi-language support"
python $APP_HOME/app/tools/make_mo.py

# download the latest version of the nzbToMedia
# see at https://github.com/clinton-hall/nzbToMedia.git
source /init/checkout.sh "nzbToMedia" "$NZBTOMEDIA_BRANCH" "$NZBTOMEDIA_REPO" "$APP_HOME/config/scripts"
