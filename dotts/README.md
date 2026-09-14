# dotts Configuration

Declarative TypeScript system configuration for Pop!_OS / Ubuntu using [dotts](https://github.com/brimmar/dotTS).

## Project Structure

```text
dotts/
├── dotts.ts              # Entry point orchestrating all roles
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

### Validate Configuration
```bash
dotts check dotts.ts
```

### Dry Run
Preview all changes without executing side effects:
```bash
dotts apply dotts.ts --dry-run
```

### Apply Configuration
```bash
dotts apply dotts.ts
```
