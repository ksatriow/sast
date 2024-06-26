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

install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Installing Docker..."
        sudo apt-get update
        sudo apt-get install -y \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg-agent \
            software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository \
            "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) \
            stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io
        sudo systemctl start docker
        sudo systemctl enable docker
        echo "Docker installed successfully."
    else
        echo "Docker is already installed."
    fi
}

install_postgresql() {
    if ! command -v psql &> /dev/null; then
        echo "Installing PostgreSQL..."
        sudo apt-get update
        sudo apt-get install -y postgresql postgresql-contrib
        sudo systemctl start postgresql
        sudo systemctl enable postgresql
        echo "PostgreSQL installed successfully."
    else
        echo "PostgreSQL is already installed."
    fi
}

install_mysql() {
    if ! command -v mysql &> /dev/null; then
        echo "Installing MySQL..."
        sudo apt-get update
        sudo apt-get install -y mysql-server
        sudo systemctl start mysql
        sudo systemctl enable mysql
        echo "MySQL installed successfully."
    else
        echo "MySQL is already installed."
    fi
}

install_nginx() {
    if ! command -v nginx &> /dev/null; then
        echo "Installing Nginx..."
        sudo apt-get update
        sudo apt-get install -y nginx
        sudo systemctl start nginx
        sudo systemctl enable nginx
        echo "Nginx installed successfully."
    else
        echo "Nginx is already installed."
    fi
}

install_lynis() {
    if ! command -v lynis &> /dev/null; then
        echo "Installing Lynis..."
        curl -s https://packages.cisofy.com/keys/cisofy-software-public.key | sudo apt-key add -
        echo "deb https://packages.cisofy.com/community/lynis/deb/ stable main" | sudo tee /etc/apt/sources.list.d/cisofy-lynis.list
        sudo apt-get update
        sudo apt-get install -y lynis
        echo "Lynis installed successfully."
    else
        echo "Lynis is already installed."
    fi
}

install_clamav() {
    if ! command -v clamscan &> /dev/null; then
        echo "Installing ClamAV..."
        sudo apt-get update
        sudo apt-get install -y clamav clamav-daemon
        sudo systemctl start clamav-daemon
        sudo systemctl enable clamav-daemon
        echo "ClamAV installed successfully."
    else
        echo "ClamAV is already installed."
    fi
}

remove_package() {
    PACKAGE=$1
    if command -v $PACKAGE &> /dev/null; then
        echo "Removing $PACKAGE..."
        sudo apt-get remove -y $PACKAGE
        sudo apt-get purge -y $PACKAGE
        echo "$PACKAGE removed successfully."
    else
        echo "$PACKAGE is not installed."
    fi
}

check_uptime() {
    echo "System Uptime:"
    uptime
}

check_cpu() {
    echo "CPU Usage:"
    top -bn1 | grep "Cpu(s)"
}

check_memory() {
    echo "Memory Usage:"
    free -h
}

check_disk() {
    echo "Disk Usage:"
    df -h
}

healthcheck_report() {
    echo "Health Check Report:"
    check_uptime
    check_cpu
    check_memory
    check_disk
}

audit_system() {
    echo "Auditing System with Lynis..."
    sudo lynis audit system
}

monitoring_service() {
    echo "Monitoring Services..."
    sudo systemctl list-units --type=service
}

daily_backup_database() {
    echo "Daily Backup Database..."
    # Still On Progress
}

