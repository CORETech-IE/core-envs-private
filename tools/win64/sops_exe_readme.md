# SOPS Binary Placeholder (Windows 64-bit)

This folder is intentionally kept in the repository to indicate the required location for the `sops.exe` binary on Windows.

- Download the binary from [SOPS releases](https://github.com/getsops/sops/releases), rename it to `sops.exe`, and place it here.
- This file prevents Git from ignoring the entire folder.
- The binary itself is ignored via `.gitignore` to avoid committing sensitive or platform-specific executables.
