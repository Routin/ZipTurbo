#!/bin/bash

# Default number of parallel threads, it is recommended to set it to twice the number of CPU cores or adjust based on actual requirements
NUM_PROC=$(nproc)
USE_RAM=false  # By default, do not use RAM disk

# Display help information
show_help() {
    echo "Usage: $0 [--num_proc N] [--use_ram] yourfile.zip"
    echo ""
    echo "Options:"
    echo "  --num_proc N    Specify the number of parallel processing threads (default is the number of CPU cores)"
    echo "  --use_ram       Use RAM disk to accelerate extraction"
}

# Cleanup function: handle cleanup operations when the script is terminated
cleanup() {
    if [ "$USE_RAM" = true ]; then
        echo "Detected interrupt signal, cleaning up RAM disk..."
        rm -rf "$RAM_DISK"
        echo "Cleanup complete. Script terminated."
    fi
    exit 1
}

# Catch Ctrl+C signal (SIGINT) and call the cleanup function
trap cleanup SIGINT

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --num_proc)
            NUM_PROC="$2"
            shift 2
            ;;
        --use_ram)
            USE_RAM=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            ZIP_FILE="$1"
            shift
            ;;
    esac
done

# Check if a ZIP file argument was provided
if [ -z "$ZIP_FILE" ]; then
  echo "Error: No ZIP file specified."
  show_help
  exit 1
fi

# Check if the specified ZIP file exists
if [ ! -f "$ZIP_FILE" ]; then
  echo "File $ZIP_FILE does not exist!"
  exit 1
fi

echo "Starting to process file: $ZIP_FILE"

# If using RAM disk, accelerate operations
if [ "$USE_RAM" = true ]; then
    RAM_DISK="/dev/shm/zip_unzip"
    mkdir -p "$RAM_DISK"
    echo "Copying file to RAM disk..."
    cp "$ZIP_FILE" "$RAM_DISK/"
    echo "File copied to RAM disk."
    ZIP_FILE="$RAM_DISK/$(basename "$ZIP_FILE")"
else
    echo "Not using RAM disk, extracting directly from disk."
fi

# Extract to the current directory if no folder is specified
OUTPUT_DIR="."
echo "Preparing directory structure..."
# Extract all directories from the ZIP file and create them in advance to avoid directory creation conflicts during parallel extraction
unzip -Z1 "$ZIP_FILE" | grep '/$' | while read DIR; do
  mkdir -p "$OUTPUT_DIR/$DIR"
done
echo "Directory structure prepared."

# Get the total number of files to display extraction progress
TOTAL_FILES=$(unzip -Z1 "$ZIP_FILE" | wc -l)
echo "Total number of files: $TOTAL_FILES"

# Use unzip -Z1 to list the contents of the ZIP file and use parallel to extract each file in parallel to the output directory
echo "Starting parallel extraction of files..."
unzip -Z1 "$ZIP_FILE" | parallel -j "$NUM_PROC" --bar unzip -qq -o "$ZIP_FILE" -d "$OUTPUT_DIR" {}

echo "Extraction complete! All files have been extracted to the current directory."

# Clean up RAM disk
if [ "$USE_RAM" = true ]; then
    echo "Cleaning up RAM disk..."
    rm -rf "$RAM_DISK"
    echo "RAM disk cleaned up."
fi
