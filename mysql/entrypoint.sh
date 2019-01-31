#!/bin/bash

set -e

cat << EOF > /root/.my.cnf
[client]
user=${MYSQL_USER-root}
password=${MYSQL_PASSWORD}
host=${MYSQL_HOST}
port=${MYSQL_PORT-3306}
EOF

exec "$@"
