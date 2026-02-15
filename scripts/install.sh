#!/bin/bash
# Install CLAP FX module to Move
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$REPO_ROOT"

if [ ! -d "dist/clap" ]; then
    echo "Error: dist/clap not found. Run ./scripts/build.sh first."
    exit 1
fi

echo "=== Installing CLAP FX Module ==="

# Deploy to Move - audio_fx subdirectory
echo "Copying module to Move..."
ssh ableton@move.local "mkdir -p /data/UserData/move-anything/modules/audio_fx/clap"
scp -r dist/clap/* ableton@move.local:/data/UserData/move-anything/modules/audio_fx/clap/

# Install chain presets if they exist
if [ -d "src/chain_patches" ] && ls src/chain_patches/*.json 1> /dev/null 2>&1; then
    echo "Installing chain presets..."
    ssh ableton@move.local "mkdir -p /data/UserData/move-anything/patches"
    scp src/chain_patches/*.json ableton@move.local:/data/UserData/move-anything/patches/
fi

# Create plugins directory on device
echo "Creating plugins directory..."
ssh ableton@move.local "mkdir -p /data/UserData/move-anything/modules/audio_fx/clap/plugins"

# Set permissions so Module Store can update later
echo "Setting permissions..."
ssh ableton@move.local "chmod -R a+rw /data/UserData/move-anything/modules/audio_fx/clap"

echo ""
echo "=== Install Complete ==="
echo "Module installed to: /data/UserData/move-anything/modules/audio_fx/clap/"
echo ""
echo "Add your .clap plugin files to:"
echo "  /data/UserData/move-anything/modules/audio_fx/clap/plugins/"
echo ""
echo "Restart Move Anything to load the new module."
