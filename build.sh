#!/bin/bash

set -ex

bash generator/generate.sh client | docker build ./ -f - -t glorpen/bacula:1.0.0-client
bash generator/generate.sh storage | docker build ./ -f - -t glorpen/bacula:1.0.0-storage
bash generator/generate.sh console | docker build ./ -f - -t glorpen/bacula:1.0.0-console
bash generator/generate.sh director | docker build ./ -f - -t glorpen/bacula:1.0.0-director

bash generator/generate.sh mysql_client | docker build ./ -f - -t glorpen/bacula:1.0.0-client-mysql
