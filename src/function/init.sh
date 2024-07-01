#!/bin/bash

install_package() {
    PACKAGE=$1
    if ! command -v $PACKAGE &> /dev/null; then
        echo "Installing $PACKAGE..."
        sudo apt-get update
        sudo apt-get install -y $PACKAGE
        echo "$PACKAGE installed successfully."
    else
        echo "$PACKAGE is already installed."
    fi
}

select_timezone() {
    timezones=$(timedatectl list-timezones)
    
    IFS=$'\n' read -d '' -r -a timezone_array <<< "$timezones"

    echo "Please select a timezone from the list below:"

    select timezone in "${timezone_array[@]}"; do
        if [[ -n "$timezone" ]]; then
            echo "You have selected: $timezone"
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done

    echo "Setting timezone to $timezone"
    
    sudo timedatectl set-timezone "$timezone"
    
    if [[ $? -eq 0 ]]; then
        echo "Timezone has been set to $timezone successfully."
    else
        echo "Failed to set timezone."
    fi
}

check_root_privileges() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root. Re-executing with sudo..."
        exec sudo "$0" "$@"
    fi
}

set_hostname() {
    echo "Enter the new hostname: "
    read new_hostname

    if [[ -z "$new_hostname" ]]; then
        echo "Hostname cannot be empty."
        return 1
    elif [[ "$new_hostname" =~ [^a-zA-Z0-9.-] ]]; then
        echo "Hostname can only contain letters, numbers, dots, and hyphens."
        return 1
    fi

    sudo hostnamectl set-hostname $new_hostname
    
    if [[ $? -eq 0 ]]; then
        echo "Hostname has been set to $new_hostname successfully."
    else
        echo "Failed to set hostname."
    fi
}

configure_ssh() {
    echo "Would you like to install OpenSSH server? (y/n): "
    read install_ssh
    if [[ $install_ssh == "y" ]]; then
        sudo apt update
        sudo apt install -y openssh-server
        sudo systemctl enable ssh
        sudo systemctl start ssh
        echo "OpenSSH server installed and started."
    fi

    echo "Would you like to setup SSH keys? (y/n): "
    read setup_keys
    if [[ $setup_keys == "y" ]]; then
        echo "Enter your email for SSH key generation: "
        read email
        ssh-keygen -t rsa -b 4096 -C "$email"
        echo "SSH key generated."
    fi
}

configure_git() {
    echo "Enter your Git username: "
    read git_username
    git config --global user.name "$git_username"
    echo "Git username set to $git_username."

    echo "Enter your Git email: "
    read git_email
    git config --global user.email "$git_email"
    echo "Git email set to $git_email."
}