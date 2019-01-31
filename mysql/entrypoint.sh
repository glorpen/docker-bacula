#!/bin/bash

set -e

cat << EOF > /root/.my.cnf
[client]
user=${MYSQL_USER}
password=${MYSQL_PASSWORD}
host=${MYSQL_HOST}
port=${MYSQL_PORT}
EOF

exec "$@"
