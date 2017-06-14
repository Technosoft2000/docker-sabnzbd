**2017-06-14 - v1.1.6**

 - **___HTTPS___**

   - Log output shows now: 
   ```
   2017-06-14 17:08:34,788::INFO::[misc:1236] Self-signed certificates generated successfully
   ```
   - Self-signed certificate creation via SABnzbd is working now, 
     btw. Chrome warns that this certificate is of course insecure

 - **___par2cmdline___**

   - upgrade to v0.7.2 as default version
   - added missing library ```libgomp``` which is needed for correct execution of par2cmdline
   - added 'make check' at build process of par2cmdline to get early feedback that the command works correct
   - for more information look at https://sabnzbd.org/wiki/installation/multicore-par2

**2017-06-03 - v1.1.5**

 * upgrade to new base image [technosoft2000/alpine-base:3.6-2](https://hub.docker.com/r/technosoft2000/alpine-base/)
 * supports now __PGID__ < 1000

**2017-05-28 - v1.1.4**

 * upgrade to __Alpine 3.6__ (new base image [technosoft2000/alpine-base:3.6-1](https://hub.docker.com/r/technosoft2000/alpine-base/))
 * introduced new environment variables for __par2cmdline__ (```PAR2_REPO``` and ```PAR2_BRANCH```)
 * default version of [par2cmdline](https://github.com/Parchive/par2cmdline) is now v0.7.1, 
   if you need the latest version then start container with `-e PAR2_BRANCH=master`
 * changed yenc implementation from [yenc-0.4.0](http://www.golug.it/pub/yenc/yenc-0.4.0.tar.gz) to ```sabyenc```
 * added the optional dependency ```cryptography``` which requires the usage of ```openssl-dev``` instead of ```libressl-dev```, nevertheless [LibreSSL](https://www.libressl.org/) is still used at runtime
 * added ignore files for Git and Docker
 * tested with actual version [SABnzbd v2.0.1](https://github.com/sabnzbd/sabnzbd/releases/tag/2.0.1)
 * Found modules are:
```
2017-05-28 12:31:16,531::INFO::[SABnzbd:407] SABYenc module (v3.0.2)... found!
2017-05-28 12:31:16,532::INFO::[SABnzbd:424] Cryptography module (v1.8.2)... found!
2017-05-28 12:31:16,533::INFO::[SABnzbd:429] par2 binary... found (/usr/local/bin/par2)
2017-05-28 12:31:16,533::INFO::[SABnzbd:434] par2cmdline binary... found (/usr/local/bin/par2)
2017-05-28 12:31:16,533::INFO::[SABnzbd:437] UNRAR binary... found (/usr/bin/unrar)
2017-05-28 12:31:16,534::INFO::[SABnzbd:450] unzip binary... found (/usr/bin/unzip)
2017-05-28 12:31:16,534::INFO::[SABnzbd:455] 7za binary... found (/usr/bin/7za)
2017-05-28 12:31:16,535::INFO::[SABnzbd:461] nice binary... found (/bin/nice)
2017-05-28 12:31:16,535::INFO::[SABnzbd:465] ionice binary... found (/bin/ionice)
2017-05-28 12:31:16,535::INFO::[SABnzbd:1274] SSL version LibreSSL 2.5.4
2017-05-28 12:31:16,536::INFO::[SABnzbd:1275] SSL supported protocols ['TLS v1.2', 'TLS v1.1', 'TLS v1']
```

**2017-03-11 - v1.1.3**

 * small update at Dockerfile
 * added instructions for Synology NAS users

**2017-02-05 - v1.1.2**

 * created a special base image ```technosoft2000/alpine-base``` with a pre-define init process for easier image creation & maintenance
 * sabnzbd image is based now on ```technosoft2000/alpine-base:3.5-1.0.0```
 * version information at sabnzbd's ```version.py``` gets updated at container startup
 * __SABNZBD...__ environment variables are changed to __APP...__
 * it's also possible to use sabnzbd tags as __APP_BRANCH__ input to checkout a specific tagged version

**2017-01-05 - v1.1.1**

 * code clean-up and enhanced the start script
  + new script ```checkout.sh``` used to clone & update sources via git, used for sabnzbd and nzbToMedia
 * new environment variables especially for nzbToMedia
  + NZBTOMEDIA_REPO for nzbToMedia GitHub repository
  + NZBTOMEDIA_BRANCH for nzbToMedia GitHub repository branch
 * upgrade of gosu from v1.9 to v1.10
 * __known issues__
  + sabnzbd shows at branch 1.1.x as version 'develop', 
    this is because of a unintended change at sabnzbd's ```version.py``` issued by a backport from the develop branch.
    Nevertheless it is the right version after the git clone and this issue is only an cosmetic issue.

**2017-01-04 - v1.1.0**

 * Upgrade from Alpine v3.4 to Alpine v3.5
  + important is the switch from OpenSSL to LibreSSL
  + glib 2.50.2
  + better python3 support
 * added LABEL information at the *Dockerfile* which can be seen with ```docker inspect sabnzbd```
  + ```image.version``` ... the current version number of the docker image e.g 1.1
  + ```image.description``` ... a short description of the docker image
  + ```image.date``` ... the creation/update date of the docker image e.g. 2017-01-04
  + ```url.docker``` ... the docker registry URL from where the docker image is distributed
  + ```url.github``` ... the github project URL of the docker image
  + ```url.support``` ... the support forum URL where you can reach me
 * Enhanced the logging information at container startup
  + on installation: git clone command is shown now with detailed information
  + on update: git branch information and hash is shown before and after git pull
 * Added additional unpacker
  + unzip
  + tar
 * Added nzbToMedia from https://github.com/clinton-hall/nzbToMedia at ```/sabnzbd/config/scripts```
  + includes ffmpeg & ffprobe support
  + for configuration information look at https://github.com/clinton-hall/nzbToMedia/wiki/autoProcessMedia.cfg
  + if you use for example ```-v /volume1/docker/apps/sabnzbd/config:/sabnzbd/config``` change into directory 
    ```/volume1/docker/apps/sabnzbd/config/scripts``` to edit and configure autoProcessMedia.cfg
 * changed sabnzbd scripts volume from ```/sabnzbd/autoProcessScripts``` to ```/sabnzbd/config/scripts```

**2016-12-09 - v1.0.0**

 * Fixed User & Group Name -> changed from 'sickrage' to 'sabnzbd'
