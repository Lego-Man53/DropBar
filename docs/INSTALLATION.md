# Install, update, and remove DropBar

## Requirements

- An AirDrop-compatible Mac with macOS 13 Ventura or later.
- A nearby receiving Mac, iPhone, or iPad with AirDrop enabled.
- Wi-Fi and Bluetooth enabled on the sending and receiving devices.

The universal ZIP includes `arm64` (Apple silicon) and `x86_64` (Intel). macOS chooses the appropriate code automatically. Intel hardware and older supported macOS versions have not yet been tested. No Xcode or developer tools are needed to run the download.

## Download

1. Visit [DropBar releases](https://github.com/Lego-Man53/DropBar/releases).
2. Open the release you want. The first version is **v0.1.0 — Preview**.
3. Expand **Assets** if necessary and download `DropBar-0.1.0-universal.zip`.
4. Double-click the ZIP in Finder. Inside are `DropBar.app`, `INSTALL.txt`, and `LICENSE`.
5. Drag `DropBar.app` to **Applications**, then open it.

The automatically generated **Source code (zip)** and **Source code (tar.gz)** assets contain source files, not the ready-to-run app.

## First-launch warning

This preview is **ad-hoc signed**. That preserves the app's local code signature, but it does not establish an Apple-verified developer identity. It is **not notarized** by Apple. A downloaded copy may therefore be blocked by macOS.

Only proceed if you trust the project and obtained the download from this repository. After trying to open it, macOS may offer an app-specific **Open Anyway** option under **System Settings → Privacy & Security**. Follow the prompts yourself and review [Apple's guidance for opening apps safely](https://support.apple.com/102445).

Do not disable Gatekeeper globally or run commands to strip quarantine attributes. If macOS reports malware or a revoked signature, stop and report it. If the app appears damaged, try a fresh download and compare the checksum; a managed Mac may require administrator help. You can also review and [build the source](DEVELOPMENT.md).

## Optional: verify the download

Download the matching `.sha256` file beside the ZIP. In Terminal, from the folder containing both files:

```sh
shasum -a 256 -c DropBar-0.1.0-universal.zip.sha256
```

An `OK` result means the ZIP matches the published checksum. This checks file integrity, not Apple notarization or a security audit.

## Start at login

Move the app to Applications first. In **System Settings → General → Login Items** (called **Login Items & Extensions** on some versions), add **DropBar.app** to **Open at Login**. DropBar does not add itself automatically.

## Update

1. Right-click **Drop** in the menu bar and choose **Quit DropBar**.
2. Download and extract the newer release.
3. Replace the old `DropBar.app` in Applications with the new one, then open it.

There is no built-in updater. Check the releases page for updates.

## Uninstall

Quit DropBar, remove it from Login Items if you added it, then move `DropBar.app` from Applications to the Trash. DropBar has no account, background daemon, or custom stored preferences to remove.
