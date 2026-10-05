# Development and releases

## Prerequisites

Use a Mac running macOS 13 or later with Xcode or Apple's Command Line Tools and a Swift compiler. No package-manager dependencies are required. Builds target macOS 13.

```sh
git clone https://github.com/Lego-Man53/DropBar.git
cd DropBar
bash scripts/build.sh
open DropBar.app
```

The default build creates a locally signed app for the current Mac's architecture. Quit any running copy before rebuilding or replacing the app.

## Layout

- `Sources/main.swift`: app lifecycle, menu bar setup, floating panel, file picker, AirDrop service.
- `Sources/DropTargetView.swift`: native drop target and status-window delegate forwarding.
- `Sources/DroppedFiles.swift`: file-URL pasteboard decoding.
- `Info.plist`: app metadata, version, minimum OS, and menu bar-only behavior.
- `Tests/main.swift`: checks run within a native application context.
- `scripts/build.sh`: compile and locally sign.
- `scripts/test.sh`: build and launch the test app.
- `scripts/package.sh`: compile both architectures and create a release ZIP and checksum.

## Checks

```sh
bash scripts/test.sh
```

Run from a logged-in Mac desktop session with access to the WindowServer and pasteboard service. A headless or restricted environment may fail even when compilation works. The script uses a temporary app bundle because system sharing services may be unavailable to a standalone command-line process. Tests use a unique pasteboard rather than the user's clipboard and do not send files.

Checks cover multiple file URLs (including spaces), rejection of web links/text/empty drops, the menu symbol, and system AirDrop service availability. They do **not** prove real file delivery or screen-edge drag behavior.

### Manual release checks

- Open one copy; confirm one menu bar item and no Dock icon.
- Drag one file, multiple files, and a filename with spaces from Finder to the floating area.
- Repeat with Desktop files and with a direct drop onto the menu bar item.
- Confirm hover feedback, cancellation, file picker, and right-click menu.
- Select an intended nearby test device, accept on that device, and verify the received contents.
- Test missing/offline devices and cloud-only files.
- Check light/dark appearance, full-screen spaces, menu bar auto-hide, and multiple displays.
- Run on Apple silicon and Intel Macs and supported older macOS versions.
- Download the uploaded ZIP on a clean Mac and verify installation, signature, and checksum.

Record what was actually tested in the release notes. Do not label a release broadly tested when checks are incomplete.

## Universal package

```sh
bash scripts/package.sh
```

This cross-compiles `arm64` and `x86_64`, combines them using `lipo`, ad-hoc signs the app, and writes:

```text
dist/DropBar-<version>-universal.zip
dist/DropBar-<version>-universal.zip.sha256
```

The archive contains the app, `INSTALL.txt`, and the MIT license. Build output is ignored by Git. To build a universal app without packaging:

```sh
bash scripts/build.sh --universal --output "$PWD/.build/Universal/DropBar.app"
```

## Publishing a release

1. Update both version fields in `Info.plist`, `CHANGELOG.md`, download links, and `docs/INSTALL.txt`.
2. Run the automated and available manual checks; document gaps.
3. Run `bash scripts/package.sh` and inspect both binary architectures and the archive contents.
4. Commit the exact source, tag that commit (for example `v0.1.0`), and create a GitHub Release from it.
5. Attach the ZIP and its `.sha256` file. Include installation instructions, signing status, test coverage, and known limitations. Use a prerelease label for preview builds.
6. Download the uploaded asset, compare its SHA-256, and verify the public download links.

Do not commit credentials, signing certificates, provisioning material, personal files, or local build caches.

## Developer ID signing and notarization

Current packages use ad-hoc signing (`codesign --sign -`) and are **not notarized**. They are suitable for a clearly labeled preview, but downloaded copies may be blocked by Gatekeeper. A smoother public installation requires an Apple Developer ID Application certificate and Apple's notarization process.

A future signed release should sign the universal app with hardened runtime and a secure timestamp, submit the distributable using `xcrun notarytool`, staple the accepted ticket to the app, and rebuild the ZIP/checksum before publication. Keep signing credentials outside the repository and use Apple's current documentation. Never claim a release is notarized until Apple's submission succeeds and the shipped artifact is verified.
