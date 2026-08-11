#!/bin/sh
# etcd backup script
# This script uses etcdctl to create a snapshot of the etcd data store.

BACKUP_DIR=/backup
BACKUP_FILE=${BACKUP_DIR}/etcd-snapshot-$(date +%Y%m%d%H%M%S).db

mkdir -p "$BACKUP_DIR"

# Example command for etcdctl; set ETCDCTL_API and endpoints as required.
ETCDCTL_API=3 etcdctl snapshot save "$BACKUP_FILE" \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/pki/ca.crt \
  --cert=/etc/etcd/pki/etcd.crt \
  --key=/etc/etcd/pki/etcd.key

if [ $? -eq 0 ]; then
  echo "etcd backup saved to $BACKUP_FILE"
else
  echo "etcd backup failed" >&2
  exit 1
fi
