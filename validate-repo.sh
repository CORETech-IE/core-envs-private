#!/bin/bash
set -euo pipefail
echo "[*] Validating encrypted environment files..."
for f in $(find . -name '*.sops.yaml'); do
  echo "Checking $f..."
  sops -d "$f" > /dev/null || {
    echo "❌ Failed to decrypt $f" >&2
    exit 1
  }
done
echo "✅ All secrets validated successfully."
