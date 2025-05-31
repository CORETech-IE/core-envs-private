Secure Environment Configuration with GPG and SOPS  Internal Engineering / DevOps / IT Security status: Final (Ready for Disaster Recovery)

🔐 Purpose
This documentation outlines the complete strategy for securely managing environment configuration and secrets for the core-services Docker deployments, using SOPS, GPG, and a Git-based repository. It includes all critical steps required to replicate, restore, or recover the system even in the event of total personnel loss.

🧱 Architecture Overview
Components
core-envs-private (Git repo): Holds encrypted secrets and configuration per client.

core-services: Docker container using config.yaml decrypted from secrets.sops.yaml.

SOPS: Handles encryption/decryption using GPG.

GPG: Manages encryption keys.

Deployment Flow
secrets.sops.yaml is decrypted into config.yaml at deployment time.

The decrypted config is mounted inside the container.

validate-repo.sh ensures files are decryptable.

📦 Repository Structure


core-envs-private/
├── .sops.yaml # Encryption rules
├── validate-repo.sh # Validation script
├── templates/ # Template files for new clients
│ ├── config-template.yaml
│ ├── secrets-template.yaml
│ └── metadata-template.yaml
├── tools/ # GPG key backup/restore scripts
│ ├── public-key.asc
│ ├── ownertrust.txt
│ ├── backup-gpg.sh
│ ├── restore-gpg.sh
│ └── win64/ # (gitignored) Local sops.exe for Windows users
├── code-dev/ # Client-specific configuration
│ ├── secrets.sops.yaml
│ ├── config.yaml
│ ├── metadata.yaml
├── docs/
│ └── security_status.md # Active key tracking

Windows Support
Windows users may place a local copy of sops.exe inside the folder:



tools/win64/
This folder is .gitignored and is not tracked by Git.

This approach ensures ease of use in Windows environments without compromising the integrity of the repository

🔑 GPG Key Management
Active Key Info
Fingerprint: C9B7D0EA72899E6D764D97279EE538D3A441F8D0

Created: 2025-05-31

Expires: 2026-05-31

Key Size: RSA 4096

Backup Location (Do NOT lose)
private-key.asc.gpg → Stored in OneDrive (Volaris)

ownertrust.txt → Restores trust level

public-key.asc → Safe to share, stored in Git

🔒 Additional backups on encrypted USB and optionally cloud vault (e.g., S3 + KMS)

Backup Scripts
tools/backup-gpg.sh → Generates backup files

tools/restore-gpg.sh → Restores key + trust on new machine

Rotation Plan
Mandatory yearly rotation or earlier if needed.

Procedure:

Generate new key

Add to .sops.yaml

Re-encrypt all secrets with both keys

Test restore

Remove old key

🔒 .sops.yaml Rules


creation_rules:
  - path_regex: .*\.sops\.yaml$
    encrypted_regex: '^(smtp|oauth2|db)\..*$'
    pgp: 'C9B7D0EA72899E6D764D97279EE538D3A441F8D0'
🔧 Validation


./validate-repo.sh
Decrypts all *.sops.yaml files

Fails if any cannot be decrypted (e.g., expired key or missing access)

🚀 Deployment
Each client decrypts secrets locally into a temporary config, then starts containers:



git clone git@github.com:yourorg/core-envs-private.git && cd core-envs-private/client1
sops -d secrets.sops.yaml > /etc/core-services/config.yaml
cp config.yaml /etc/core-services/
docker-compose up -d
📑 Security Status File
Located at: docs/security_status.md Tracks:

Active key info

Expiration

Rotation schedule

Backup confirmation

Fingerprint explanation

🧯 If Alejandro Prado is Dead™
Clone the repo core-envs-private

Use tools/restore-gpg.sh on any machine with GPG installed

You will need the passphrase for private-key.asc.gpg. If not stored in vault, you’re screwed.

Once imported, you can decrypt all existing *.sops.yaml files.

Review docs/security_status.md to check key validity.

If key is expired or rotation is due, follow the documented rotation plan.

✅ Summary
This system guarantees:

Full recoverability via encrypted GPG key and trust

Transparent traceability via Git + metadata

Enforced structure and validation via .sops.yaml and scripts

No secrets ever committed to Docker images or plaintext Git

👻 Even if the author dies, the system lives on. Just follow the scripts, read the fingerprints, and trust nothing unverified.


Example of use:

Step 1: encrypt the secrets
$ ./tools/win64/sops.exe -e ./core-dev/secrets.sops.yaml > ./core-dev/secrets.tmp.yaml && mv ./core-dev/secrets.tmp.yaml ./core-dev/secrets.sops.yaml

Step 2: validate the encrypted yaml
