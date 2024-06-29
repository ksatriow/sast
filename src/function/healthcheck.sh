#!/bin/bash

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