# Personal Ansible Configuration Repository

Welcome to my personal Ansible configuration repository! This project aims to automate the setup of a new PC according to my preferences, including the installation of software, configuration of settings, and deployment of dotfiles.

## Ansible Vault

This setup now uses Ansible Vault to securely manage sensitive information like SSH keys, Git configuration, and environment variables. See `VAULT_SETUP.md` for detailed instructions on setting up and using the vault.

## Usage

To use this Ansible configuration, you have two options:

### Option 1: Using ansible-pull (remote execution)

```bash
# If using a vault password file
ansible-pull -K --vault-password-file ~/.vault_pass -U https://github.com/brimmar/dotfiles.git -e "host_user=<username>"

# Or if you prefer to be prompted for the vault password
ansible-pull -K --ask-vault-pass -U https://github.com/brimmar/dotfiles.git -e "host_user=<username>"
```

### Option 2: Local execution (after cloning)

```bash
# If using a vault password file
ansible-playbook local.yml --vault-password-file ~/.vault_pass --extra-vars "host_user=$(whoami)"

# Or if you prefer to be prompted for the vault password
ansible-playbook local.yml --ask-vault-pass --extra-vars "host_user=$(whoami)"
```

Note: You don't need to clone the repository locally for ansible-pull; it will fetch the configuration directly from the remote repository and apply it to your system.

### Dotfiles

If you are interested on just the dotfiles, you can do this:

```bash
git clone -n --depth=1 --filter=tree:0 https://github.com/brimmar/dotfiles.git
cd dotfiles
git sparse-checkout set --no-cone /dotfiles
git checkout
```

And then stow or symlink it yourself!

## Supported Systems

At the moment, this Ansible configuration is tailored specifically for Pop!\_OS.

## Important Notes

Early Development: This project is in active development and is considered to be in its early stages. While it's functional, there may be bugs or incomplete features. Use with caution!

Not for Uncontrolled Environments: Please refrain from running this Ansible configuration in uncontrolled or production environments. While I strive to ensure stability and reliability, unforeseen issues may arise. Use at your own risk.
