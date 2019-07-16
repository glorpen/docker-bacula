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

      echo "Checking if binlogs are used"
      has_binlogs=$(mysql --batch --silent -e 'select @@log_bin;')
      _DUMP_ARGS=""
      if [ "x${has_binlogs}" = "x1" ];
      then
         _DUMP_ARGS="${_DUMP_ARGS} --master-data=2 --delete-master-logs --flush-logs"
      fi

      echo "Dumping changes to ${target}"
      mysqldump --defaults-extra-file=/root/.my.cnf --column-statistics=0 --single-transaction --all-databases --routines --events --flush-privileges $_DUMP_ARGS $BACKUP_MYSQLDUMP_ARGS | /usr/bin/pbzip2 -9 > "${target}"
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
