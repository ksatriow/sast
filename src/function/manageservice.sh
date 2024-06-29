#!/bin/bash

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