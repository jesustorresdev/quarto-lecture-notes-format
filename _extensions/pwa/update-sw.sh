#!/bin/bash
#
# Script to update the service worker before publishing the website.
#
# Usage: ./update-sw.sh [--dry-run] [directory]
#

SERVICE_WORKER_FILE="sw.js"
BEGIN_SW_MARKER="//-----SERVICE WORKER-----"

[ "$ENABLE_PWA" != true ] && exit 0

error_exit() {
  echo -e "Error: $1" 1>&2
  exit 1
}

# Initialize variables
output_dir=""
dry_run=false

# Parse command line arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)
      dry_run=true
      shift
      ;;
    -*)
      error_exit "Unknown option: $1\nUsage: $0 [--dry-run] [directory]"
      ;;
    *)
      if [ -n "$output_dir" ]; then
        error_exit "Multiple directories specified.\nUsage: $0 [--dry-run] [directory]"
      fi
      output_dir="$1"
      shift
      ;;
  esac
done

if [ -z "$output_dir" ]; then
  error_exit "You must provide a directory as an argument.\nUsage: $0 [--dry-run] [directory]"
fi

if [ ! -d "$output_dir" ]; then
  error_exit "The directory '$output_dir' does not exist."
fi

if [ "$dry_run" = true ]; then
  echo "Running in dry-run mode. No files will be modified."
fi

SW_PATH="$output_dir/$SERVICE_WORKER_FILE"

if [ ! -f "$SW_PATH" ]; then
  error_exit "The file $SERVICE_WORKER_FILE does not exist in the specified directory."
fi

# Get current git commit
GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null)
if [ -z "$GIT_COMMIT" ]; then
  echo "Warning: Could not get git commit. Using 'unknown' as value."
  GIT_COMMIT="unknown"
fi

# Generate list of files and directories (excluding sw.js)
echo "Generating list of files and directories..."

DIRS="'/',
"
FILES=$(find "$output_dir" -type f -not -path "*/\.*"  -printf "'/%P',\n" | grep -v "'/$SERVICE_WORKER_FILE'")
FILES_LIST=$(echo "$DIRS$FILES" | sort)

# Update service worker file
echo "Updating $SERVICE_WORKER_FILE with commit $GIT_COMMIT and file list..."

TEMP_FILE=$(mktemp)

# Save service worker configuration section
cat > "$TEMP_FILE" <<-EOF
const VERSION = '$GIT_COMMIT'
const URLS_TO_CACHE = [
$FILES_LIST
]

$BEGIN_SW_MARKER
EOF

# Save the service worker code
sed "1,\|$BEGIN_SW_MARKER|d" "$SW_PATH"  >> "$TEMP_FILE"

if [ "$dry_run" = true ]; then
  echo "The $SERVICE_WORKER_FILE would be updated to:"
  echo "----------------------------------------"
  cat "$TEMP_FILE"
  echo "----------------------------------------"
else
  # Replace the original file with the updated one
  cat "$TEMP_FILE" > "$SW_PATH"  
  echo "Update completed!"
fi

echo "Commit: $GIT_COMMIT"
echo "Total files and directories included: $(echo "$FILES_LIST" | grep -o "'" | wc -l)"