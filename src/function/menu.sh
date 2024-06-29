#!/bin/bash

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