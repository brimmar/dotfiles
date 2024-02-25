# Personal Ansible Configuration Repository

Welcome to my personal Ansible configuration repository! This project aims to automate the setup of a new PC according to my preferences, including the installation of software, configuration of settings, and deployment of dotfiles.

## Usage

To use this Ansible configuration, simply run the following command on your target machine with Ansible installed:

```bash
ansible-pull -K -U https://github.com/brimmar/dotfiles.git -e "host_user=<username>" -e "ssh_email=<email>"
```

Note: You don't need to clone the repository locally; ansible-pull will fetch the configuration directly from the remote repository and apply it to your system.

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

At the moment, this Ansible configuration is tailored specifically for Pop!\_OS. However, I plan to extend support to other Linux distributions like Arch Linux and Ubuntu in the near future.

## Important Notes

Early Development: This project is in active development and is considered to be in its early stages. While it's functional, there may be bugs or incomplete features. Use with caution!

Not for Uncontrolled Environments: Please refrain from running this Ansible configuration in uncontrolled or production environments. While I strive to ensure stability and reliability, unforeseen issues may arise. Use at your own risk.
