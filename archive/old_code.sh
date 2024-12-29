#!/bin/bash

# Set logfile path
logfile="encryption.log"

# Logfile messages function
log_message() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$logfile"  
}

# Following code creates a dialog box with 3 buttons and prompts the user to select an option
action=$(osascript <<EOF
set userChoice to button returned of (display dialog "What would you like to do?" buttons {"Encrypt", "Decrypt", "Cancel"} default button "Encrypt")
return userChoice
EOF
)

# Handling the cancel
if [ "$action" == "Cancel" ]; then
    osascript -e 'display dialog "Action canceled by user" buttons {"OK"}'
    log_message "User cancelled the action"
    exit 0
fi

# Selecting file with MacOS file picker
file=$(osascript <<EOF
set filePath to POSIX path of (choose file with prompt "Select a file for $action")
return filePath
EOF
)

# Check for empty file
if [ -z "$file" ]; then
    osascript -e 'display dialog "No file selected" buttons {"OK"} with icon caution'
    log_message "No file selected"
    exit 1
fi

# Encryption with gpg
if [ "$action" == "Encrypt" ]; then
    gpg -c "$file" 2>/dev/null

    # Checking if encryption finished successfully
    if [ $? -eq 0 ]; then
        osascript -e "display dialog \"File successfully encrypted: $file.gpg\" buttons {\"OK\"}"
        log_message "File successfully encrypted: $file.gpg"
    else
        osascript -e 'display dialog "Encryption failed" buttons {"OK"} with icon stop'
        log_message "Encryption failed for the file: $file"
    fi

# Decryption 
elif [ "$action" == "Decrypt" ]; then
    output=$(osascript <<EOF
set filePath to POSIX path of (choose file with prompt "Select a GPG file for $action")
return filePath
EOF
)

    # Check for empty file
    if [ -z "$output" ]; then
        osascript -e 'display dialog "No file selected" buttons {"OK"} with icon caution'
        log_message "No file selected for Decryption"
        exit 1
    fi

    # Decrypt with gpg
    gpg -d "$output" > "${output%.*}" 2>/dev/null

    # Checking if decryption finished successfully
    if [ $? -eq 0 ]; then
        osascript -e "display dialog \"File successfully decrypted to: ${output%.*}\" buttons {\"OK\"}"
        log_message "File successfully decrypted to: ${output%.*}"
    else
        osascript -e 'display dialog "Decryption failed" buttons {"OK"} with icon stop'
        log_message "Encryption failed for the file: $output"
    fi
fi