#!/bin/sh
# MySQL backup script
# This script uses mysqldump to export the database to a dump file.

BACKUP_DIR=/backup
BACKUP_FILE=${BACKUP_DIR}/mysql-backup-$(date +%Y%m%d%H%M%S).sql

mkdir -p "$BACKUP_DIR"

# Example mysqldump command; set MYSQL_USER and MYSQL_PASSWORD appropriately.
mysqldump -h mysql-service -u root -p"password" mydb > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
  echo "MySQL backup saved to $BACKUP_FILE"
else
  echo "MySQL backup failed" >&2
  exit 1
fi
