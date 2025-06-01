#!/bin/bash

# validate-config-safety.sh
# Ensures that no config.yaml contains sensitive keys

SENSITIVE_KEYS=("client_secret" "refresh_token" "jwt_secret" "internal_jwt_secret" "password" "token")

echo "🔍 Scanning clients/*/config.yaml for sensitive keys..."

found_issues=0

for file in clients/*/config.yaml; do
  for key in "${SENSITIVE_KEYS[@]}"; do
    if grep -qi "$key" "$file"; then
      echo "❌ Sensitive key '$key' found in $file"
      found_issues=1
    fi
  done
done

if [ $found_issues -eq 0 ]; then
  echo "✅ All config.yaml files are clean."
  exit 0
else
  echo "🚨 Please remove sensitive keys from config.yaml."
  exit 1
fi
