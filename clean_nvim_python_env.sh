#!/usr/bin/env bash

echo "Cleaning Neovim Python environment..."

# Define directories
CONFIG_DIR="$HOME/.config/nvim-python-env"
DATA_DIR="$HOME/.local/share/nvim-python-env"
STATE_DIR="$HOME/.local/state/nvim-python-env"
CACHE_DIR="$HOME/.cache/nvim-python-env"

# Remove Neovim-specific files
rm -rf "$CONFIG_DIR" "$DATA_DIR" "$STATE_DIR" "$CACHE_DIR"
echo "Removed Neovim configuration and cache."

# Run Nix garbage collection
echo "Running Nix garbage collection..."
nix-collect-garbage -d
nix-collect-garbage --delete-old
echo "Nix garbage collection completed."

# Clear Home Manager old generations (if used)
if command -v home-manager &> /dev/null; then
    echo "Cleaning up Home Manager..."
    home-manager expire-generations -1
fi

# Clear Nix profile history
echo "Wiping Nix profile history..."
nix profile wipe-history

# Remove Nix cache
echo "Removing Nix cache..."
rm -rf "$HOME/.cache/nix"

# Verify cleanup
echo "Verifying cleanup..."
for dir in "$CONFIG_DIR" "$DATA_DIR" "$STATE_DIR" "$CACHE_DIR"; do
    if [ -d "$dir" ]; then
        echo "Warning: $dir still exists!"
    fi
done


echo "Cleanup completed successfully!"
