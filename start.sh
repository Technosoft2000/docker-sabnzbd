#!/bin/bash

#show the info text
cat $SABNZBD_HOME/info.txt
echo "[INFO] Docker image version: $VERSION"

#run the default config script
source $SABNZBD_HOME/config.sh

#chown the SABnzbd directory by the new user
echo "[INFO] Change the ownership of $SABNZBD_HOME (including subfolders) to $PUSER:$PGROUP"
chown $PUSER:$PGROUP -R $SABNZBD_HOME

# download the latest version of the SABnzbd release
# see at https://github.com/sabnzbd/sabnzbd
source $SABNZBD_HOME/checkout.sh "SABnzbd" "$SABNZBD_BRANCH" "$SABNZBD_REPO" "$SABNZBD_HOME/app"

# build multi-language support
echo "[INFO] ... build multi-language support"
python $SABNZBD_HOME/app/tools/make_mo.py

# download the latest version of the nzbToMedia release
# see at https://github.com/clinton-hall/nzbToMedia.git
source $SABNZBD_HOME/checkout.sh "nzbToMedia" "$NZBTOMEDIA_BRANCH" "$NZBTOMEDIA_REPO" "$SABNZBD_HOME/config/scripts"

# run sabnzbd
echo "[INFO] Launching SABnzbd ..."
gosu $PUSER:$PGROUP bash -c "/usr/bin/python $SABNZBD_HOME/app/SABnzbd.py -f $SABNZBD_HOME/config -s 0.0.0.0:8080"
