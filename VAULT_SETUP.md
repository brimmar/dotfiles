# Ansible Vault Setup Guide

This document explains how to use Ansible Vault to securely manage sensitive information in this Ansible setup.

## What is Ansible Vault?

Ansible Vault is a feature that allows you to keep sensitive data such as passwords, SSH keys, API tokens, and other secrets in encrypted files, rather than as plaintext.

## Files

- `group_vars/all/vault.yml` - Contains all sensitive/encrypted variables
- `group_vars/all/vars.yml` - Contains public variables that reference vault values

## Current Sensitive Variables Stored

The vault currently manages:

1. SSH Keys (private and public)
2. Git configuration (email, name, signing key)
3. Environment variables (like API tokens)

## Setting up the Vault

### 1. Create a vault password file (optional but recommended)

```bash
# Create a file to store your vault password
echo "your_vault_password" > ~/.vault_pass
chmod 600 ~/.vault_pass
```

### 2. Put your actual sensitive data in the vault

Before encrypting, you need to add your actual sensitive data to `group_vars/all/vault.yml`:

1. Replace the placeholder SSH private key with your actual private key content
2. Replace the placeholder SSH public key with your actual public key
3. Update the git configuration with your actual email, name, and signing key
4. Add any environment variables you want to manage

### 3. Encrypt the vault file

```bash
# Using a password file (recommended)
ansible-vault encrypt --vault-password-file ~/.vault_pass group_vars/all/vault.yml

# Or you'll be prompted for a password
ansible-vault encrypt group_vars/all/vault.yml
```

## Using the Vault

### Running Playbooks with Vault

```bash
# Using password file
ansible-playbook local.yml --vault-password-file ~/.vault_pass --extra-vars "host_user=$(whoami)"

# Or you'll be prompted for vault password and host_user
ansible-playbook local.yml --ask-vault-pass --extra-vars "host_user=$(whoami)"
```

### Editing the Vault

```bash
# Using password file
ansible-vault edit --vault-password-file ~/.vault_pass group_vars/all/vault.yml

# Or you'll be prompted for password
ansible-vault edit group_vars/all/vault.yml
```

### Viewing the Vault

```bash
# Using password file
ansible-vault view --vault-password-file ~/.vault_pass group_vars/all/vault.yml

# Or you'll be prompted for password
ansible-vault view group_vars/all/vault.yml
```

## Rekeying the Vault (changing password)

```bash
ansible-vault rekey group_vars/all/vault.yml
```

## How It Works

1. The `ssh` role now deploys your pre-existing SSH key from the vault instead of generating a new one
2. The `git_config` role creates a `user.gitconfig` file with your personal information from the vault
3. The `env_vars` role creates a `.localrc` file with your environment variables and ensures it's sourced

## Security Best Practices

1. Never commit unencrypted vault files to version control
2. Use strong passwords for vault encryption
3. Store your vault password securely (not in plain text on the same system)
4. Regularly rotate sensitive information in the vault
5. Use different vault passwords for different environments if needed

## Troubleshooting

- If you get "vault password required" errors, make sure you're providing the vault password
- Ensure your vault password file has correct permissions (600)
- Make sure all placeholder values in `vault.yml` are replaced with actual values before encrypting

## Updating the repository

Once you have your vault properly set up with your sensitive data and encrypted, you can safely commit and push your changes to git:

```bash
git add .
git commit -m "Add vault configuration for sensitive data"
git push
```

The vault file will remain encrypted in the repository, protecting your sensitive information.