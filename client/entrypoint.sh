#!/bin/sh

set -e

conf_file=/opt/bacula/etc/bacula-fd.conf

cat << EOF > "${conf_file}"
FileDaemon {
  Name = ${FD_NAME}
  FDport = ${FD_PORT-9102}
  Maximum Concurrent Jobs = ${FD_CONCURRENT_JOBS-20}
  WorkingDirectory = "/opt/bacula/var/lib"
  Pid Directory = "/opt/bacula/run"
  Plugin Directory = "/opt/bacula/lib"
}
EOF


env | grep '^DIR_' | sed -e 's/^\(DIR_[a-zA-Z0-9_]\+\)_[A-Z]\+=.*/\1/' | sort -u | while read d;
do
    _name=$(eval "echo \${${d}_NAME}")
    _password=$(eval "echo \${${d}_PASSWORD}")
    _monitor=$(eval "echo \${${d}_MONITOR-no}")

    cat << EOF >> "${conf_file}"
Director {
  Name = ${_name}
  Password = "${_password}"
  Monitor = ${_monitor}
}
EOF
done

if [ "x${MESSAGES_DIRECTOR}" = "x" ];
then
    MESSAGES_DIRECTOR="$(eval "echo \$$(env | grep '^DIR_[a-zA-Z0-9_]\+_NAME=' | cut -d= -f1)")"
fi

cat << EOF >> "${conf_file}"
Messages {
  Name = Standard
  director = ${MESSAGES_DIRECTOR} = ${MESSAGES_FILTER-all, !skipped, !restored}
}
EOF

exec "$@"
