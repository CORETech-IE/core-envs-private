core-envs-private
=================

This repository contains per-client encrypted configuration for the `core-services` Docker application.
It uses SOPS (https://github.com/mozilla/sops) and GPG (https://gnupg.org) for secure secret management.

-------------------------------------
Repository Structure
-------------------------------------

core-envs-private/
├── .sops.yaml                 # SOPS encryption rules
├── validate-repo.sh           # Script to verify all secrets are decryptable
├── tools/                     # GPG key backup/restore scripts
│   ├── public-key.asc
│   ├── ownertrust.txt
│   ├── backup-gpg.sh
│   └── restore-gpg.sh
├── client01/
│   ├── secrets.sops.yaml      # Encrypted sensitive config
│   ├── config.yaml            # Non-sensitive config
│   └── metadata.yaml          # Template version info
├── docs/
│   └── security_status.md     # GPG fingerprint tracking & policies

-------------------------------------
How to Validate Secrets
-------------------------------------

Use the provided script to validate all encrypted files:

    ./validate-repo.sh

This will decrypt all *.sops.yaml files and exit with an error if any cannot be read
(e.g. wrong key, missing trust, expired).

-------------------------------------
Key Backup & Restore
-------------------------------------

Use the scripts in tools/ to back up or restore your GPG keys:

    # Backup
    ./tools/backup-gpg.sh

    # Restore (on a new machine)
    ./tools/restore-gpg.sh

You must have access to private-key.asc.gpg and know its passphrase.

-------------------------------------
GPG Key Info
-------------------------------------

- Active fingerprint: C9B7D0EA72899E6D764D97279EE538D3A441F8D0
- See docs/security_status.md for expiration, backup status, and rotation policies.

-------------------------------------
Typical Usage (Per Client)
-------------------------------------

    git clone git@github.com:yourorg/core-envs-private.git
    cd core-envs-private/client01
    sops -d secrets.sops.yaml > /etc/core-services/config.yaml
    cp config.yaml /etc/core-services/
    docker-compose up -d

-------------------------------------
If Alejandro Prado is Dead™
-------------------------------------

1. Clone this repo:

       git clone git@github.com:yourorg/core-envs-private.git

2. Restore the GPG key using:

       ./tools/restore-gpg.sh

3. You’ll need the passphrase for private-key.asc.gpg.
   If not stored in vault: good luck.

4. Run validate-repo.sh to ensure you can decrypt secrets.

5. Review docs/security_status.md to check if the key is still valid.

6. If expired: follow the documented rotation plan.

-------------------------------------
Notes
-------------------------------------

- Never commit decrypted files (config.yaml, etc.) or private keys
- Always test decryption before deployment
- Update metadata and documentation after key changes
