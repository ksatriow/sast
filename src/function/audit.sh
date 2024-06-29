#!/bin/bash

LOG_FILE="/var/log/user_management.log"

if [ ! -f "$LOG_FILE" ]; then
    sudo touch $LOG_FILE
    sudo chmod 666 $LOG_FILE
fi

log_activity() {
    local action=$1
    local user=$2
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $action - $user" | sudo tee -a $LOG_FILE > /dev/null
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_auditd() {
    if ! command_exists auditctl; then
        echo "Installing auditd..."
        sudo apt-get update
        sudo apt-get install -y auditd audispd-plugins
    else
        echo "auditd is already installed."
    fi

    if [ ! -d "/etc/audit/rules.d/" ]; then
        echo "Creating audit rules directory..."
        sudo mkdir -p /etc/audit/rules.d/
    fi

    if [ ! -f "/etc/audit/rules.d/audit.rules" ]; then
        echo "Creating audit rules file..."
        sudo touch /etc/audit/rules.d/audit.rules
        sudo chmod 600 /etc/audit/rules.d/audit.rules
    fi
}

configure_auditd() {
    local username=$1
    local audit_rules_file="/etc/audit/rules.d/audit.rules"

    echo "Configuring auditd to log commands for user: $username"

    sudo bash -c "echo '-a exit,always -F arch=b64 -F euid=$username -S execve' >> $audit_rules_file"
    sudo bash -c "echo '-a exit,always -F arch=b32 -F euid=$username -S execve' >> $audit_rules_file"

    echo "Restarting auditd service..."
    sudo systemctl restart auditd || echo "Failed to restart auditd. Please check the auditd service status."
}

audit_system() {
    echo "Auditing System with Lynis..."
    sudo lynis audit system
}