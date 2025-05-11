#!/bin/bash

# Usage: ./copy_modified_files.sh /path/to/search "YYYY-MM-DD" /path/to/target

SOURCE_DIR="$1"
SINCE_DATE="$2"
TARGET_DIR="$3"

if [[ -z "$SOURCE_DIR" || -z "$SINCE_DATE" || -z "$TARGET_DIR" ]]; then
  echo "Usage: $0 <source_dir> <since_date: YYYY-MM-DD> <target_dir>"
  exit 1
fi

# Convert date to the format touch understands (we use a temp file for comparison)
REF_FILE=$(mktemp)
touch -d "$SINCE_DATE" "$REF_FILE"

# Find files modified since that date
cd "$SOURCE_DIR" || exit 1
find . -type f -newer "$REF_FILE" | while read -r file; do
  # Create target directory if it doesn't exist
  LOCAL_FILE="${file#./}"  # Strip leading "./"
  RELATIVE=$(dirname "$file")
  REMOTE_PATH=$RELATIVE
  #mkdir -p "$TARGET_DIR/$RELATIVE"
  # Copy the file
  #cp --preserve=mode,timestamps "$file" "$TARGET_DIR/$file"
  #./upload_if_missing.sh $LOCAL_FILE $REMOTE_PATH
  echo "./upload_if_missing.sh $LOCAL_FILE $REMOTE_PATH"
  
done

rm "$REF_FILE"
echo "Done. Files copied to $TARGET_DIR."

