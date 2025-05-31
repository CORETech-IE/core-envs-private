# Tools

Utility scripts and keys for managing the GPG-based encryption workflow in `core-envs-private`.

## Included

- `backup-gpg.sh`: Export your GPG private/public keys and trust config
- `restore-gpg.sh`: Restore them on a new system
- `public-key.asc`: Safe to share; others can use it to encrypt to you

🚫 **Never store `private-key.asc` here.** Always keep it offline and encrypted.

