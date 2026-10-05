# DropBar

**Drag. Drop. AirDrop.** A lightweight, open-source Mac menu bar app that makes sending files to nearby Apple devices easier.

[Download the preview](https://github.com/Lego-Man53/DropBar/releases/tag/v0.1.0) · [How to use](docs/USAGE.md) · [Installation help](docs/INSTALLATION.md) · [Report a bug](https://github.com/Lego-Man53/DropBar/issues)

## Download and install

1. Open the [v0.1.0 release](https://github.com/Lego-Man53/DropBar/releases/tag/v0.1.0).
2. Under **Assets**, download **DropBar-0.1.0-universal.zip**. The **Source code** downloads are for developers.
3. Double-click the ZIP, then move **DropBar.app** into **Applications**.
4. Open DropBar. Look for the radio-wave icon labeled **Drop** in your menu bar.

**Requires macOS 13 Ventura or later.** The universal download contains both Apple silicon and Intel versions. An AirDrop-compatible Mac and receiving Apple device are required; friends don't need DropBar on the receiving device.

> **Preview release:** DropBar is locally (ad-hoc) signed, not Developer ID signed or notarized by Apple. macOS may block the first launch. Read [first-launch instructions](docs/INSTALLATION.md#first-launch-warning) before deciding whether to open it. Intel and older macOS versions have not yet been tested on hardware.

## Send a file

1. Click **Drop** in the menu bar to show the floating drop area.
2. Drag one or more files from Finder or the Desktop onto **Drop files here**.
3. Choose the receiving device in Apple's AirDrop window. The recipient may need to accept.

You can also drop files directly on **Drop**, or click inside the floating area to choose files manually. If dragging to the top of the screen opens Mission Control, use the floating area below the menu bar.

## Features

- Native Swift and AppKit app with no third-party dependencies.
- Floating drop area that stays visible while you use Finder.
- Multiple-file sharing through Apple's AirDrop chooser.
- Menu bar access with no Dock icon.
- Right-click menu for choosing files, opening Finder's AirDrop, and quitting.
- No account, ads, analytics, or DropBar server.

DropBar hands selected files to macOS. Apple handles device discovery and transfer; you always choose the recipient. DropBar does not change Wi-Fi, Bluetooth, AirDrop discoverability, or login settings.

## Documentation

| Guide | What's inside |
| --- | --- |
| [Install and update](docs/INSTALLATION.md) | Downloads, first launch, updates, login items, uninstalling |
| [Use and troubleshoot](docs/USAGE.md) | Sending files, missing devices, screen-edge behavior, cloud files |
| [Build and release](docs/DEVELOPMENT.md) | Source builds, checks, universal packaging, release checklist |
| [Contribute](CONTRIBUTING.md) | Bug reports, feature ideas, pull requests |
| [Changelog](CHANGELOG.md) | Release history and known limitations |
| [License](LICENSE) | MIT license; free to use, modify, and share |

## Build from source

Install Xcode or Apple's Command Line Tools, then:

```sh
git clone https://github.com/Lego-Man53/DropBar.git
cd DropBar
bash scripts/build.sh
open DropBar.app
```

See [development notes](docs/DEVELOPMENT.md) for testing and release packaging.

## Current status

This is an early preview. Builds, file URL decoding, rejection of non-file drops, menu symbol availability, and AirDrop service availability have been checked on the development Mac. The floating panel and file chooser have been inspected. Actual delivery to another device and behavior across Mac models, full-screen spaces, and multi-monitor setups still need manual testing. Please report what works and what doesn't.

AirDrop and macOS are Apple trademarks. DropBar is an independent project, not affiliated with Apple.
