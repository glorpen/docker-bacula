#!/bin/sh

cat << EOF > /opt/bacula/etc/bconsole.conf
Director {
  Name = director
  DIRport = ${DIR_PORT-9101}
  address = ${DIR_ADDRESS-director}
  Password = "${DIR_PASSWORD}"
}
EOF

exec "$@"
