- [Alpine Docker container for Mapserver](#alpine-docker-container-for-mapserver)
  - [What is Alpine Linux?](#what-is-alpine-linux)
  - [Build image](#build-image)
  - [Start container](#start-container)
  - [Access container via http](#access-container-via-http)
    - [Access the web administration interface](#access-the-web-administration-interface)
    - [Test GetCapabilities request](#test-getcapabilities-request)
  - [Logs](#logs)
  - [Enter a running container via shell](#enter-a-running-container-via-shell)
  - [Start and enter a new container via shell](#start-and-enter-a-new-container-via-shell)
  - [Examples for setting java options](#examples-for-setting-java-options)
    - [Support time-series layers](#support-time-series-layers)
    - [Set X-Frame-Options Policy](#set-x-frame-options-policy)

# Alpine Docker container for Mapserver

A minimal GeoServer Docker image based on [Alpine
Linux](https://alpinelinux.org/about/) with a complete package index and only
212 MB in size (compressed)!

## What is Alpine Linux?

Alpine Linux is a Linux distribution built around [musl
libc](https://www.musl-libc.org/) and
[BusyBox](https://busybox.net/about.html). The pure image is only 5 MB in
size and has access to a package repository that is much more complete than
other BusyBox based images.

## Build image

```shell
docker build -t geoserver .
```

## Start container

```shell
docker run -d -p 8181:8080 geoserver
```

while the command is

```shell
docker run -d -p [exposed port]:[internal port] geoserver
```

## Access container via http

### Access the web administration interface

When Docker is forwarded as `localhost` simply open the following URL:

```shell
http://localhost:8181/geoserver/web/
```

### Test GetCapabilities request

```sh
curl "http://localhost:8181/geoserver/ows?Request=GetCapabilities&Service=WMS&Version=1.1.1"
```

## Logs

Watch container logs with:

```shell
docker logs <CONTAINER ID>
```

View the log files being written as they happen:

```shell
docker logs --tail=10 -f <CONTAINER ID>
```

## Enter a running container via shell

```shell
docker exec -it <CONTAINER ID> /bin/ash
```

`ash` is the [Almquist Shell](https://en.wikipedia.org/wiki/Almquist_shell),
the default shell under [Alpine Linux](https://alpinelinux.org/) provided by
[BusyBox](https://busybox.net/about.html).

## Start and enter a new container via shell

To enter the container with a shell interface simple switch from `daemon`
mode to `interactive` mode.

```shell
docker run -it -v geoserver /bin/ash
```

## Examples for setting java options

### Support time-series layers

https://docs.geoserver.org/latest/en/user/tutorials/imagemosaic_timeseries/imagemosaic_timeseries.html#configuration

Set the time zone to GMT and enable support for timestamps in shapefile stores.

```sh
docker run -p 8181:8080 -e JAVA_OPTS='-Duser.timezone=GMT -Dorg.geotools.shapefile.datetime=true' geoserver
```

### Set X-Frame-Options Policy

https://docs.geoserver.org/latest/en/user/production/config.html#x-frame-options-policy

```sh
docker run -p 8181:8080 -e JAVA_OPTS='-Dgeoserver.xframe.shouldSetPolicy=false' geoserver
```