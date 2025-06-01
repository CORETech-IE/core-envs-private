#!/bin/bash

# validate-repo.sh
# Validates that all SOPS-encrypted YAML files can be decrypted for a given client
# Usage:
#   ./validate-repo.sh --client=core-dev

set -e

CLIENT=""
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="${BASE_DIR}"
SOPS_CMD="sops"

# Detect platform
UNAME_OUT="$(uname -s)"
case "${UNAME_OUT}" in
    MINGW*|CYGWIN*|MSYS*)
        SOPS_CMD="${REPO_ROOT}/tools/win64/sops.exe"
        ;;
esac

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

# Default to core-dev if not provided
if [ -z "$CLIENT" ]; then
  CLIENT="core-dev"
fi

echo "🔍 Validating secrets for client: $CLIENT"

TARGET_DIR="${REPO_ROOT}/clients/${CLIENT}"

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
  if "$SOPS_CMD" -d "$file" >/dev/null; then
    echo "✅ OK"
  else
    echo "❌ Failed to decrypt $file"
    exit 1
  fi
done

echo "✅ All secrets for $CLIENT are decryptable."
