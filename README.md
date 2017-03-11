# SABnzbd
![](https://sabnzbd.org/images/logo-full.svg)

[![Docker Stars](https://img.shields.io/docker/stars/technosoft2000/sabnzbd.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/technosoft2000/sabnzbd.svg)]()
[![](https://images.microbadger.com/badges/image/technosoft2000/sabnzbd.svg)](http://microbadger.com/images/technosoft2000/sabnzbd "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/technosoft2000/sabnzbd.svg)](http://microbadger.com/images/technosoft2000/sabnzbd "Get your own version badge on microbadger.com")

## SABnzbd - The automated Usenet download tool ##

SABnzbd is an Open Source Binary Newsreader written in Python.

It's totally free, incredibly easy to use, and works practically everywhere.

SABnzbd makes Usenet as simple and streamlined as possible by automating everything we can. All you have to do is add an .nzb. 
SABnzbd takes over from there, where it will be automatically downloaded, verified, repaired, extracted and filed away with zero human interaction.

If you want to know more you can head over to the SABnzbd website: http://sabnzbd.org.

## Updates ##

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

## Features ##

 * running SABnzbd under its own user (not root)
 * changing of the UID and GID for the SABnzbd user
 * support of SSL / HTTPS encryption via __LibreSSL__
 * usage and support of different unpacker
   + RAR archives via ```unrar```
   + ZIP archives via ```unzip```
   + TAR archives via ```tar```
   + 7Zip archives via ```p7zip```
 * usage of the latest par2 repair utility via ```par2cmdline``` of master branch from https://github.com/Parchive/par2cmdline
 * support of nzbToMedia post-processing scripts from https://github.com/clinton-hall/nzbToMedia

## Usage ##

__Create the container:__

```
docker create --name=sabnzbd --restart=always \
-v <your sabnzbd config folder>:/sabnzbd/config \
-v <your complete downloads folder>:/downloads/complete \
-v <your incomplete downloads folder>:/downloads/incomplete \
[-v <your nzb blackhole folder>:/downloads/nzb \]
[-v <your nzb backup folder>:/sabnzbd/nzbbackups \]
[-e APP_REPO=https://github.com/sabnzbd/sabnzbd.git \]
[-e APP_BRANCH=master \]
[-e NZBTOMEDIA_REPO="https://github.com/clinton-hall/nzbToMedia.git" \]
[-e NZBTOMEDIA_BRANCH="master" \]
[-e SET_CONTAINER_TIMEZONE=true \]
[-e CONTAINER_TIMEZONE=<container timezone value> \]
[-e PGID=<group ID (gid)> -e PUID=<user ID (uid)> \]
-p <HTTP PORT>:8080 -p <HTTPS PORT>:9090 \
technosoft2000/sabnzbd
```

__Example:__

```
docker create --name=sabnzbd --restart=always \
-v /volume1/docker/apps/sabnzbd/config:/sabnzbd/config \
-v /volume1/downloads/complete:/downloads/complete \
-v /volume1/downloads/incomplete:/downloads/incomplete \
-v /volume1/downloads/nzb:/downloads/nzb \
-v /volume1/downloads/nzbbackups:/sabnzbd/nzbbackups \
-v /etc/localtime:/etc/localtime:ro \
-e PGID=65539 -e PUID=1029 \
-p 8085:8080 -p 9095:9090 \
technosoft2000/sabnzbd
```

or

```
docker create --name=sabnzbd --restart=always \
-v /volume1/docker/apps/sabnzbd/config:/sabnzbd/config \
-v /volume1/downloads/complete:/downloads/complete \
-v /volume1/downloads/incomplete:/downloads/incomplete \
-v /volume1/downloads/nzb:/downloads/nzb \
-v /volume1/downloads/nzbbackups:/sabnzbd/nzbbackups \
-e APP_BRANCH=1.1.x \
-e SET_CONTAINER_TIMEZONE=true \
-e CONTAINER_TIMEZONE=Europe/Vienna \
-e PGID=65539 -e PUID=1029 \
-p 8085:8080 -p 9095:9090 \
technosoft2000/sabnzbd
```

__Start the container:__
```
docker start sabnzbd
```

## Parameters ##

### Introduction ###
The parameters are split into two parts which are separated via colon.
The left side describes the host and the right side the container. 
For example a port definition looks like this ```-p external:internal``` and defines the port mapping from internal (the container) to external (the host).
So ```-p 8080:80``` would expose port __80__ from inside the container to be accessible from the host's IP on port __8080__.
Accessing http://'host':8080 (e.g. http://192.168.0.10:8080) would then show you what's running **INSIDE** the container on port __80__.

### Details ###
* `-p 8080` - http port for the web user interface
* `-p 9090` - https port for the web user interface
* `-v /sabnzbd/config` - local path for SABnzbd config files; at `/sabnzbd/config/scripts` the post processing scripts are available
* `-v /downloads/complete` - the folder where SABnzbd puts the completed downloads
* `-v /downloads/incomplete` - the folder where SABnzbd puts the incomplete downloads and temporary files
* `-v /downloads/nzb` - the folder where SABnzbd is searching for nzb files - __optional__
* `-v /sabnzbd/nzbbackups` - the folder where SABnzbd puts the processed nzb files for backup - __optional__
* `-v /etc/localhost` - for timesync - __optional__
* `-e APP_REPO` - set it to the SABnzbd GitHub repository; by default it uses https://github.com/sabnzbd/sabnzbd.git - __optional__
* `-e APP_BRANCH` - set which SABnzbd GitHub repository branch you want to use, __master__ (default branch), __0.7.x__, __1.0.x__, __1.1.x__, __develop__ - __optional__
* `-e NZBTOMEDIA_REPO` - set it to the nzbToMedia GitHub repository; by default it uses "https://github.com/clinton-hall/nzbToMedia.git" - __optional__
* `-e NZBTOMEDIA_BRANCH` - set it to the nzbToMedia GitHub repository branch you want to use, __master__ (default branch), __nightly__, __more-cleanup__, __dev__ - __optional__
* `-e SET_CONTAINER_TIMEZONE` - set it to `true` if the specified `CONTAINER_TIMEZONE` should be used - __optional__
* `-e CONTAINER_TIMEZONE` - container timezone as found under the directory `/usr/share/zoneinfo/` - __optional__
* `-e PGID` for GroupID - see below for explanation - __optional__
* `-e PUID` for UserID - see below for explanation - __optional__

### Container Timezone

In the case of the Synology NAS it is not possible to map `/etc/localtime` for timesync, and for this and similar case
set `SET_CONTAINER_TIMEZONE` to `true` and specify with `CONTAINER_TIMEZONE` which timezone should be used.
The possible container timezones can be found under the directory `/usr/share/zoneinfo/`.

Examples:

 * ```UTC``` - __this is the default value if no value is set__
 * ```Europe/Berlin```
 * ```Europe/Vienna```
 * ```America/New_York```
 * ...

__Don't use the value__ `localtime` because it results into: `failed to access '/etc/localtime': Too many levels of symbolic links`

## User / Group Identifiers ##
Sometimes when using data volumes (-v flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user PUID and group PGID. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance PUID=1001 and PGID=1001. To find yours use id user as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Additional ##
Shell access whilst the container is running: `docker exec -it sabnzbd /bin/bash`

Upgrade to the latest version of sabnzbd: `docker restart sabnzbd`

To monitor the logs of the container in realtime: `docker logs -f sabnzbd`

---

## For Synology NAS users ##

Login into the DSM Web Management
* Open the Control Panel
* Control _Panel_ > _Privilege_ > _Group_ and create a new one with the name 'docker'
* add the permissions for the directories 'downloads', 'video' and so on
* disallow the permissons to use the applications
* Control _Panel_ > _Privilege_ > _User_ and create a new on with name 'docker' and assign this user to the group 'docker'

Connect with SSH to your NAS
* after sucessful connection change to the root account via
```
sudo -i
```
or
```
sudo su -
```
for the password use the same one which was used for the SSH authentication.

* create a 'docker' directory on your volume (if such doesn't exist)
```
mkdir -p /volume1/docker/
chown root:root /volume1/docker/
```

* create a 'sabnzbd' directory
```
cd /volume1/docker
mkdir apps
chown docker:docker apps
cd apps
mkdir -p sabnzbd/config
chown -R docker:docker sabnzbd
```

* get your Docker User ID and Group ID of your previously created user and group
```
id docker
uid=1029(docker) gid=100(users) groups=100(users),65539(docker)
```

* get the Docker image
```
docker pull technosoft2000/sabnzbd
```

* create a Docker container (take care regarding the user ID and group ID, change timezone and port as needed)
```
docker create --name=sabnzbd --restart=always \
-v /volume1/docker/apps/sabnzbd/config:/sabnzbd/config \
-v /volume1/downloads/complete:/downloads/complete \
-v /volume1/downloads/incomplete:/downloads/incomplete \
-v /volume1/downloads/nzb:/downloads/nzb \
-v /volume1/downloads/nzbbackups:/sabnzbd/nzbbackups \
-e APP_BRANCH=1.2.x \
-e SET_CONTAINER_TIMEZONE=true \
-e CONTAINER_TIMEZONE=Europe/Vienna \
-e PGID=65539 -e PUID=1029 \
-p 8085:8080 -p 9095:9090 \
technosoft2000/sabnzbd
```

* check if the Docker container was created successfully
```
docker ps -a
CONTAINER ID        IMAGE                           COMMAND                CREATED             STATUS              PORTS               NAMES
b95e7f3da141        technosoft2000/sabnzbd          "/bin/bash -c /init/s" 8 seconds ago       Created 
```

* start the Docker container
```
docker start sabnzbd
```

* analyze the log (stop it with CTRL+C)
```
docker logs -f sabnzbd

        ,----,                                   
      ,/   .`|                                   
    ,`   .'  : .--.--.        ,----,        ,-.  
  ;    ;     //  /    '.    .'   .' \   ,--/ /|  
.'___,/    ,'|  :  /`. /  ,----,'    |,--. :/ |  
|    :     | ;  |  |--`   |    :  .  ;:  : ' /   
;    |.';  ; |  :  ;_     ;    |.'  / |  '  /    
`----'  |  |  \  \    `.  `----'/  ;  '  |  :    
    '   :  ;   `----.   \   /  ;  /   |  |   \   
    |   |  '   __ \  \  |  ;  /  /-,  '  : |. \  
    '   :  |  /  /`--'  / /  /  /.`|  |  | ' \ \ 
    ;   |.'  '--'.     /./__;      :  '  : |--'  
    '---'      `--'---' |   :    .'   ;  |,'     
                        ;   | .'      '--'       
                        `---'                    

      PRESENTS ANOTHER AWESOME DOCKER IMAGE
      
      ~~~~~ SABnzbd  Standard-Edition ~~~~~
                                           
[INFO] Docker image version: 1.1.2
[INFO] Create group sabnzbd with id 65539
[INFO] Create user sabnzbd with id 1029
[INFO] Current active timezone is UTC
Sun Mar  5 21:53:39 CET 2017
[INFO] Container timezone is changed to: Europe/Vienna
[INFO] Change the ownership of /sabnzbd (including subfolders) to sabnzbd:sabnzbd
[INFO] Current git version is:
git version 2.11.0
[INFO] Checkout the latest SABnzbd version ...
[INFO] ... git clone -b 1.2.x --single-branch https://github.com/sabnzbd/sabnzbd.git /sabnzbd/app -v
Cloning into '/sabnzbd/app'...
POST git-upload-pack (165 bytes)
[INFO] Autoupdate is active, try to pull the latest sources for SABnzbd ...
[INFO] ... current git status is
On branch 1.2.x
Your branch is up-to-date with 'origin/1.2.x'.
nothing to commit, working tree clean
555d8418e72214673ebce774f1471852bd74c7d3
[INFO] ... pulling sources
Already up-to-date.
[INFO] ... git status after update is
On branch 1.2.x
Your branch is up-to-date with 'origin/1.2.x'.
nothing to commit, working tree clean
555d8418e72214673ebce774f1471852bd74c7d3
[INFO] ... configure version.py
[INFO] ... SABnzbd version: 1.2.x [555d8418]
[INFO] ... build multi-language support
Email MO files
Compile locale/da/LC_MESSAGES/SABemail.mo
Compile locale/de/LC_MESSAGES/SABemail.mo
Compile locale/en/LC_MESSAGES/SABemail.mo
Compile locale/es/LC_MESSAGES/SABemail.mo
Compile locale/fi/LC_MESSAGES/SABemail.mo
Compile locale/fr/LC_MESSAGES/SABemail.mo
Compile locale/nb/LC_MESSAGES/SABemail.mo
Compile locale/nl/LC_MESSAGES/SABemail.mo
Compile locale/pl/LC_MESSAGES/SABemail.mo
Compile locale/pt_BR/LC_MESSAGES/SABemail.mo
Compile locale/ro/LC_MESSAGES/SABemail.mo
Compile locale/ru/LC_MESSAGES/SABemail.mo
Compile locale/sr/LC_MESSAGES/SABemail.mo
Compile locale/sv/LC_MESSAGES/SABemail.mo
Compile locale/zh_CN/LC_MESSAGES/SABemail.mo
Create email templates from MO files
Create email template for da
Create email template for de
Create email template for es
Create email template for fi
Create email template for fr
Create email template for nb
Create email template for nl
Create email template for pl
Create email template for pt_BR
Create email template for ro
Create email template for ru
Create email template for sr
Create email template for sv
Create email template for zh_CN
Main program MO files
Compile locale/da/LC_MESSAGES/SABnzbd.mo
Compile locale/de/LC_MESSAGES/SABnzbd.mo
Compile locale/en/LC_MESSAGES/SABnzbd.mo
Compile locale/es/LC_MESSAGES/SABnzbd.mo
Compile locale/fi/LC_MESSAGES/SABnzbd.mo
Compile locale/fr/LC_MESSAGES/SABnzbd.mo
Compile locale/nb/LC_MESSAGES/SABnzbd.mo
Compile locale/nl/LC_MESSAGES/SABnzbd.mo
Compile locale/pl/LC_MESSAGES/SABnzbd.mo
Compile locale/pt_BR/LC_MESSAGES/SABnzbd.mo
Compile locale/ro/LC_MESSAGES/SABnzbd.mo
Compile locale/ru/LC_MESSAGES/SABnzbd.mo
Compile locale/sr/LC_MESSAGES/SABnzbd.mo
Compile locale/sv/LC_MESSAGES/SABnzbd.mo
Compile locale/zh_CN/LC_MESSAGES/SABnzbd.mo
Remove temporary templates

[INFO] Current git version is:
git version 2.11.0
[INFO] Checkout the latest nzbToMedia version ...
[INFO] Autoupdate is active, try to pull the latest sources for nzbToMedia ...
[INFO] ... current git status is
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working tree clean
80c8ad58523ab99825c02f3855f9bd3dc9945d57
[INFO] ... pulling sources
Already up-to-date.
[INFO] ... git status after update is
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working tree clean
80c8ad58523ab99825c02f3855f9bd3dc9945d57
[INFO] Launching SABnzbd ...
```