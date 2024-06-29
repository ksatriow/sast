#!/bin/bash

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