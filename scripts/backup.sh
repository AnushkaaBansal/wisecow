#!/bin/bash

SOURCE_DIR="/path/to/source"
BACKUP_FILE="backup-$(date +%F).tar.gz"
REMOTE_USER="user"
REMOTE_HOST="remoteserver"
REMOTE_DIR="/remote/backup/path"

# Create backup
tar -czf $BACKUP_FILE $SOURCE_DIR
if [ $? -eq 0 ]; then
    echo "Backup of $SOURCE_DIR created successfully as $BACKUP_FILE"
else
    echo "Backup creation failed!"
    exit 1
fi

# Transfer to remote host
scp $BACKUP_FILE $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR
if [ $? -eq 0 ]; then
    echo "Backup transferred to $REMOTE_HOST successfully."
    STATUS="SUCCESS"
else
    echo "Backup transfer failed!"
    STATUS="FAILURE"
fi

# Report
echo "Backup Status: $STATUS. File: $BACKUP_FILE, Remote Location: $REMOTE_HOST:$REMOTE_DIR"
