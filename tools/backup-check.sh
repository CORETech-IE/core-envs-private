#!/bin/bash
# tools/backup-check.sh

set -e

BACKUP_DIR="tools"
KEY_FILE="$BACKUP_DIR/private-key.asc.gpg"
TRUST_FILE="$BACKUP_DIR/ownertrust.txt"

echo "🔐 Verifying GPG backup integrity..."

# Check presence
[ -f "$KEY_FILE" ] || { echo "❌ Missing private-key.asc.gpg"; exit 1; }
[ -f "$TRUST_FILE" ] || { echo "❌ Missing ownertrust.txt"; exit 1; }

# Test decryption without importing
gpg --dry-run --decrypt "$KEY_FILE" > /dev/null 2>&1 \
  && echo "✅ GPG backup decryptable" \
  || { echo "❌ GPG backup could not be decrypted"; exit 1; }

echo "📦 All backup files are present and usable."
