#!/bin/bash

add_user() {
    local username password expire_date
    read -p "Enter username: " username
    read -s -p "Enter password: " password
    echo
    read -p "Enter expiration date (YYYY-MM-DD): " expire_date

    sudo useradd -m -d /home/$username -p $(openssl passwd -1 $password) -e $expire_date $username
    if [ $? -eq 0 ]; then
        echo "User $username added successfully"
        log_activity "ADD_USER" $username
        configure_auditd $username
    else
        echo "Failed to add user $username"
    fi
}

delete_user() {
    local username
    read -p "Enter username to delete: " username

    sudo userdel $username
    if [ $? -eq 0 ]; then
        echo "User $username deleted successfully"
        log_activity "DELETE_USER" $username
    else
        echo "Failed to delete user $username"
    fi
}

update_user() {
    local username new_shell new_password expire_date
    read -p "Enter username to update: " username
    echo "Choose the attribute to update:"
    echo "1. Shell"
    echo "2. Password"
    echo "3. Expiration Date"
    read -p "Enter your choice [1-3]: " attribute

    case $attribute in
        1)
            read -p "Enter new shell: " new_shell
            sudo usermod -s $new_shell $username
            ;;
        2)
            read -s -p "Enter new password: " new_password
            echo
            sudo usermod -p $(openssl passwd -1 $new_password) $username
            ;;
        3)
            read -p "Enter new expiration date (YYYY-MM-DD): " expire_date
            sudo usermod -e $expire_date $username
            ;;
        *)
            echo "Invalid choice"
            return
            ;;
    esac

    if [ $? -eq 0 ]; then
        echo "User $username updated successfully"
        log_activity "UPDATE_USER" $username
    else
        echo "Failed to update user $username"
    fi
}

list_users() {
    cut -d: -f1 /etc/passwd
    log_activity "LIST_USERS" "N/A"
}

retrieve_logs() {
    local username
    read -p "Enter username to retrieve logs: " username

    sudo ausearch -ua "$username"
    if [ $? -ne 0 ]; then
        echo "No logs found for user $username"
    fi
}

check_active_sessions() {
    local username
    read -p "Enter username to check active sessions: " username

    who | grep "$username"
    if [ $? -ne 0 ]; then
        echo "No active sessions found for user $username"
    else
        echo "Active sessions for user $username:"
        who | grep "$username"
    fi
}