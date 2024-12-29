# LockBox (File Encryption and Decryption Script)

This is a simple Bash script that provides encryption and decryption functionality using GPG (GNU Privacy Guard) and a graphical user interface (GUI) on macOS using Applescript/Osascript. The script allows users to encrypt and decrypt files easily with the help of dialogs and prompts.

## Features

- **Encrypt**: Encrypts a file using GPG with a symmetric cipher.
- **Decrypt**: Decrypts a GPG-encrypted file.
- **Logs**: Logs each action (encryption and decryption) in separate log files.
- **macOS GUI**: Uses AppleScript to display dialogs and allow file selection, making the script user-friendly for macOS users.
- **Error Handling**: Proper error messages if encryption or decryption fails or if an unsupported file is selected.

## Requirements

- **macOS**: The script uses AppleScript for GUI dialogs, so it is intended to run on macOS.
- **GPG**: The script uses GPG for encryption and decryption. You can install GPG using [Homebrew](https://brew.sh/):

  ```bash
  brew install gnupg
  ```

- **Creating a GPG Key**: To use GPG for encryption and decryption, you’ll need a GPG key. Follow these steps to create one:

1. Open the terminal and generate a new GPG key:

```bash
gpg --full-generate-key
```

2. You’ll be prompted to choose the key type. Select the default option ECC (sign and encrypt) by typing 9 and pressing Enter.
3. Next, set the key size. The default size (2048 bits) is recommended for most use cases. You can press Enter to accept the default.
4. Set the expiration date for the key. You can choose a specific time or leave it blank (0) for no expiration.
5. Enter your name and email address when prompted. This will be associated with your GPG key.
6. Choose a passphrase to protect your key. Make sure it’s strong and memorable.
7. Once the key is generated, you can view it by running:

```bash
gpg --list-keys
```

## Installation

To get started with the script, follow these steps:

1. **Clone this repository to your local machine**:

   ```bash
   git clone https://github.com/yourusername/LockBox.git
   ```

2. **Navigate to the directory**:

   ```bash
   cd LockBox
   ```

3. **Make the script executable**:

   ```bash
   chmod +x encrypt_decrypt.sh
   ```

4. **Ensure you have GPG installed on your macOS machine. If not, you can install it using the following command**:

   ```bash
   brew install gnupg
   ```

## Usage

To run the script, execute the following command:

```bash
./encrypt_decrypt.sh
```

When you run the script, you’ll be presented with a dialog box asking whether you want to encrypt or decrypt a file.

### Encrypting a File

1. Select “Encrypt” when prompted.
2. Choose a file you want to encrypt.
3. The script will encrypt the file using GPG and save the encrypted file with a `.gpg` extension.
4. A dialog will display confirming that the file was encrypted successfully.

### Decrypting a File

1. Select “Decrypt” when prompted.
2. Choose a `.gpg` file to decrypt.
3. The script will decrypt the file and save it with the original file name (without the `.gpg` extension).
4. A dialog will display confirming that the file was decrypted successfully.

## Logs

The script generates log files for both encryption and decryption actions:

- Encryption logs are saved in `logs/encryption.log`.
- Decryption logs are saved in `logs/decryption.log`.

## Script Breakdown

### 1. Encryption:

- Uses `gpg -c` to encrypt the selected file with a symmetric key (password-based).
- Logs the success or failure of the encryption process.

### 2. Decryption:

- Uses `gpg -d` to decrypt the selected `.gpg` file.
- Logs the success or failure of the decryption process.
- Ensures that only `.gpg` files are processed during decryption.

### 3. Logging:

- Each action (encryption or decryption) is logged in a separate file: `logs/encryption.log` or `logs/decryption.log`.

### 4. AppleScript:

- Used for dialog prompts, file selection, and error handling. This provides a simple GUI experience for the user.

## Contributing

Feel free to fork this repository and submit pull requests if you want to contribute improvements, bug fixes, or new features!

## License

This project is licensed under the MIT License - see the LICENSE file for details.
