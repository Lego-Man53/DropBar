#!/bin/bash
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEST_APP="$PROJECT_DIR/.build/DropBarTests.app"
mkdir -p "$PROJECT_DIR/.build/module-cache" "$TEST_APP/Contents/MacOS"
xcrun swiftc "$PROJECT_DIR/Sources/DroppedFiles.swift" "$PROJECT_DIR/Tests/main.swift" \
  -framework AppKit -module-cache-path "$PROJECT_DIR/.build/module-cache" \
  -o "$TEST_APP/Contents/MacOS/DropBarTests"
cp "$PROJECT_DIR/Info.plist" "$TEST_APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Set :CFBundleExecutable DropBarTests' "$TEST_APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Set :CFBundleIdentifier local.yusuf.DropBarTests' "$TEST_APP/Contents/Info.plist"
codesign --force --sign - "$TEST_APP"
: > "$PROJECT_DIR/.build/test-results.log"
: > "$PROJECT_DIR/.build/test-errors.log"
open -n -W "$TEST_APP" --stdout "$PROJECT_DIR/.build/test-results.log" --stderr "$PROJECT_DIR/.build/test-errors.log"
cat "$PROJECT_DIR/.build/test-results.log" "$PROJECT_DIR/.build/test-errors.log"
rg -q 'ALL CHECKS PASSED' "$PROJECT_DIR/.build/test-results.log"
