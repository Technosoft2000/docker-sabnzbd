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

## Usage ##

__Create the container:__

```
docker create --name=sabnzbd --restart=always \
-v <your sabnzbd config folder>:/sabnzbd/config \
-v <your complete downloads folder>:/downloads/complete \
-v <your incomplete downloads folder>:/downloads/incomplete \
[-v <your nzb blackhole folder>:/downloads/nzb \]
[-v <your nzb backup folder>:/sabnzbd/nzbbackups \]
[-v <your post processing scripts folder>:/sabnzbd/autoProcessScripts \]
[-e SABNZBD_REPO=https://github.com/sabnzbd/sabnzbd.git \]
[-e SABNZBD_BRANCH=master \]
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
-e SABNZBD_BRANCH=1.1.x \
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
* `-p 8080` - http port for the web user interface
* `-p 9090` - https port for the web user interface
* `-v /sabnzbd/config` - local path for SABnzbd config files
* `-v /downloads/complete` - the folder where SABnzbd puts the completed downloads
* `-v /downloads/incomplete` - the folder where SABnzbd puts the incomplete downloads and temporary files
* `-v /downloads/nzb` - the folder where SABnzbd is searching for nzb files - __optional__
* `-v /sabnzbd/nzbbackups` - the folder where SABnzbd puts the processed nzb files for backup - __optional__
* `-v /sabnzbd/autoProcessScripts` - folder of the post processing scripts - __optional__
* `-v /etc/localhost` - for timesync - __optional__
* `-e SABNZBD_REPO` - set it to the SABnzbd GitHub repository; by default it uses https://github.com/sabnzbd/sabnzbd.git - __optional__
* `-e SABNZBD_BRANCH` - set which SABnzbd GitHub repository branch you want to use, __master__ (default branch), __0.7.x__, __1.0.x__, __1.1.x__, __develop__ - __optional__
* `-e SET_CONTAINER_TIMEZONE` - set it to `true` if the specified `CONTAINER_TIMEZONE` should be used - __optional__
* `-e CONTAINER_TIMEZONE` - container timezone as found under the directory `/usr/share/zoneinfo/` - __optional__
* `-e PGID` for GroupID - see below for explanation - __optional__
* `-e PUID` for UserID - see below for explanation - __optional__

### Container Timezone

In the case of the Synology NAS it is not possible to map `/etc/localtime` for timesync, and for this and similar case
set `SET_CONTAINER_TIMEZONE` to `true` and specify with `CONTAINER_TIMEZONE` which timezone should be used.
The possible container timezones can be found under the directory `/usr/share/zoneinfo/`.
Examples:
* UTC - __this is the default value if no value is set__
* Europe\Berlin
* Europe\Vienna
* America\New_York
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
Upgrade to the latest version: `docker restart sabnzbd`
To monitor the logs of the container in realtime: `docker logs -f sabnzbd`
