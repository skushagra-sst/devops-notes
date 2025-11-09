#!/bin/bash
# Example: give a team shared access automatically
SHARE_DIR="/data/team"
USER_LIST="alice bob charlie"

for user in $USER_LIST; do
    setfacl -m u:$user:rwx $SHARE_DIR
done

echo "ACL permissions set for team members on $SHARE_DIR"
