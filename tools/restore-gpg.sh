#!/bin/bash

# CONFIG: Path to your backup folder
BACKUP_DIR=~/gpg-backup-core

# Check if files exist
if [[ ! -f "$BACKUP_DIR/private-key.asc" ]] || [[ ! -f "$BACKUP_DIR/ownertrust.txt" ]]; then
  echo "❌ Backup files not found in $BACKUP_DIR"
  echo "Make sure private-key.asc and ownertrust.txt exist."
  exit 1
fi

echo "[*] Importing private key..."
gpg --import "$BACKUP_DIR/private-key.asc" && echo "✅ Private key imported."

echo "[*] Importing ownertrust..."
gpg --import-ownertrust "$BACKUP_DIR/ownertrust.txt" && echo "✅ Ownertrust restored."

echo ""
echo "🔐 GPG environment restored. You can now decrypt SOPS-encrypted files if the passphrase is known."
