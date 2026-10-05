# Contributing to DropBar

Bug reports, documentation fixes, and small focused improvements are welcome.

## Report an issue

Search [existing issues](https://github.com/Lego-Man53/DropBar/issues) first. Include the DropBar version, macOS version, Apple silicon or Intel, where the file came from, steps to reproduce, and expected versus actual behavior. Mention whether Finder's own AirDrop works. Do not upload private files or credentials.

## Propose a change

Open an issue for a substantial change before implementing it. Keep the app focused on quick file sharing through Apple's AirDrop interface. Prefer native platform APIs and avoid new dependencies unless they provide a clear benefit.

## Submit a pull request

1. Fork the repository and create a branch.
2. Make a focused change and update affected documentation.
3. Follow the build and test instructions in [DEVELOPMENT.md](docs/DEVELOPMENT.md).
4. Describe the user-visible behavior, checks completed, and any remaining limitations.
5. Open a pull request against `main`.

Changes to drag handling require a manual Finder drag check; pasteboard unit checks alone cannot verify the system's drag routing. Changes involving transfer should be checked with an intended test recipient. Do not send other people's files without permission.

By contributing, you agree that your contribution is provided under the project's MIT license. Be respectful and constructive in issues and reviews.