# Main menu
while true; do
    clear
    echo "─────────────────────────────────────────────────────────────"
    echo "─────────────────────────────────────────────────────────────"
    echo "─██████████████─██████████████─██████████████─██████████████─"
    echo "─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─"
    echo "─██░░██████████─██░░██████░░██─██░░██████████─██████░░██████─"
    echo "─██░░██─────────██░░██──██░░██─██░░██─────────────██░░██─────"
    echo "─██░░██████████─██░░██████░░██─██░░██████████─────██░░██─────"
    echo "─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─────██░░██─────"
    echo "─██████████░░██─██░░██████░░██─██████████░░██─────██░░██─────"
    echo "─────────██░░██─██░░██──██░░██─────────██░░██─────██░░██─────"
    echo "─██████████░░██─██░░██──██░░██─██████████░░██─────██░░██─────"
    echo "─██░░░░░░░░░░██─██░░██──██░░██─██░░░░░░░░░░██─────██░░██─────"
    echo "─██████████████─██████──██████─██████████████─────██████─────"
    echo "─────────────────────────────────────────────────────────────"
    echo "─────────────────────────────────────────────────────────────"
    echo "Main Menu"
    echo "1. Init"
    echo "2. Health Check"
    echo "3. Extra Tools"
    echo "4. Daily Task"
    echo "5. Remove"
    echo "6. Exit"
    read -p "Please select an option [1-6]: " main_option

    case $main_option in
        1)
            while true; do
                clear
                echo "Init Menu"
                echo "1. Install SSH"
                echo "2. Install Git"
                echo "3. Install Vim"
                echo "4. Install PHP"
                echo "5. Back to Main Menu"
                read -p "Please select an option [1-5]: " install_option

                case $install_option in
                    1) install_package ssh ;;
                    2) install_package git ;;
                    3) install_package vim ;;
                    4) install_package php ;;
                    5) break ;;
                    *) echo "Invalid option, please try again." ;;
                esac

                read -p "Press [Enter] key to continue..."
            done
            ;;
        2)
            while true; do
                clear
                echo "Health Check Menu"
                echo "1. Check Uptime"
                echo "2. Check CPU Usage"
                echo "3. Check Memory Usage"
                echo "4. Check Disk Usage"
                echo "5. Back to Main Menu"
                read -p "Please select an option [1-5]: " healthcheck_option

                case $healthcheck_option in
                    1) check_uptime ;;
                    2) check_cpu ;;
                    3) check_memory ;;
                    4) check_disk ;;
                    5) break ;;
                    *) echo "Invalid option, please try again." ;;
                esac

                read -p "Press [Enter] key to continue..."
            done
            ;;
        3)
            while true; do
                clear
                echo "Extra Tools Menu"
                echo "1. Install Docker"
                echo "2. Install PostgreSQL"
                echo "3. Install MySQL"
                echo "4. Install Nginx"
                echo "5. Install Lynis"
                echo "6. Install ClamAV"
                echo "7. Back to Main Menu"
                read -p "Please select an option [1-7]: " extra_tools_option

                case $extra_tools_option in
                    1) install_docker ;;
                    2) install_postgresql ;;
                    3) install_mysql ;;
                    4) install_nginx ;;
                    5) install_lynis ;;
                    6) install_clamav ;;
                    7) break ;;
                    *) echo "Invalid option, please try again." ;;
                esac

                read -p "Press [Enter] key to continue..."
            done
            ;;
        4)
            while true; do
                clear
                echo "Daily Task Menu"
                echo "1. Health Check Report"
                echo "2. Audit System"
                echo "3. Monitoring Service"
                echo "4. Daily Backup Database"
                echo "5. Back to Main Menu"
                read -p "Please select an option [1-5]: " daily_task_option

                case $daily_task_option in
                    1) healthcheck_report ;;
                    2) audit_system ;;
                    3) monitoring_service ;;
                    4) daily_backup_database ;;
                    5) break ;;
                    *) echo "Invalid option, please try again." ;;
                esac

                read -p "Press [Enter] key to continue..."
            done
            ;;
        5)
            while true; do
                clear
                echo "Remove Menu"
                echo "1. Remove Nginx"
                echo "2. Remove Docker"
                echo "3. Remove PostgreSQL"
                echo "4. Remove MySQL"
                echo "5. Remove Lynis"
                echo "6. Remove ClamAV"
                echo "7. Remove PHP"
                echo "8. Back to Main Menu"
                read -p "Please select an option [1-8]: " remove_option

                case $remove_option in
                    1) remove_package nginx ;;
                    2) remove_package docker ;;
                    3) remove_package postgresql ;;
                    4) remove_package mysql ;;
                    5) remove_package lynis ;;
                    6) remove_package clamav ;;
                    7) remove_package php ;;
                    8) break ;;
                    *) echo "Invalid option, please try again." ;;
                esac

                read -p "Press [Enter] key to continue..."
            done
            ;;
        6)
            break ;;
        *) echo "Invalid option, please try again." ;;
    esac
done

echo "He He Not Bad"
echo "Dengan Senang Hati"
