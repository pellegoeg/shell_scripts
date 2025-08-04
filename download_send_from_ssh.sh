#!/bin/bash

<<<<<<< HEAD
# Usage: ./download_and_mail.sh <remote_folder> <email_address>

# Config
REMOTE_USER_HOST=$1
REMOTE_BASE_PATH=$(dirname $2)

# Arguments
=======
# Usage: ./download_and_mail.sh <ssh_hosts> <remote_folder> <email_address>

# Arguments
REMOTE_USER_HOST=$1
REMOTE_BASE_PATH=$(dirname $2)
>>>>>>> a01f447 (added download from ssh script)
FOLDER_NAME=$(basename "$2")
EMAIL="$3"

if [[ -z "$FOLDER_NAME" || -z "$EMAIL" ]]; then
  echo "Usage: $0 <sshhost> <remote_folder> <email_address>"
  exit 1
fi

# Output zip file
ZIP_NAME="${FOLDER_NAME}.zip"
LOCAL_ZIP_PATH="${PWD}/${ZIP_NAME}"

echo "Zipping and downloading '$FOLDER_NAME' from $REMOTE_USER_HOST..."

# Download and zip the remote folder
ssh "$REMOTE_USER_HOST" "cd $REMOTE_BASE_PATH && zip -r - $FOLDER_NAME" > "$LOCAL_ZIP_PATH"


if [[ $? -ne 0 ]]; then
  echo "Error: Failed to download or zip the remote folder."
  exit 1
fi

echo "Saved to $LOCAL_ZIP_PATH"

# AppleScript to open new Outlook email with the zip attached
osascript <<EOF
tell application "Microsoft Outlook"
    set newMessage to make new outgoing message with properties {subject:"Export: $FOLDER_NAME", content:"Attached is the export for $FOLDER_NAME."}
    make new recipient at newMessage with properties {email address:{name:"", address:"$EMAIL"}}
    make new attachment at newMessage with properties {file:POSIX file "$LOCAL_ZIP_PATH"}
    open newMessage
    activate
end tell
EOF

echo "Outlook email ready with attachment."

