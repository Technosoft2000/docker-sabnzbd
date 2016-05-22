FROM linuxserver/baseimage
MAINTAINER Sparklyballs <sparklyballs@linuxserver.io>

ENV APTLIST="sabnzbdplus \
unrar \
p7zip \
wget"

# Set the locale
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8

# Set the timezone 
# HINT: set this environment variable to true to set timezone on container startup
ENV SET_CONTAINER_TIMEZONE false
# Default container timezone as found under the directory /usr/share/zoneinfo/
ENV CONTAINER_TIMEZONE localtime

# install our compiled version of par2 multicore
ADD deb/ /tmp/
RUN apt-get update -q && \
apt-get install libtbb2 -qy && \
dpkg -i /tmp/par2-tbb_*.deb && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install main packages
RUN add-apt-repository ppa:jcfp/ppa && \
apt-get update -q && \
apt-get install \
$APTLIST -qy && \
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# adding custom files
ADD services/ /etc/service/
ADD init/ /etc/my_init.d/
RUN chmod -v +x /etc/service/*/run && chmod -v +x /etc/my_init.d/*.sh

# set volumes
VOLUME /config /downloads /incomplete-downloads /certificates

# expose ports
EXPOSE 8080 9090


