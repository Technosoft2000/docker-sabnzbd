# SABnzbd
![](http://sabnzbd.org/resources/landing/sabnzbd_logo.png)

SABnzbd makes Usenet as simple and streamlined as possible by automating everything we can. All you have to do is add an .nzb. SABnzbd takes over from there, where it will be automatically downloaded, verified, repaired, extracted and filed away with zero human interaction. 
This container includes par2 multicore.  http://sabnzbd.org/

## Modifications of [linuxserver/sabnzbd](https://hub.docker.com/r/linuxserver/sabnzbd/) by Technosoft2000
* added support for decompression of 7Zip archives 
* added volume mapping for SSL/TLS certificates `/certificates`
* added additional timezone environment settings `SET_CONTAINER_TIMEZONE` and `CONTAINER_TIMEZONE`

## Usage

```
docker create --name=sabnzbd \
-v <path to data>:/config \
-v <path to downloads>:/downloads \
[-v <path to incomplete downloads>:/incomplete-downloads \]
[-v <path to certificates>:/certificates \]
[-v /etc/localtime:/etc/localtime:ro \]
[-e SET_CONTAINER_TIMEZONE=true \]
[-e CONTAINER_TIMEZONE=<container timezone value> \]
-e PGID=<Group ID (gid)> -e PUID=<User ID (uid)> \
-p 8080:8080 -p 9090:9090 technosoft2000/sabnzbd
```

**Parameters**

* `-p 8080` - http port for the webui
* `-p 9090` - https port for the webui *see note below*
* `-v /config` - local path for sabnzbd config files
* `-v /downloads` local path for finished downloads
* `-v /incomplete-downloads` local path for incomplete-downloads - __optional__
* `-v /certificates` local path for SSL/TLS certificates - __optional__
* `-v /etc/localtime` for timesync - __optional__
* `-e SET_CONTAINER_TIMEZONE` set it to `true` if the specified `CONTAINER_TIMEZONE` should be used - __optional__ 
* `-e CONTAINER_TIMEZONE` container timezone as found under the directory `/usr/share/zoneinfo/` - __optional__
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation

### Container Timezone

In the case of the Synology NAS it is not possible to map `/etc/localtime` for timesync, and for this and similar case
set `SET_CONTAINER_TIMEZONE` to `true` and specify with `CONTAINER_TIMEZONE` which timezone should be used.
The possible container timezones can be found under the directory `/usr/share/zoneinfo/`.
Examples:
* localtime
* UTC
* Europe\Berlin
* Europe\Vienna
* America\New_York

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application 
Initial setup is done from the http port.
Https access for sabnzbd needs to be enabled in either the intial setup wizard or in the configure settings of the webui, be sure to use 9090 as port for https.
See here for info on some of the switch settings for sabnzbd http://wiki.sabnzbd.org/configure-switches


## Updates

* Shell access whilst the container is running: `docker exec -it sabnzbd /bin/bash`
* Upgrade to the latest version: `docker restart sabnzbd`
* To monitor the logs of the container in realtime: `docker logs -f sabnzbd`


## Credits
https://github.com/jcfp/debpkg-par2tbb for the par2 multicore used in this container.
https://hub.docker.com/r/linuxserver/sabnzbd for the sabnzbd docker image


