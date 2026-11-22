# braseh configuration

Declarative TypeScript system configuration for Pop!_OS / Ubuntu using [braseh](https://github.com/brimmar/braseh).

## Project Structure

```text
braseh/
├── braseh.ts             # Entry point orchestrating all roles (../braseh.ts re-exports it)
├── tsconfig.json         # TypeScript configuration with editor types
├── README.md
└── roles/
    ├── packages.ts       # System build tools, libraries, and core utilities
    ├── docker.ts         # Docker CE repository, user permissions, and service
    ├── vp.ts             # Vite+ CLI installer and Node.js LTS runtime
    ├── languages.ts      # Rustup/Rust, Bun, Go, Python, and PHP 8.5 PPA
    ├── cli-tools.ts      # Alacritty, Neovim, Bat, Delta, GitHub CLI, and Zellij
    ├── desktop.ts        # Brave Browser, VLC, Syncthing service, and Obsidian
    ├── ai-tools.ts       # Google Antigravity, OpenAI Codex, and Opencode
    ├── dotfiles.ts       # Git checkout and symlinks for ~/.config and ~/.bashrc
    ├── system.ts         # Screen lock settings, Android ADB tools, and Bluetooth
    └── index.ts          # Barrel export
```

## Usage

Run these from the repository root, where `braseh.ts`, `.braseh/vault` and the state file live.

### Fresh install

1. Install braseh: `curl -fsSL https://raw.githubusercontent.com/brimmar/braseh/main/scripts/install.sh | bash`
2. Copy `~/.braseh_key` (braseh vault) and `~/.vault-pass` (Ansible vault, used for the Brave profile) from the old machine.
3. `git clone https://github.com/brimmar/dotfiles.git ~/dotfiles && cd ~/dotfiles && braseh prepare`

### Validate configuration
```bash
braseh check
```

### Dry run
Preview all changes without executing side effects:
```bash
braseh apply --dry-run
```

### Apply configuration
```bash
braseh apply
```
