#!/bin/bash

# Set log file paths for encryption and decryption
encryption_log="logs/encryption.log"
decryption_log="logs/decryption.log"

# Function to log messages to specific log files
log_message() {
    local action=$1
    local message=$2
    local log_file=$3
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$log_file"
}

# Creates logs directory if it doesn't exist
mkdir -p logs

# Following code creates a dialog box with 3 buttons and prompts the user to select an option
action=$(osascript <<EOF
set userChoice to button returned of (display dialog "What would you like to do?" buttons {"Encrypt", "Decrypt", "Cancel"} default button "Encrypt")
return userChoice
EOF
)

# Handling the cancel
if [ "$action" == "Cancel" ]; then
    osascript -e 'display dialog "Action canceled by user" buttons {"OK"}'
    log_message "Cancel" "User canceled the action." "$encryption_log"
    log_message "Cancel" "User canceled the action." "$decryption_log"
    exit 0
fi

# Selecting file with MacOS file picker (for both encrypt and decrypt)
file=$(osascript <<EOF
set filePath to POSIX path of (choose file with prompt "Select a file for $action")
return filePath
EOF
)

# Check for empty file
if [ -z "$file" ]; then
    osascript -e 'display dialog "No file selected" buttons {"OK"} with icon caution'
    log_message "$action" "No file selected." "$encryption_log"
    log_message "$action" "No file selected." "$decryption_log"
    exit 1
fi

# Encryption with gpg
if [ "$action" == "Encrypt" ]; then
    gpg -c "$file" 2>/dev/null

    # Checking if encryption finished successfully
    if [ $? -eq 0 ]; then
        osascript -e "display dialog \"File successfully encrypted: $file.gpg\" buttons {\"OK\"}"
        log_message "$action" "File encrypted successfully: $file.gpg" "$encryption_log"
    else
        osascript -e 'display dialog "Encryption failed" buttons {"OK"} with icon stop'
        log_message "$action" "Encryption failed for file: $file" "$encryption_log"
    fi

# Decryption 
elif [ "$action" == "Decrypt" ]; then
    # Only check if the selected file is a GPG file for decryption
    if [[ "$file" != *.gpg ]]; then
        osascript -e 'display dialog "Selected file is not a valid GPG file" buttons {"OK"} with icon caution'
        log_message "$action" "Selected file is not a valid GPG file." "$decryption_log"
        exit 1
    fi

    # Decrypt with gpg
    gpg -d "$file" > "${file%.*}" 2>/dev/null

    # Checking if decryption finished successfully
    if [ $? -eq 0 ]; then
        osascript -e "display dialog \"File successfully decrypted to: ${file%.*}\" buttons {\"OK\"}"
        log_message "$action" "File decrypted successfully to: ${file%.*}" "$decryption_log"
    else
        osascript -e 'display dialog "Decryption failed" buttons {"OK"} with icon stop'
        log_message "$action" "Decryption failed for file: $file" "$decryption_log"
    fi
fi