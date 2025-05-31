# 🔐 Security Status — core-envs-private

This file tracks the current GPG key(s) used for encrypting client secrets via SOPS.  
All entries must be kept up to date as keys are created, rotated, or revoked.

---

## ✅ Active GPG Key

- **Fingerprint:** C9B7D0EA72899E6D764D97279EE538D3A441F8D0
- **Created on:** 2025-05-31
- **Expires on:** 2026-05-31
- **Key size:** RSA 4096 bits
- **Comment:** infra-core-services
- **Public key file:** `tools/public-key.asc`
- **Ownertrust file:** `tools/ownertrust.txt`
- **Maintainer:** Alejandro Prado

---

## 🔄 Rotation Plan

- Next rotation deadline: **before 2026-05-15**
- Rotation procedure:
  - Generate new key with expiration
  - Add new fingerprint to `.sops.yaml`
  - Re-encrypt all secrets with both keys
  - Distribute new public key if needed
  - Confirm restore works
  - Remove old key from `.sops.yaml`
- Key rotation is mandatory every 12 months or earlier if team changes occur

---

## 🔐 Backup Confirmation

| Item                    | Status | Notes                        |
|-------------------------|--------|------------------------------|
| Encrypted private key   | ✅     | `private-key.asc.gpg` exists |
| Public key              | ✅     | Safe to share                |
| Ownertrust              | ✅     | Restores trust level         |
| Recovery tested         | ☐      | Recommended yearly           |

---

## 📦 Backup Locations (Do not include real paths)

- OneDrive (company-managed, encrypted)
- Encrypted USB (off-site physical storage)
- [Optional] Secure vault (e.g., Bitwarden or S3+KMS)

---

## 🛑 DO NOT

- Commit unencrypted private keys to this repository
- Use personal or non-rotated keys for encryption
- Forget to update this file after key changes

---

## 📎 Appendix: What is a GPG Fingerprint?

A GPG fingerprint is a unique hash that identifies a specific GPG key. It is derived from the key material itself and is safe to publish.

### Why it's used

- To uniquely identify a key when encrypting
- To verify a public key's authenticity
- To track active and rotated keys in documentation and policies

### Why it's safe to include here

- A fingerprint does **not** expose your private key
- It does **not** reveal your passphrase
- It cannot be used to decrypt anything
- It is meant to be **shared publicly**

Publishing fingerprints is standard practice in secure systems and infrastructure environments. It helps ensure others are encrypting to the correct key.
