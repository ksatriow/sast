#!/bin/bash

LOG_FILE="/var/log/user_management.log"

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
}

get_repository() {
    echo "List of repositories:"
    sudo apt-cache policy
}

create_repository() {
    read -p "Enter repository to add: " repository
    sudo add-apt-repository $repository
    sudo apt-get update
}

update_repository() {
    sudo apt-get update
}

delete_repository() {
    read -p "Enter repository to remove: " repository
    sudo add-apt-repository --remove $repository
    sudo apt-get update
}

get_service() {
    echo "List of services:"
    sudo systemctl list-units --type=service
}

create_service() {
    echo "Creating a new service..."
}

update_service() {
    echo "Updating a service..."
}

delete_service() {
    read -p "Enter service name to delete: " service
    sudo systemctl stop $service
    sudo systemctl disable $service
}

get_network() {
    echo "List of network interfaces:"
    ip addr
}

create_network() {
    echo "Creating a new network interface..."
}

update_network() {
    echo "Updating a network interface..."
}

delete_network() {
    echo "Deleting a network interface..."
}

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

user_management_menu() {
    while true; do
        clear
        echo "======================="
        echo " User Management Menu"
        echo "======================="
        echo "1. Add User"
        echo "2. Remove User"
        echo "3. Get List of Users"
        echo "4. Update User"
        echo "5. Get User Logs"
        echo "6. Check Active Sessions"
        echo "7. Back to Manage Menu"
        echo "======================="
        read -p "Enter your choice: " choice

        case $choice in
            1) add_user ;;
            2) delete_user ;;
            3) list_users ;;
            4) update_user ;;
            5) retrieve_logs ;;
            6) check_active_sessions ;;
            7) break ;;
            *) echo "Invalid choice. Please enter a number between 1 and 7." ;;
        esac

        read -p "Press [Enter] key to continue..."
    done
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
    echo "2. Manage"
    echo "3. Health Check"
    echo "4. Extra Tools"
    echo "5. Daily Task"
    echo "6. Remove"
    echo "7. Exit"
    read -p "Please select an option [1-7]: " main_option

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
                echo "Manage Menu"
                echo "1. User"
                echo "2. Repository"
                echo "3. Services"
                echo "4. Network"
                echo "5. Back to Main Menu"
                read -p "Please select an option [1-5]: " manage_option

                case $manage_option in
                    1)
                        while true; do
                            clear
                            echo "======================="
                            echo " User Management Menu"
                            echo "======================="
                            echo "1. Add User"
                            echo "2. Remove User"
                            echo "3. Get List of Users"
                            echo "4. Update User"
                            echo "5. Get User Logs"
                            echo "6. Check Active Sessions"
                            echo "7. Back to Manage Menu"
                            echo "======================="
                            read -p "Enter your choice: " choice

                            case $choice in
                                1) add_user ;;
                                2) delete_user ;;
                                3) list_users ;;
                                4) update_user ;;
                                5) retrieve_logs ;;
                                6) check_active_sessions ;;
                                7) break ;;
                                *) echo "Invalid choice. Please enter a number between 1 and 7." ;;
                            esac

                            read -p "Press [Enter] key to continue..."
                        done
                        ;;
                    2)
                        while true; do
                            clear
                            echo "Repository Management"
                            echo "1. Get Repositories"
                            echo "2. Create Repository"
                            echo "3. Update Repository"
                            echo "4. Delete Repository"
                            echo "5. Back to Manage Menu"
                            read -p "Please select an option [1-5]: " repo_option

                            case $repo_option in
                                1) get_repository ;;
                                2) create_repository ;;
                                3) update_repository ;;
                                4) delete_repository ;;
                                5) break ;;
                                *) echo "Invalid option, please try again." ;;
                            esac

                            read -p "Press [Enter] key to continue..."
                        done
                        ;;
                    3)
                        while true; do
                            clear
                            echo "Service Management"
                            echo "1. Get Services"
                            echo "2. Create Service"
                            echo "3. Update Service"
                            echo "4. Delete Service"
                            echo "5. Back to Manage Menu"
                            read -p "Please select an option [1-5]: " service_option

                            case $service_option in
                                1) get_service ;;
                                2) create_service ;;
                                3) update_service ;;
                                4) delete_service ;;
                                5) break ;;
                                *) echo "Invalid option, please try again." ;;
                             esac

                            read -p "Press [Enter] key to continue..."
                        done
                        ;;
                    4)
                        while true; do
                            clear
                            echo "Network Management"
                            echo "1. Get Network Interfaces"
                            echo "2. Create Network Interface"
                            echo "3. Update Network Interface"
                            echo "4. Delete Network Interface"
                            echo "5. Back to Manage Menu"
                            read -p "Please select an option [1-5]: " network_option

                            case $network_option in
                                1) get_network ;;
                                2) create_network ;;
                                3) update_network ;;
                                4) delete_network ;;
                                5) break ;;
                                *) echo "Invalid option, please try again." ;;
                            esac

                            read -p "Press [Enter] key to continue..."
                        done
                        ;;
                    5) break ;;
                    *) echo "Invalid option, please try again." ;;
                esac

                read -p "Press [Enter] key to continue..."
            done
            ;;
        3)
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
        4)
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
        5)
            while true; do
                clear
                echo "Daily Task Menu"
                echo "1. Healthcheck Report"
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
        6)
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
        7)
            break ;;
        *) echo "Invalid option, please try again." ;;
    esac
done

echo "He He Not Bad"
echo "Dengan Senang Hati"
