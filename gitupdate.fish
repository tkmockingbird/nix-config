#!/usr/bin/env fish

# Exit immediately if any command fails
function on_error --on-event fish_exit
    exit 1
end

# Cache sudo privileges
sudo -v

# Define nixos-rebuild commands
set valid_commands switch boot test build dry-activate build-vm build-vm-with-bootloader dry-build edit

# Function to display usage
function show_usage
    echo "Usage: ./rebuild.fish [command] [options]"
    echo "Valid commands: $valid_commands"
    echo "Options: Any valid nixos-rebuild options"
end

# Parse command-line arguments
set rebuild_type $argv[1]
set -e argv[1]
set additional_options $argv

# If no command is provided, prompt for it
if test -z "$rebuild_type"
    read -P "Enter nixos-rebuild command (default: switch): " rebuild_type
    # Sets default rebuild to switch if input is empty
    if test -z "$rebuild_type"
        set rebuild_type switch
    end
end

# Validate the rebuild type
if not contains $rebuild_type $valid_commands
    echo "Invalid rebuild type: $rebuild_type"
    show_usage
    exit 1
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

# Backup existing /etc/nixos
sudo cp -r $nixos_dir $backup_dir
log_message "NixOS Configuration backed up to: $backup_dir"

# Remove existing files in /etc/nixos
sudo rm -rf $nixos_dir/

# Copy files from ~/nix-config to /etc/nixos
if not sudo cp -r $config_dir/ $nixos_dir/
    log_message "Copy failed"
    exit 1
end

log_message "Nix-config Copied to /etc/nixos"

# Attempt to rebuild the system
if contains $rebuild_type $valid_commands
    if sudo nixos-rebuild $rebuild_type $additional_options 2>&1 | sudo tee -a $log_file
        log_message "NIXOS REBUILD COMPLETED"
        if test -f "/etc/nixos/flake.lock"
            log_message "Updating git's flake.lock"
            sudo cp "/etc/nixos/flake.lock" "/home/$current_user/nix-config/flake.lock"
            sudo chown $current_user:users "/home/$current_user/nix-config/flake.lock"
        else
            log_message "No flake.lock found in /etc/nixos. Skipping flake.lock update."
        end

        # Change ownership of the copied files to root
        if not sudo chown -R root: $nixos_dir/
            log_message "Ownership change failed"
            exit 1
        end
        log_message "Changed ownership of $nixos_dir to root."

        # Skip Git operations if rebuild_type is 'test'
        if test $rebuild_type != test
            # Change to Git directory
            cd $config_dir
            if not test -d ".git"
                log_message "Not a Git repository. Exiting."
                exit 1
            end

            # Git commit and push
            if not git diff-index --quiet HEAD --
                read -P "Enter commit message: " commit_message
                git add .
                git commit -m $commit_message
                git push origin
                log_message "Changes committed and pushed to Git repository"
            else
                log_message "No changes to commit."
            end
        else
            log_message "Rebuild type is 'test'. Skipping Git operations."
        end
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
