#!/bin/bash

VERSION="${1-latest}"

set -ex

bash generator/generate.sh client | docker build ./ -f - -t glorpen/bacula/client:${VERSION}
bash generator/generate.sh storage | docker build ./ -f - -t glorpen/bacula/storage:${VERSION}
bash generator/generate.sh console | docker build ./ -f - -t glorpen/bacula/console:${VERSION}
bash generator/generate.sh director | docker build ./ -f - -t glorpen/bacula/director:${VERSION}

bash generator/generate.sh mysql_client | docker build ./ -f - -t glorpen/bacula/client-mysql:${VERSION}
