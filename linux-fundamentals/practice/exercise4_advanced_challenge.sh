#!/bin/bash
# Lab Exercise 4 - Advanced Challenge
# Work with the hidden directory secret_lair

echo "=== Lab Exercise 4: Advanced Challenge ==="

# Create the secret_lair directory structure for demonstration
SECRET_LAIR="secret_lair"
mkdir -p "$SECRET_LAIR/room1"
mkdir -p "$SECRET_LAIR/room2"
mkdir -p "$SECRET_LAIR/room3"

# Make one room permission-restricted
chmod 700 "$SECRET_LAIR/room2"

# Count subdirectories ("rooms")
echo "Counting subdirectories in $SECRET_LAIR:"
ROOM_COUNT=$(find "$SECRET_LAIR" -mindepth 1 -maxdepth 1 -type d | wc -l)
echo "Number of rooms: $ROOM_COUNT"
echo ""

# Identify which one is permission-restricted
echo "Checking permissions of rooms:"
for room in "$SECRET_LAIR"/*; do
    if [ -d "$room" ]; then
        PERMS=$(stat -c "%a" "$room" 2>/dev/null || stat -f "%OLp" "$room" 2>/dev/null)
        if [ "$PERMS" = "700" ] || [ "$PERMS" = "0" ]; then
            echo "Permission-restricted room: $(basename $room) (permissions: $PERMS)"
            RESTRICTED_ROOM=$(basename "$room")
        fi
    fi
done
echo ""

# Find command to change ownership to user
CURRENT_USER=$(whoami)
echo "Command to change ownership to user '$CURRENT_USER':"
echo "chown -R $CURRENT_USER:$CURRENT_USER $SECRET_LAIR"
echo ""

# Write all answers to answer.txt
ANSWER_FILE="answer.txt"
echo "Writing answers to $ANSWER_FILE..."
cat > "$ANSWER_FILE" << EOF
Lab Exercise 4 Answers:
======================

1. Number of rooms in secret_lair: $ROOM_COUNT

2. Permission-restricted room: $RESTRICTED_ROOM

3. Command to change ownership to user:
   chown -R $CURRENT_USER:$CURRENT_USER $SECRET_LAIR

EOF

echo "Answers written to $ANSWER_FILE"
echo ""
echo "Exercise 4 completed!"
