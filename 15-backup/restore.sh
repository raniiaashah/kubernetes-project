#!/bin/sh
# Restore script for MySQL or etcd backups
# Adjust the restore logic to use the correct backup file.

if [ -z "$1" ]; then
  echo "Usage: $0 <backup-file>" >&2
  exit 1
fi

BACKUP_FILE="$1"

if echo "$BACKUP_FILE" | grep -q "mysql"; then
  echo "Restoring MySQL from $BACKUP_FILE"
  mysql -h mysql-service -u root -p"password" mydb < "$BACKUP_FILE"
elif echo "$BACKUP_FILE" | grep -q "etcd"; then
  echo "Restoring etcd from $BACKUP_FILE"
  ETCDCTL_API=3 etcdctl snapshot restore "$BACKUP_FILE" \
    --data-dir=/var/lib/etcd
else
  echo "Unknown backup type: $BACKUP_FILE" >&2
  exit 1
fi

if [ $? -eq 0 ]; then
  echo "Restore completed successfully"
else
  echo "Restore failed" >&2
  exit 1
fi
