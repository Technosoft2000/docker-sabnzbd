FROM alpine:3.5
MAINTAINER Technosoft2000 <technosoft2000@gmx.net>
LABEL image.version="1.1.0" \
      image.description="Docker image for SABnzbd, based on docker image of Alpine" \
	  image.date="2017-01-04" \
	  url.docker="https://hub.docker.com/r/technosoft2000/sabnzbd" \
	  url.github="https://github.com/Technosoft2000/docker-sabnzbd" \
	  url.support="https://cytec.us/forum"

# Set basic environment settings

ENV \
    # - VERSION: the docker image version (corresponds to the above LABEL image.version)
	VERSION="1.1.0" \
	
	# - TERM: the name of a terminal information file from /lib/terminfo, 
    # this file instructs terminal programs how to achieve things such as displaying color.
    TERM="xterm" \

    # - LANG, LANGUAGE, LC_ALL: language dependent settings (Default: de_DE.UTF-8)
    LANG="de_DE.UTF-8" \
    LANGUAGE="de_DE:de" \
    LC_ALL="de_DE.UTF-8" \

    # - PKG_*: the needed applications for installation
    GOSU_VERSION="1.9" \
    PKG_BASE="bash tzdata git" \
    PKG_DEV="make gcc g++ automake autoconf python-dev libressl-dev libffi-dev" \
    PKG_PYTHON="ca-certificates py2-pip python py-libxml2 py-lxml" \
    PKG_COMPRESS="unrar unzip tar p7zip" \
	PKG_ADDONS="ffmpeg" \

    # - SET_CONTAINER_TIMEZONE: set this environment variable to true to set timezone on container startup
    SET_CONTAINER_TIMEZONE="false" \

    # - CONTAINER_TIMEZONE: UTC, Default container timezone as found under the directory /usr/share/zoneinfo/
    CONTAINER_TIMEZONE="UTC" \

    # - SABNZBD_HOME: SABnzbd Home directory
    SABNZBD_HOME="/sabnzbd" \

    # - SABNZBD_REPO, SABNZBD_BRANCH: SABnzbd GitHub repository 
	# and related branch (e.g. master, 0.7.x, 1.0.x, 1.1.x, develop)
    SABNZBD_REPO="https://github.com/sabnzbd/sabnzbd.git" \
    SABNZBD_BRANCH="master" \

    # - SABNZBD_DOWNLOADS: main download folder
    SABNZBD_DOWNLOADS="/downloads"


RUN \
    # update the package list
    apk -U upgrade && \

    # install gosu from https://github.com/tianon/gosu
    set -x \
    && apk add --no-cache --virtual .gosu-deps \
        dpkg \
        gnupg \
        openssl \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps \
    && \

    # install the needed applications
    apk -U add --no-cache $PKG_BASE $PKG_DEV $PKG_PYTHON $PKG_COMPRESS $PKG_ADDONS && \

    # install par2
    git clone --depth 1 https://github.com/Parchive/par2cmdline.git && \
    cd /par2cmdline && \
    aclocal && \
    automake --add-missing && \
    autoconf && \
    ./configure && \
    make && \
    make install && \
    cd / && \
    rm -rf par2cmdline && \

    # install additional python packages:
    # setuptools, pyopenssl, cheetah, requirements
    pip --no-cache-dir install --upgrade pip && \
    pip --no-cache-dir install --upgrade setuptools && \
    pip --no-cache-dir install --upgrade pyopenssl cheetah requirements requests && \
    pip install http://www.golug.it/pub/yenc/yenc-0.4.0.tar.gz && \

    # remove not needed packages
    apk del $PKG_DEV && \

    # create SABnzbd folder structure
    mkdir -p $SABNZBD_DOWNLOADS/complete && \
    mkdir -p $SABNZBD_DOWNLOADS/incomplete && \
    mkdir -p $SABNZBD_HOME/app && \
    mkdir -p $SABNZBD_HOME/nzbbackups && \
    mkdir -p $SABNZBD_HOME/config && \
    mkdir -p $SABNZBD_HOME/config/scripts && \

    # cleanup temporary files
    rm -rf /tmp && \
    rm -rf /var/cache/apk/*


# set the working directory for SABnzbd
WORKDIR $SABNZBD_HOME/app

#start.sh will download the latest version of SickRage and run it.
COPY *.txt $SABNZBD_HOME/
COPY *.sh $SABNZBD_HOME/
RUN chmod u+x $SABNZBD_HOME/start.sh

# Set volumes for the SABnzbd folder structure
VOLUME $SABNZBD_HOME/config $SABNZBD_HOME/nzbbackups $SABNZBD_HOME/config/scripts $SABNZBD_DOWNLOADS/complete $SABNZBD_DOWNLOADS/incomplete

# Expose ports
EXPOSE 8080 9090

# Start SABnzbd
CMD ["/bin/bash", "-c", "$SABNZBD_HOME/start.sh"]
