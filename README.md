# ${SSH\{\color{blue}Storm}}\ v1.0$

Revolutionizing SSH penetration testing tool for efficient scanning and brute force attacks. Take your security assessments to the next level with SSHStorm, the ultimate tool for authorized penetration testing.

SSHStorm is designed to perform multi-threaded SSH scanning and brute force attacks, offering a convenient and efficient way to scan a range of IP addresses for SSH services and attempt to authenticate using a list of usernames and passwords.

## Installation

1. Clone the repository:

   ```shell
   git clone https://github.com/ẃuseman/sshstorm.git
   ```

2. Navigate to the project directory:

   ```shell
   cd sshstorm
   ```

3. Install the required dependencies:

   - **macOS**:
     - Ensure that you have Homebrew installed. If not, install it by following the instructions at [https://brew.sh/](https://brew.sh/).
     - Install `nc` (NetCat) and `sshpass` by running the following commands:
       ```shell
       brew install netcat
       brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
       ```

   - **Linux** (Debian-based distributions):
     - Install `nc` (NetCat) and `sshpass` using the package manager. For example, on Ubuntu or Debian, run the following command:
       ```shell
       sudo apt-get install -y nc sshpass
       ```

   - **Termux** (Android):
     - Install the Termux app from the Google Play Store.
     - Open Termux and run the following commands to update Termux and install the required dependencies:
       ```shell
       pkg update
       pkg install netcat-openbsd sshpass
       ```

   - **WSL2** (Windows Subsystem for Linux):
     - Launch your WSL2 distribution (e.g., Ubuntu) from the Windows Start menu.
     - Update the package manager and install the dependencies within your WSL2 distribution. For example, on Ubuntu, run the following commands:
       ```shell
       sudo apt-get update
       sudo apt-get install -y nc sshpass
       ```

4. Make the script executable:

   ```shell
   chmod +x sshstorm.sh
   ```

5. You are now ready to use SSHStorm!

## Usage

```shell
bash sshstorm.sh [OPTIONS]
```

Options:

- `-i, --iplist FILE`: Use this option to provide a custom file with a list of IP addresses. If not provided, the tool will use the default 'iplist.txt' file.
- `-p, --port PORT`: Use this option to specify the SSH port. The default port is 22.
- `-u, --users FILE`: Use this option to provide a custom file with a list of usernames. If not provided, the tool will use the default 'usernames.txt' file.
- `-w, --wordlist FILE`: Use this option to provide a custom file with a list of passwords. If not provided, the tool will use the default 'wordlist.txt' file.
- `-t, --threads NUM`: Use this option to specify the number of threads to use for scanning or brute force attack. The default number of threads is 100.
- `-x, --timeout SECONDS`: Use this option to set a custom timeout duration in seconds for each SSH attempt. The default timeout duration is 5 seconds.
- `-h, --help`: Display the help message.

Example usage:

- Perform IP range scanning with custom options:
  ```shell
  bash sshstorm.sh -i myiplist.txt -p 2222 -t 50
  ```



- Perform SSH brute force attack with custom options:
  ```shell
  bash sshstorm.sh -u myusers.txt -w mywordlist.txt
  ```

Additional examples:

1. Perform IP range scanning with default options:
   ```shell
   bash sshstorm.sh
   ```

2. Perform SSH brute force attack with default options:
   ```shell
   bash sshstorm.sh --bruteforcer
   ```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Author

Created by wuseman

## Contributing

Contributions to SSHStorm are welcome! If you encounter any issues or have suggestions for improvements, please [open an issue](https://github.com/wuseman/sshstorm/issues) or submit a pull request.

## Troubleshooting and FAQ

- Q: What should I do if I encounter an error while installing or using SSHStorm?
  - A: Make sure you have installed all the required dependencies and followed the installation instructions correctly. If the issue persists, please [open an issue](https://github.com/wuseman/sshstorm/issues) with detailed information about the error.

- Q: What types of contributions are welcome?
  - A: We welcome a variety of contributions, including code improvements, bug fixes, feature suggestions, and documentation enhancements. If you have something valuable to contribute that aligns with the project's goals, we'd love to see it!

## Changelog

- v1.0: Initial release of SSHStorm.

## Disclaimer

Please note that SSHStorm is intended for authorized penetration testing and security assessment purposes only. Misuse of this tool on unauthorized systems is illegal and prohibited. Use it responsibly and at your own risk.
