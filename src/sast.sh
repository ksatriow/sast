#!/bin/bash

source ../function/audit.sh
source ../function/dailytask.sh
source ../function/extratools.sh
source ../function/healthcheck.sh
source ../function/init.sh
source ../function/managedatabase.sh
source ../function/managenetwork.sh
source ../function/managerepository.sh
source ../function/manageservice.sh
source ../function/manageuser.sh
source ../function/menu.sh


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
