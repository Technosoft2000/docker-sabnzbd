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
echo "[INFO] Current git version is:" && git version
echo "[INFO] Checkout the latest SABnzbd version ..."
if [ ! -d $SABNZBD_HOME/app/.git ]; then
    # clone the repository
    echo "[INFO] ... git clone -b $SABNZBD_BRANCH --single-branch $SABNZBD_REPO $SABNZBD_HOME/app -v"
    gosu $PUSER:$PGROUP bash -c "git clone -b $SABNZBD_BRANCH --single-branch $SABNZBD_REPO $SABNZBD_HOME/app -v"
    # build multi-language support
	echo "[INFO] ... build multi-language support"
    python $SABNZBD_HOME/app/tools/make_mo.py
fi

# opt out for autoupdates using env variable
if [ -z "$ADVANCED_DISABLEUPDATES" ]; then
	echo "[INFO] Autoupdate is active, try to pull the latest sources ..."
	cd $SABNZBD_HOME/app/
	echo "[INFO] ... current git status is"
    gosu $PUSER:$PGROUP bash -c "git status && git rev-parse $SABNZBD_BRANCH"
    echo "[INFO] ... pulling sources"
    gosu $PUSER:$PGROUP bash -c "git pull"
    echo "[INFO] ... git status after update is"
    gosu $PUSER:$PGROUP bash -c "git status && git rev-parse $SABNZBD_BRANCH"
fi

# download the latest version of the nzbToMedia release
# see at https://github.com/clinton-hall/nzbToMedia.git
echo "[INFO] Checkout the latest nzbToMedia version ..."
if [ ! -d $SABNZBD_HOME/config/scripts/.git ]; then
    echo "[INFO] ... git clone https://github.com/clinton-hall/nzbToMedia.git $SABNZBD_HOME/config/scripts -v"
    gosu $PUSER:$PGROUP bash -c "git clone https://github.com/clinton-hall/nzbToMedia.git $SABNZBD_HOME/config/scripts -v"
fi

# opt out for autoupdates using env variable
if [ -z "$ADVANCED_DISABLEUPDATES" ]; then
	echo "[INFO] Autoupdate is active, try to pull the latest sources ..."
	cd $SABNZBD_HOME/config/scripts/
	echo "[INFO] ... current git status is"
    gosu $PUSER:$PGROUP bash -c "git status && git rev-parse HEAD"
    echo "[INFO] ... pulling sources"
    gosu $PUSER:$PGROUP bash -c "git pull"
    echo "[INFO] ... git status after update is"
    gosu $PUSER:$PGROUP bash -c "git status && git rev-parse HEAD"
fi
	
# run sabnzbd
echo "[INFO] Launching SABnzbd ..."
gosu $PUSER:$PGROUP bash -c "/usr/bin/python $SABNZBD_HOME/app/SABnzbd.py -f $SABNZBD_HOME/config -s 0.0.0.0:8080"
