#!/bin/bash

# launch the APP
echo "[INFO] Launching $APP_NAME ..."
gosu $PUSER:$PGROUP bash -c "/usr/bin/python $APP_HOME/app/SABnzbd.py -f $APP_HOME/config -s 0.0.0.0:8080"
