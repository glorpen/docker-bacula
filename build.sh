#!/bin/bash

VERSION="${1-latest}"

set -ex

bash generator/generate.sh client | docker build ./ -f - -t glorpen/bacula:${VERSION}-client
bash generator/generate.sh storage | docker build ./ -f - -t glorpen/bacula:${VERSION}-storage
bash generator/generate.sh console | docker build ./ -f - -t glorpen/bacula:${VERSION}-console
bash generator/generate.sh director | docker build ./ -f - -t glorpen/bacula:${VERSION}-director

bash generator/generate.sh mysql_client | docker build ./ -f - -t glorpen/bacula:${VERSION}-client-mysql
