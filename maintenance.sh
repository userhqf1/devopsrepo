#!/bin/bash

# Function to test network connectivity
test_network_connectivity() {
    echo "Testing network connectivity..."
    # Attempt to ping google.com to check network connectivity
    if ping -c 4 google.com &> /dev/null; then
        echo "Network connectivity is up."
    else
        echo "Network connectivity is down."
    fi
}

# Function to verify disk space available
check_disk_space() {
    echo "Checking disk space..."
    # Display disk space usage for mounted filesystems
    df -h | grep '^/dev/' | awk '{ print $1, $4, $5 }'
    # $1: Filesystem, $4: Available space, $5: Used space
}

# Function to monitor CPU and RAM usage
monitor_cpu_ram_usage() {
    echo "Monitoring CPU and RAM usage..."
    echo "CPU Usage:"
    # Display CPU usage statistics from the top command
    top -bn1 | grep 'Cpu(s)'
    echo "RAM Usage:"
    # Display RAM usage statistics in a human-readable format
    free -h
}

# Function to check system logs for errors
check_system_logs() {
    echo "Checking system logs for errors..."
    # Search for error or failure messages in system logs
    grep -i 'error\|fail' /var/log/syslog /var/log/messages
    # -i: case-insensitive search, 'error\|fail': search for either "error" or "fail"
}

# Function to update system packages
update_system_packages() {
    echo "Updating system packages..."
    # Update package list and upgrade installed packages
    sudo apt update && sudo apt upgrade -y
    # -y: Automatically answer 'yes' to prompts
}

# Function to check and repair the file system
check_repair_filesystem() {
    echo "Checking and repairing the file system..."
    # Perform file system consistency check and repair if needed
    sudo fsck -A -y
    # -A: Check all file systems listed in fstab, -y: Automatically answer 'yes' to prompts
}

# Function to clear cached files
clear_cached_files() {
    echo "Clearing cached files..."
    # Clean up local repository of retrieved package files
    sudo apt-get clean
    # Remove cached files from /var/cache/
    sudo rm -rf /var/cache/*
}

# Function to check for failed services
check_failed_services() {
    echo "Checking for failed services..."
    # List services that have failed
    systemctl --failed
}

# Function to review security updates
review_security_updates() {
    echo "Reviewing security updates..."
    # Update package list and display available security updates
    sudo apt-get update
    sudo apt-get --just-print upgrade | grep -i 'security'
    # --just-print: Show what would be done without actually doing it
}

# Function to backup important directories
backup_important_directories() {
    echo "Backing up important directories..."
    # Create a backup of the /home directory
    tar -czf /var/backups/home_backup_$(date +%F).tar.gz /home
    # Create a backup of the /etc directory
    tar -czf /var/backups/etc_backup_$(date +%F).tar.gz /etc
    # Use date command to include the current date in the backup file name
}

# Function to check system uptime
check_system_uptime() {
    echo "Checking system uptime..."
    # Display the system's uptime and load averages
    uptime
}

# Function to display menu and get user choice
display_menu() {
    echo "---------------------------------"
    echo "System Administration Menu:"
    echo "---------------------------------"
    echo "1. Test Network Connectivity"
    echo "2. Check Disk Space"
    echo "3. Monitor CPU and RAM Usage"
    echo "4. Check System Logs for Errors"
    echo "5. Update System Packages"
    echo "6. Check and Repair File System"
    echo "7. Clear Cached Files"
    echo "8. Check for Failed Services"
    echo "9. Review Security Updates"
    echo "10. Backup Important Directories"
    echo "11. Check System Uptime"
    echo "12. Exit"
    echo "---------------------------------"
}

# Main function to execute selected tasks
perform_selected_task() {
    while true; do
        display_menu
        # Prompt user for their choice
        read -p "Please enter your choice (1-12): " choice

        case $choice in
            1) test_network_connectivity ;;  # Call the function to test network connectivity
            2) check_disk_space ;;  # Call the function to check disk space
            3) monitor_cpu_ram_usage ;;  # Call the function to monitor CPU and RAM usage
            4) check_system_logs ;;  # Call the function to check system logs
            5) update_system_packages ;;  # Call the function to update system packages
            6) check_repair_filesystem ;;  # Call the function to check and repair file system
            7) clear_cached_files ;;  # Call the function to clear cached files
            8) check_failed_services ;;  # Call the function to check for failed services
            9) review_security_updates ;;  # Call the function to review security updates
            10) backup_important_directories ;;  # Call the function to backup important directories
            11) check_system_uptime ;;  # Call the function to check system uptime
            12) echo "Exiting..."; exit 0 ;;  # Exit the script
            *) echo "Invalid choice, please try again." ;;  # Handle invalid choices
        esac

        echo
    done
}

# Execute the task selection menu
perform_selected_task
