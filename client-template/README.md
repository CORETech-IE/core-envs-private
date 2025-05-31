# Client Template

This directory serves as the base for creating new client configuration folders under `core-envs-private`.

## Files Included

- `metadata.yaml`: Template metadata (must follow schema `metadata.schema.json`)
- `config.yaml`: Decrypted runtime config (should be ignored by Git)
- `config.sops.yaml`: Encrypted secrets file, managed via SOPS

## Usage

1. Copy this folder as `client2/` or equivalent.
2. Replace all dummy values.
3. Run `validate-repo.sh` to ensure schema compliance.
4. Encrypt `config.yaml` to `config.sops.yaml` using:
```bash
sops -e config.yaml > config.sops.yaml
```
5. Commit only `metadata.yaml` and `config.sops.yaml`.
6. DO NOT commit `config.yaml`.
