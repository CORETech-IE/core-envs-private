# 🔐 GPG Key Policy for core-envs-private

**Owner:** Alejandro Prado  
**Last updated:** 2025-05-31

This document outlines the policy for managing GPG keys used in the encryption and decryption of secrets in the `core-envs-private` repository, which is used for secure environment configuration across multiple clients.

---

## 🎯 Objectives

- Ensure secrets remain decryptable across time, machines, and team members
- Minimize risk of key loss or unauthorized decryption
- Standardize backup, sharing, and rotation processes
- Enable smooth onboarding/offboarding of team members

---

## 🗝️ Key Generation

- Keys must be **RSA 4096 bits**
- Keys should be generated using:

  ```bash
  gpg --full-generate-key
