#!/bin/bash
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$PROJECT_DIR/Info.plist")"
STAGE_DIR="$PROJECT_DIR/.build/package-$VERSION"
mkdir -p "$STAGE_DIR" "$PROJECT_DIR/dist"
bash "$PROJECT_DIR/scripts/build.sh" --universal --output "$STAGE_DIR/DropBar.app"
cp "$PROJECT_DIR/docs/INSTALL.txt" "$STAGE_DIR/INSTALL.txt"
cp "$PROJECT_DIR/LICENSE" "$STAGE_DIR/LICENSE"
ARCHIVE="DropBar-$VERSION-universal.zip"
COPYFILE_DISABLE=1 ditto -c -k --norsrc --noextattr "$STAGE_DIR" "$PROJECT_DIR/dist/$ARCHIVE"
(cd "$PROJECT_DIR/dist" && shasum -a 256 "$ARCHIVE" > "$ARCHIVE.sha256")
printf 'Packaged %s/dist/%s\n' "$PROJECT_DIR" "$ARCHIVE"
