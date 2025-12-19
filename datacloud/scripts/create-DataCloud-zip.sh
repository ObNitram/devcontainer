#!/usr/bin/env bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 <root folder that contains Scala files> <zip archive name>"
    exit 1
fi

SRC_DIR="$1"
ZIP_NAME="$2"

[[ "$ZIP_NAME" != *.zip ]] && ZIP_NAME="${ZIP_NAME}.zip"

SUBMISSION_DIR="${ZIP_NAME%.zip}"

if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Directory $SRC_DIR does not exist"
    exit 1
fi

ORIGINAL_DIR=$(pwd)
ABS_ZIP_PATH="$ORIGINAL_DIR/$ZIP_NAME"
ABS_SUBMISSION_DIR="$ORIGINAL_DIR/$SUBMISSION_DIR"

rm -rf "$ABS_SUBMISSION_DIR" "$ABS_ZIP_PATH"
mkdir -p "$ABS_SUBMISSION_DIR"

cd "$SRC_DIR"

find . -type f -name "*.scala" | while read file; do
    if [[ "$file" != */test/* ]]; then
        rel_path="${file#./}"
        target_dir="$ABS_SUBMISSION_DIR/$(dirname "$rel_path")"
        mkdir -p "$target_dir"
        cp "$file" "$target_dir/"
        echo "Added: $rel_path"
    fi
done

cd "$ORIGINAL_DIR"

zip -r "$ZIP_NAME" "$SUBMISSION_DIR"

rm -rf "$SUBMISSION_DIR"

echo ""
echo "Created: $ZIP_NAME"
ls -lh "$ZIP_NAME"
echo ""
echo "Contents:"
unzip -l "$ZIP_NAME"
