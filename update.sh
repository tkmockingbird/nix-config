
#!/bin/bash

# Exit Immediately if any command fails
set -e

# Cache sudo credentials & Keep them active
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Define nixos-rebuild commands
valid_commands=("switch" "boot" "test" "build" "dry-activate" "build-vm" "build-vm-with-bootloader" "dry-build" "edit")

# Specify Rebuild Command
read -p "Enter nixos-rebuild command: " rebuild_type

# Sets default rebuild to switch
rebuild_type=${rebuild_type:-switch}

# Get the current user
current_user=$(whoami)

# Define directories
config_dir="/home/$current_user/nix-config"
nixos_dir="/etc/nixos"
backup_dir=$(mktemp -d)
log_dir="/var/log/nixos-rebuilds"

# Create log directory if it doesn't exist
sudo mkdir -p "$log_dir"

# Generate log filename
log_file="$log_dir/$(date '+%Y-%m-%d') - Nix-rebuild -- $(date '+%I:%M:%p').log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a "$log_file"
}

# Start logging
log_message "Starting NixOS rebuild process"

# Backup existing /etc/nixos
sudo cp -r "$nixos_dir" "$backup_dir"
log_message "NixOS Configuration backed up to: $backup_dir"

# Remove existing files in /etc/nixos
sudo rm -rf "$nixos_dir/"*

# Copy files from ~/nix-config to /etc/nixos
sudo cp -r "$config_dir/"* "$nixos_dir/" || { log_message "Copy failed"; exit 1; }
log_message "Nix-config Copied to /etc/nixos"

# Attempt to rebuild the system
if [[ " ${valid_commands[@]} " =~ " ${rebuild_type} " ]]; then
    if sudo nixos-rebuild "$rebuild_type" 2>&1 | sudo tee -a "$log_file"; then
        log_message "NIXOS REBUILD COMPLETED"
        if [ -f "/etc/nixos/flake.lock" ]; then
            log_message "Updating git's flake.lock"
            sudo cp "/etc/nixos/flake.lock" "/home/$current_user/nix-config/flake.lock"
            sudo chown $current_user:users "/home/$current_user/nix-config/flake.lock"
        else
            log_message "No flake.lock found in /etc/nixos. Skipping flake.lock update."
        fi

        # Change ownership of the copied files to root
        sudo chown -R root: "$nixos_dir/" || { log_message "Ownership change failed"; exit 1; }
        log_message "Changed ownership of files in $nixos_dir to root."

        # Skip Git operations if rebuild_type is 'test'
        if [ "$rebuild_type" != "test" ]; then
            # Change to Git directory
            cd "$config_dir"

            if [ ! -d ".git" ]; then
                log_message "Not a Git repository. Exiting."
                exit 1
            fi

            # Git commit and push
            if ! git diff-index --quiet HEAD --; then
                read -p "Enter commit message: " commit_message
                git add .
                git commit -m "$commit_message"
                git push origin
                log_message "Changes committed and pushed to Git repository"
            else
                log_message "No changes to commit."
            fi
        else
            log_message "Rebuild type is 'test'. Skipping Git operations."
        fi
    else
        log_message "NIXOS REBUILD FAILED. Previous configuration restored."
        sudo rm -rf "$nixos_dir"
        sudo cp -r "$backup_dir/nixos" "$nixos_dir"
    fi
else
    log_message "Invalid rebuild type. Valid options are: ${valid_commands[*]}"
    log_message "Previous configuration restored."
    sudo rm -rf "$nixos_dir"
    sudo cp -r "$backup_dir/nixos" "$nixos_dir"
fi

# Clean up the temporary backup
sudo rm -rf "$backup_dir"

# Rotate logs (keep only the last 50)
log_count=$(ls -1 "$log_dir" | wc -l)
if [ "$log_count" -gt 50 ]; then
    ls -1t "$log_dir" | tail -n +51 | xargs -I {} sudo rm "$log_dir/{}"
    log_message "Old logs rotated, keeping the last 50 logs"
fi

log_message "NixOS rebuild process completed"