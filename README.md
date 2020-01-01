# SABnzbd
![](https://sabnzbd.org/images/logo-full.svg)

[![Docker Stars](https://img.shields.io/docker/stars/technosoft2000/sabnzbd.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/technosoft2000/sabnzbd.svg)]()
[![](https://images.microbadger.com/badges/image/technosoft2000/sabnzbd.svg)](http://microbadger.com/images/technosoft2000/sabnzbd "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/technosoft2000/sabnzbd.svg)](http://microbadger.com/images/technosoft2000/sabnzbd "Get your own version badge on microbadger.com")

## SABnzbd - The automated Usenet download tool ##

[SABnzbd](https://sabnzbd.org/) is an Open Source Binary Newsreader written in Python.

It's totally free, incredibly easy to use, and works practically everywhere.

SABnzbd makes Usenet as simple and streamlined as possible by automating everything we can. All you have to do is add an .nzb. 
SABnzbd takes over from there, where it will be automatically downloaded, verified, repaired, extracted and filed away with zero human interaction.

If you want to know more you can head over to the SABnzbd website: http://sabnzbd.org.

## Updates ##

**2020-01-01 - v1.4.0**

 * upgrade to latest base image [technosoft2000/alpine-base:3.11-1](https://hub.docker.com/r/technosoft2000/alpine-base/) based on Alpine 3.11.2
 * changed to Python 3 and to the SABnzbd `develop` branch
 * IMPORTANT: only Python 3 versions of SABnzbd are supported by this image, at the moment only the `py3` and `develop` branch
 * fixed empty continuation line

**2019-02-17 - v1.3.0**

 * upgrade to latest base image [technosoft2000/alpine-base:3.9-1](https://hub.docker.com/r/technosoft2000/alpine-base/)

For previous changes see at [full changelog](CHANGELOG.md).

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

## Hints & Tips ##
 
### HTTPS ###
To turn on access using HTTPS, you need enable HTTPS in `Config->General`,
look at [sabnzbd/wiki](https://sabnzbd.org/wiki/configuration/2.1/general#toc1)

Tested with the following settings at SABnzbd interface
 - ___HTTPS-Port___: 9090
 - ___HTTPS-Certificate___: cert.pem
 - ___HTTPS-Key___: privkey.pem
 - ___HTTPS-Chain Certificate___: chain.pem
 
For more details about SABnzbd and HTTPS look at:
https://sabnzbd.org/wiki/advanced/https
 
I suggest to use an additional NGINX or Apache HTTP Server as Reverse-Proxy, 
e.g see [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/)

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
[-e APP_BRANCH="develop" \]
[-e NZBTOMEDIA_REPO="https://github.com/clinton-hall/nzbToMedia.git" \]
[-e NZBTOMEDIA_BRANCH="develop" \]
[-e PAR2_REPO="https://github.com/Parchive/par2cmdline.git" \]
[-e PAR2_BRANCH="v0.8.0" \]
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
-e APP_BRANCH=develop \
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
* `-e PAR2_REPO` - set it to the par2commandline GitHub repoitory; by default it uses "https://github.com/Parchive/par2cmdline.git" - __optional__
* `-e PAR2_BRANCH` - set it to the par2commandline GitHub repository branch or tag you want to use, __master__, __v0.6.14__, __v0.7.1__ (default tag) - __optional__
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

[INFO] Docker image version: 1.4.0
[INFO] Alpine Linux version: 3.11.2
[INFO] Create group sabnzbd with id 65539
[INFO] Create user sabnzbd with id 1029
[INFO] Current active timezone is UTC
Wed Jan  1 18:13:32 CET 2020
[INFO] Container timezone is changed to: Europe/Vienna
[INFO] Change the ownership of /sabnzbd (including subfolders) to sabnzbd:sabnzbd
[INFO] Current git version is:
git version 2.24.1
[INFO] Checkout the latest SABnzbd version ...
[INFO] ... git clone -b develop --single-branch https://github.com/sabnzbd/sabnzbd.git /sabnzbd/app -v
Cloning into '/sabnzbd/app'...
POST git-upload-pack (189 bytes)
[INFO] Autoupdate is active, try to pull the latest sources for SABnzbd ...
[INFO] ... current git status is
On branch develop
Your branch is up to date with 'origin/develop'.

nothing to commit, working tree clean
17719b1b5bfec074ec30bb633eb956d2a27c2d6c
[INFO] ... pulling sources
Already up to date.
[INFO] ... git status after update is
On branch develop
Your branch is up to date with 'origin/develop'.

nothing to commit, working tree clean
17719b1b5bfec074ec30bb633eb956d2a27c2d6c
[INFO] ... update the version information at SABnzbd - patching /sabnzbd/app/sabnzbd/version.py
[INFO] ... SABnzbd version: develop [17719b1b]
[INFO] ... build multi-language support
Email MO files
Compile locale/es/LC_MESSAGES/SABemail.mo
Compile locale/fr/LC_MESSAGES/SABemail.mo
Compile locale/nb/LC_MESSAGES/SABemail.mo
Compile locale/fi/LC_MESSAGES/SABemail.mo
Compile locale/ro/LC_MESSAGES/SABemail.mo
Compile locale/pt_BR/LC_MESSAGES/SABemail.mo
Compile locale/da/LC_MESSAGES/SABemail.mo
Compile locale/nl/LC_MESSAGES/SABemail.mo
Compile locale/sv/LC_MESSAGES/SABemail.mo
Compile locale/he/LC_MESSAGES/SABemail.mo
Compile locale/zh_CN/LC_MESSAGES/SABemail.mo
Compile locale/en/LC_MESSAGES/SABemail.mo
Compile locale/sr/LC_MESSAGES/SABemail.mo
Compile locale/de/LC_MESSAGES/SABemail.mo
Compile locale/ru/LC_MESSAGES/SABemail.mo
Compile locale/pl/LC_MESSAGES/SABemail.mo
Create email templates from MO files
Create email template for nl
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for es
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for ro
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for de
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for fi
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for fr
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for he
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for da
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for pl
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for zh_CN
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for sr
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for ru
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for nb
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for pt_BR
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Create email template for sv
/sabnzbd/app/tools/make_mo.py:214: DeprecationWarning: parameter codeset is deprecated
  trans = gettext.translation(DOMAIN_E, MO_DIR, [lng], fallback=False, codeset="latin-1")
Main program MO files
Compile locale/es/LC_MESSAGES/SABnzbd.mo
Compile locale/fr/LC_MESSAGES/SABnzbd.mo
Compile locale/nb/LC_MESSAGES/SABnzbd.mo
Compile locale/fi/LC_MESSAGES/SABnzbd.mo
Compile locale/ro/LC_MESSAGES/SABnzbd.mo
Compile locale/pt_BR/LC_MESSAGES/SABnzbd.mo
Compile locale/da/LC_MESSAGES/SABnzbd.mo
Compile locale/nl/LC_MESSAGES/SABnzbd.mo
Compile locale/sv/LC_MESSAGES/SABnzbd.mo
Compile locale/he/LC_MESSAGES/SABnzbd.mo
Compile locale/zh_CN/LC_MESSAGES/SABnzbd.mo
Compile locale/en/LC_MESSAGES/SABnzbd.mo
Compile locale/sr/LC_MESSAGES/SABnzbd.mo
Compile locale/de/LC_MESSAGES/SABnzbd.mo
Compile locale/ru/LC_MESSAGES/SABnzbd.mo
Compile locale/pl/LC_MESSAGES/SABnzbd.mo
Remove temporary templates

[INFO] Current git version is:
git version 2.24.1
[INFO] Checkout the latest nzbToMedia version ...
[INFO] Autoupdate is active, try to pull the latest sources for nzbToMedia ...
[INFO] ... current git status is
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
2e7d4a58633b4b7924496ba849636bd5bb3b98cc
[INFO] ... pulling sources
Already up to date.
[INFO] ... git status after update is
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
2e7d4a58633b4b7924496ba849636bd5bb3b98cc
[INFO] Launching SABnzbd ...
```
