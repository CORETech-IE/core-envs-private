#!/bin/bash

# CONFIG: Replace with your actual full fingerprint if different
FINGERPRINT="C9B7D0EA72899E6D764D97279EE538D3A441F8D0"
BACKUP_DIR=~/gpg-backup-core

echo "[*] Starting GPG backup for fingerprint: $FINGERPRINT"
mkdir -p "$BACKUP_DIR" || exit 1

# Export private key
gpg --export-secret-keys --armor "$FINGERPRINT" > "$BACKUP_DIR/private-key.asc"
echo "✅ Private key exported to $BACKUP_DIR/private-key.asc"

# Export public key
gpg --export --armor "$FINGERPRINT" > "$BACKUP_DIR/public-key.asc"
echo "✅ Public key exported to $BACKUP_DIR/public-key.asc"

# Export ownertrust
gpg --export-ownertrust > "$BACKUP_DIR/ownertrust.txt"
echo "✅ Ownertrust exported to $BACKUP_DIR/ownertrust.txt"

# List result
echo ""
echo "[*] Backup completed. Files:"
ls -lh "$BACKUP_DIR"

echo ""
echo "🛡️  IMPORTANT: Copy the contents of $BACKUP_DIR to a secure offline backup location."
