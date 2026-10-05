#!/bin/bash
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_DIR="$PROJECT_DIR/DropBar.app"
BUILD_UNIVERSAL=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --universal) BUILD_UNIVERSAL=true; shift ;;
    --output) APP_DIR="$2"; shift 2 ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; exit 1 ;;
  esac
done
mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources" "$PROJECT_DIR/.build/module-cache"
compile_arch() {
  local build_arch="$1"
  xcrun swiftc "$PROJECT_DIR"/Sources/*.swift \
    -o "$PROJECT_DIR/.build/DropBar-$build_arch" \
    -framework AppKit -O -target "$build_arch-apple-macosx13.0" \
    -module-cache-path "$PROJECT_DIR/.build/module-cache"
}
if [[ "$BUILD_UNIVERSAL" == true ]]; then
  compile_arch arm64
  compile_arch x86_64
  xcrun lipo -create "$PROJECT_DIR/.build/DropBar-arm64" "$PROJECT_DIR/.build/DropBar-x86_64" \
    -output "$APP_DIR/Contents/MacOS/DropBar"
else
  compile_arch "$(uname -m)"
  cp "$PROJECT_DIR/.build/DropBar-$(uname -m)" "$APP_DIR/Contents/MacOS/DropBar"
fi
cp "$PROJECT_DIR/Info.plist" "$APP_DIR/Contents/Info.plist"
cp "$PROJECT_DIR/LICENSE" "$APP_DIR/Contents/Resources/LICENSE"
codesign --force --sign - "$APP_DIR"
codesign --verify --deep --strict "$APP_DIR"
printf 'Built %s\n' "$APP_DIR"
