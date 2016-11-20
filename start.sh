#!/bin/bash

#show the info text
cat $SABNZBD_HOME/info.txt

#run the default config script
source $SABNZBD_HOME/config.sh

#chown the SABnzbd directory by the new user
echo "[INFO] Change the ownership of $SABNZBD_HOME (including subfolders) to $PUSER:$PGROUP"
chown $PUSER:$PGROUP -R $SABNZBD_HOME

# download the latest version of the SABnzbd release
# see at https://github.com/sabnzbd/sabnzbd
echo "[INFO] Checkout the latest SABnzbd version ..."
[[ ! -d $SABNZBD_HOME/app/.git ]] && \
gosu $PUSER:$PGROUP bash -c "git clone -b $SABNZBD_BRANCH $SABNZBD_REPO $SABNZBD_HOME/app" && \
# build multi-language support
python $SABNZBD_HOME/app/tools/make_mo.py

# opt out for autoupdates using env variable
if [ -z "$ADVANCED_DISABLEUPDATES" ]; then
        echo "[INFO] Autoupdate is active, try to pull the latest sources ..."
    # update the application
    cd $SABNZBD_HOME/app/ && gosu $PUSER:$PGROUP bash -c "git pull"
fi

# run sabnzbd
echo "[INFO] Launching SABnzbd ..."
gosu $PUSER:$PGROUP bash -c "/usr/bin/python $SABNZBD_HOME/app/SABnzbd.py -f $SABNZBD_HOME/config -s 0.0.0.0:8080"
