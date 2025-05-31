#!/bin/bash

# validate-repo.sh
# Validates that all SOPS-encrypted YAML files can be decrypted for a given client
# Usage:
#   ./validate-repo.sh --client=client1

set -e

CLIENT=""
BASE_DIR=$(dirname "$0")

# Parse arguments
for arg in "$@"; do
  case $arg in
    --client=*)
      CLIENT="${arg#*=}"
      shift
      ;;
    *)
      echo "❌ Unknown argument: $arg"
      exit 1
      ;;
  esac
done

# Default to client1 if not provided
if [ -z "$CLIENT" ]; then
  CLIENT="client1"
fi

echo "🔍 Validating secrets for client: $CLIENT"

TARGET_DIR="${BASE_DIR}/${CLIENT}"

if [ ! -d "$TARGET_DIR" ]; then
  echo "❌ Directory not found: $TARGET_DIR"
  exit 1
fi

FILES=$(find "$TARGET_DIR" -type f -name "*.sops.yaml")

if [ -z "$FILES" ]; then
  echo "⚠️ No .sops.yaml files found in $TARGET_DIR"
  exit 0
fi

for file in $FILES; do
  echo "🔐 Checking: $file"
  if sops -d "$file" >/dev/null; then
    echo "✅ OK"
  else
    echo "❌ Failed to decrypt $file"
    exit 1
  fi
done

echo "✅ All secrets for $CLIENT are decryptable."
