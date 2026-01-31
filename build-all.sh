#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <channel-directory>"
    echo "Example: $0 /home/ubuntu/mochi-conda-channel"
    exit 1
fi

CHANNEL_DIR="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RECIPES_DIR="$SCRIPT_DIR/recipes"

# Create channel directory if it doesn't exist
mkdir -p "$CHANNEL_DIR"

# Build order matters due to dependencies
# Listed in dependency order (dependencies first)
RECIPES=(
    # Base dependencies (no mochi dependencies)
    "nlohmann-json-schema-validator"
    "tclap"
    "sol2"
    "unqlite-c"
    "gdbm"
    "tkrzw"
    "pmdk"
    "argobots"
    "mercury-hpc"
    # Mochi stack (in dependency order)
    "mochi-margo"
    "mochi-thallium"
    "py-mochi-margo"
    "mochi-abt-io"
    "mochi-bedrock-module-api"
    "mochi-flock"
    "mochi-yokan"
    "mochi-warabi"
    "mochi-bedrock"
    "diaspora-stream-api"
    "mofka"
)

echo "Building recipes into channel: $CHANNEL_DIR"
echo "============================================="

for recipe in "${RECIPES[@]}"; do
    recipe_path="$RECIPES_DIR/$recipe"
    if [ -d "$recipe_path" ]; then
        echo ""
        echo "Building: $recipe"
        echo "---------------------------------------------"
        conda build "$recipe_path" \
            --output-folder "$CHANNEL_DIR" \
            -c conda-forge \
            -c "$CHANNEL_DIR" \
            --skip-existing
        # Index after each build so new packages are available as dependencies
        conda index "$CHANNEL_DIR"
    else
        echo "Warning: Recipe not found: $recipe_path"
    fi
done

echo ""
echo "Done! Channel available at: $CHANNEL_DIR"
echo "To use on another machine, copy this folder and add as channel:"
echo "  conda install <package> -c /path/to/channel -c conda-forge"
