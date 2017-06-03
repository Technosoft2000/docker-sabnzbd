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

**2017-06-03 - v1.1.5**

 * upgrade to new base image [technosoft2000/alpine-base:3.6-2](https://hub.docker.com/r/technosoft2000/alpine-base/)
 * supports now __PGID__ < 1000

**2017-05-28 - v1.1.4**

 * upgrade to __Alpine 3.6__ (new base image [technosoft2000/alpine-base:3.6-1](https://hub.docker.com/r/technosoft2000/alpine-base/))
 * introduced new environment variables for __par2commandline__ (```PAR2_REPO``` and ```PAR2_BRANCH```)
 * default version of [par2commandline](https://github.com/Parchive/par2cmdline) is now v0.7.1, 
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
[-e APP_BRANCH="master" \]
[-e NZBTOMEDIA_REPO="https://github.com/clinton-hall/nzbToMedia.git" \]
[-e NZBTOMEDIA_BRANCH="master" \]
[-e PAR2_REPO="https://github.com/Parchive/par2cmdline.git" \]
[-e PAR2_BRANCH="v0.7.1" \]
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
-e APP_BRANCH=2.0.x \
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
                                           
[INFO] Docker image version: 1.1.4
[INFO] Create group sabnzbd with id 65539
[INFO] Create user sabnzbd with id 1029
[INFO] Current active timezone is UTC
Sun May 28 12:30:47 CEST 2017
[INFO] Container timezone is changed to: Europe/Vienna
[INFO] Change the ownership of /sabnzbd (including subfolders) to sabnzbd:sabnzbd
[INFO] Current git version is:
git version 2.13.0
[INFO] Checkout the latest SABnzbd version ...
[INFO] ... git clone -b 2.0.x --single-branch https://github.com/sabnzbd/sabnzbd.git /sabnzbd/app -v
Cloning into '/sabnzbd/app'...
POST git-upload-pack (189 bytes)
[INFO] Autoupdate is active, try to pull the latest sources for SABnzbd ...
[INFO] ... current git status is
On branch 2.0.x
Your branch is up-to-date with 'origin/2.0.x'.
nothing to commit, working tree clean
e69eeebdd8dfaab47ff412baa88a72aeef84c2a4
[INFO] ... pulling sources
Already up-to-date.
[INFO] ... git status after update is
On branch 2.0.x
Your branch is up-to-date with 'origin/2.0.x'.
nothing to commit, working tree clean
e69eeebdd8dfaab47ff412baa88a72aeef84c2a4
[INFO] ... configure version.py
[INFO] ... SABnzbd version: 2.0.x [e69eeebd]
[INFO] ... build multi-language support
Email MO files
Compile locale/da/LC_MESSAGES/SABemail.mo
Compile locale/de/LC_MESSAGES/SABemail.mo
Compile locale/en/LC_MESSAGES/SABemail.mo
Compile locale/es/LC_MESSAGES/SABemail.mo
Create email templates from MO files
Create email template for da
Create email template for de
Create email template for es
Create email template for fi
Create email template for fr
Create email template for nb
Create email template for nl
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
git version 2.13.0
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
2017-05-28 12:31:16,344::INFO::[SABnzbd:1167] --------------------------------
2017-05-28 12:31:16,345::INFO::[SABnzbd:1168] SABnzbd.py-2.0.x (rev=e69eeebdd8dfaab47ff412baa88a72aeef84c2a4)
2017-05-28 12:31:16,346::INFO::[SABnzbd:1169] Full executable path = /sabnzbd/app/SABnzbd.py
2017-05-28 12:31:16,346::INFO::[SABnzbd:1181] Platform = posix
2017-05-28 12:31:16,347::INFO::[SABnzbd:1182] Python-version = 2.7.13 (default, Apr 20 2017, 12:13:37) 
[GCC 6.3.0]
2017-05-28 12:31:16,348::INFO::[SABnzbd:1183] Arguments = /sabnzbd/app/SABnzbd.py -f /sabnzbd/config -s 0.0.0.0:8080
2017-05-28 12:31:16,348::INFO::[SABnzbd:1188] Preferred encoding = UTF-8
2017-05-28 12:31:16,349::INFO::[SABnzbd:1229] Read INI file /sabnzbd/config/sabnzbd.ini
2017-05-28 12:31:16,375::INFO::[__init__:995] Loading data for rss_data.sab from /sabnzbd/config/admin/rss_data.sab
2017-05-28 12:31:16,389::INFO::[__init__:995] Loading data for totals10.sab from /sabnzbd/config/admin/totals10.sab
2017-05-28 12:31:16,390::INFO::[postproc:95] Loading postproc queue
2017-05-28 12:31:16,391::INFO::[__init__:995] Loading data for postproc2.sab from /sabnzbd/config/admin/postproc2.sab
2017-05-28 12:31:16,392::INFO::[__init__:995] Loading data for queue10.sab from /sabnzbd/config/admin/queue10.sab
2017-05-28 12:31:16,399::INFO::[__init__:995] Loading data for watched_data2.sab from /sabnzbd/config/admin/watched_data2.sab
2017-05-28 12:31:16,401::INFO::[__init__:995] Loading data for Rating.sab from /sabnzbd/config/admin/Rating.sab
2017-05-28 12:31:16,401::INFO::[__init__:998] /sabnzbd/config/admin/Rating.sab missing
2017-05-28 12:31:16,402::INFO::[scheduler:197] Setting schedule for midnight BPS reset
2017-05-28 12:31:16,466::INFO::[__init__:351] All processes started
2017-05-28 12:31:16,466::INFO::[SABnzbd:283] Web dir is /sabnzbd/app/interfaces/Plush
2017-05-28 12:31:16,467::INFO::[SABnzbd:283] Web dir is /sabnzbd/app/interfaces/Config
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
2017-05-28 12:31:16,539::INFO::[SABnzbd:1386] Starting web-interface on 0.0.0.0:8080
2017-05-28 12:31:16,540::INFO::[_cplogging:219] [28/May/2017:12:31:16] ENGINE Bus STARTING
2017-05-28 12:31:16,551::INFO::[_cplogging:219] [28/May/2017:12:31:16] ENGINE Started monitor thread '_TimeoutMonitor'.
2017-05-28 12:31:16,904::INFO::[_cplogging:219] [28/May/2017:12:31:16] ENGINE Serving on http://0.0.0.0:8080
2017-05-28 12:31:16,905::INFO::[_cplogging:219] [28/May/2017:12:31:16] ENGINE Bus STARTED
2017-05-28 12:31:16,906::INFO::[zconfig:64] No Bonjour/ZeroConfig support installed
2017-05-28 12:31:16,906::INFO::[SABnzbd:1424] Starting SABnzbd.py-2.0.x
2017-05-28 12:31:16,909::INFO::[postproc:176] Completed Download Folder /downloads/complete is not on FAT
2017-05-28 12:31:16,911::INFO::[dirscanner:316] Dirscanner starting up
2017-05-28 12:31:16,912::INFO::[urlgrabber:72] URLGrabber starting up
```
