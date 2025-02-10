
#!/bin/bash

# Exit Immediately if any command fails
set -e

# Cache sudo credentials & Keep them active
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Define nixos-rebuild commands
valid_commands=("switch" "boot" "test" "build" "dry-activate" "build-vm" "build-vm-with-bootloader" "dry-build" "edit")

# Define directories
config_dir="/home/$(whoami)/nix-config"
nixos_dir="/etc/nixos"
backup_dir=$(mktemp -d)

# Change to the repository directory
cd "$config_dir" && git pull origin

# Specify Rebuild Command
read -p "Enter nixos-rebuild command: " rebuild_type
rebuild_type=${rebuild_type:-switch} # Makes default command switch

# Backup existing /etc/nixos
sudo cp -r "$nixos_dir" "$backup_dir"
echo "NixOS Configuration backed up to: $backup_dir."

# Remove existing files in /etc/nixos
sudo rm -rf "$nixos_dir/"*

# Copy files from ~/nix-config to /etc/nixos
sudo cp -r "$config_dir/"* "$nixos_dir/" || { echo "Copy failed"; exit 1; }
echo "Nix-config Copied to /etc/nixos"

# Attempt to rebuild the system
if [[ " ${valid_commands[@]} " =~ " ${rebuild_type} " ]]; then
    if sudo nixos-rebuild "$rebuild_type" --show-trace; then
        echo "NIXOS REBUILD COMPLETED"

        # Change ownership of the copied files to root
        sudo chown -R root: "$nixos_dir/" || { echo "Ownership change failed"; exit 1; }
        echo "Changed ownership of files in $nixos_dir to root."

    else
        echo "NIXOS REBUILD FAILED. Previous configuration restored."
        sudo rm -rf "$nixos_dir"
        sudo cp -r "$backup_dir/nixos" "$nixos_dir"
    fi
else
    echo "Invalid rebuild type. Valid options are: ${valid_commands[*]}"
    echo "Previous configuration restored."
    sudo rm -rf "$nixos_dir"
    sudo cp -r "$backup_dir/nixos" "$nixos_dir"
fi

# Clean up the temporary backup
sudo rm -rf "$backup_dir"