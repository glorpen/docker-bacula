#!/bin/bash

set -e

# Directory to store backups in
dumpdir="<%= $datadir %>"
# which backup level should be taken
level="$1"

case "$level" in
   "Full"|"Differential"):
      echo "Performing full/differential backup"
      tstamp=$(date +%Y%m%d-%H%M%S)
      target="${dumpdir}/backup-${level}.${tstamp}.sql.bz2"
      echo "Dumping changes to ${target}"
      mysqldump --defaults-extra-file=/root/.my.cnf --single-transaction --flush-logs --master-data=2 --all-databases --delete-master-logs --routines --events --flush-privileges | /usr/bin/pbzip2 -9 > "${target}"
      ;;
   "Incremental"):
      echo "Performing incremental backup"
      mysqladmin --defaults-extra-file=/root/.my.cnf flush-logs
      ;;
   "clean"):
      echo "Cleaning up"
      rm "${dumpdir}"/backup-*.sql.bz2 &> /dev/null || true
      ;;
   *):
      echo "Not performing anything."
      ;;
esac

exit 0
