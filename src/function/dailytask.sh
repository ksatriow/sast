#!/bin/bash

monitoring_service() {
    echo "Monitoring Services..."
    sudo systemctl list-units --type=service
}

daily_backup_database() {
    echo "Daily Backup Database..."
}

