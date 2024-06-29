#!/bin/bash

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