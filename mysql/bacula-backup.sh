#!/bin/bash

set -e

# Directory to store backups in
dumpdir="${BACKUP_DIR-/var/lib/mysql}"
# which backup level should be taken
level="$1"

case "$level" in
   "Full"|"Differential"):
      echo "Performing full/differential backup"
      tstamp=$(date +%Y%m%d-%H%M%S)
      target="${dumpdir}/backup-${level}.${tstamp}.sql.bz2"
      echo "Dumping changes to ${target}"
      mysqldump --defaults-extra-file=/root/.my.cnf --column-statistics=0 --single-transaction --flush-logs --all-databases --routines --events --flush-privileges $BACKUP_MYSQLDUMP_ARGS | /usr/bin/pbzip2 -9 > "${target}"
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
