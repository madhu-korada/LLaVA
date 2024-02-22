#!/bin/bash

# Define local and remote directories
LOCAL_DIR="/home/madhu/cmu_courses/mmml/LLaVA/"
REMOTE_DIR="user@172.26.75.188:/home/user/madhu/repos/LLaVA/"
PASSWORD="Password1"

# Sync local to remote
# -a: Archive mode to preserve permissions, timestamps, etc.
# -v: Verbose output
# -e: Specify the remote shell to use; here, we're using SSH with a specific key.
# --delete: Delete extraneous files from dest dirs (use with caution)
# rsync -av -r -e ssh  --include '*/' --include '*.py' --include '*.sh' --exclude '*' $LOCAL_DIR $REMOTE_DIR
rsync -av -r -e ssh --exclude 'images/' --exclude '.git/' --exclude 'playground/' $LOCAL_DIR $REMOTE_DIR

# Note: Remove '--delete' if you don't want to delete files in the remote directory that are not present in the local directory.

echo "Sync complete."
