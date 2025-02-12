#!/usr/bin/env fish

# Exit immediately if any command fails
function on_error --on-event fish_exit
    exit 1
end

# Cache sudo credentials & Keep them active
sudo -v
fish -c "
    while true
        sudo -n true
        sleep 60
        if not kill -0 $fish_pid
            exit
        end
    end
" &

# Define nixos-rebuild commands
set valid_commands switch boot test build dry-activate build-vm build-vm-with-bootloader dry-build edit

# Specify Rebuild Command
read -P "Enter nixos-rebuild command (default: switch or boot): " rebuild_type

# Sets default rebuild to switch if input is empty
if test -z "$rebuild_type"
    set rebuild_type switch
end

# Get the current user
set current_user (whoami)

# Define directories
set config_dir "/home/$current_user/nix-config"
set nixos_dir /etc/nixos
set backup_dir (mktemp -d)
set log_dir /var/log/nixos-rebuilds

# Create log directory if it doesn't exist
sudo mkdir -p $log_dir

# Generate log filename
set log_file "$log_dir/(date '+%Y-%m-%d') - Nix-rebuild -- (date '+%I:%M:%p').log"

# Function to log messages
function log_message
    echo (date '+%Y-%m-%d %H:%M:%S') - $argv | sudo tee -a $log_file
end

# Start logging
log_message "Starting NixOS rebuild process"

# Check current git branch
cd $config_dir
set current_branch (git rev-parse --abbrev-ref HEAD)
set expected_branch main

if test "$current_branch" != "$expected_branch"
    log_message "Error: Not on the expected branch. Current: $current_branch, Expected: $expected_branch"
    exit 1
end

# Attempt to pull changes
if not git pull origin $expected_branch
    set pull_exit_status $status
    if test $pull_exit_status -eq 1
        log_message "Merge conflicts detected during pull. Manual intervention required."
        git merge --abort
        exit 1
    else
        log_message "Error: Git pull failed with exit status $pull_exit_status"
        exit 1
    end
end

# Backup existing /etc/nixos
sudo cp -r $nixos_dir $backup_dir
log_message "NixOS Configuration backed up to: $backup_dir"

# Remove existing files in /etc/nixos
sudo rm -rf $nixos_dir/

# Copy files from ~/nix-config to /etc/nixos
if not sudo cp -r $config_dir/ $nixos_dir/
    log_message "Copy failed"
    exit 1
else
    log_message "Nix-config copied to /etc/nixos"
end

# Attempt to rebuild the system
if contains $rebuild_type $valid_commands
    if sudo nixos-rebuild $rebuild_type 2>&1 | sudo tee -a $log_file
        log_message "NIXOS REBUILD COMPLETED"

        # Change ownership of the copied files to root
        if not sudo chown -R root: $nixos_dir/
            log_message "Ownership change failed"
            exit 1
        end
        log_message "Changed ownership of $nixos_dir to root."
    else
        log_message "NIXOS REBUILD FAILED. Previous configuration restored."
        sudo rm -rf $nixos_dir
        sudo cp -r $backup_dir/nixos $nixos_dir
    end
else
    log_message "Invalid rebuild type. Valid options are: $valid_commands"
    log_message "Previous configuration restored."
    sudo rm -rf $nixos_dir
    sudo cp -r $backup_dir/nixos $nixos_dir
end

# Clean up the temporary backup
sudo rm -rf $backup_dir

# Rotate logs (keep only the last 50)
set log_count (ls -1 $log_dir | wc -l)
if test $log_count -gt 50
    ls -1t $log_dir | tail -n +51 | xargs -I {} sudo rm $log_dir/{}
    log_message "Old logs rotated, keeping the last 50 logs"
end

log_message "NixOS rebuild process completed"
