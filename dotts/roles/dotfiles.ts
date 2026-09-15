import { dir, git, link } from 'dotts';

export interface DotfilesRoleProps {
  repoUrl?: string;
  dotfilesPath?: string;
}

export function dotfilesRole(props: DotfilesRoleProps = {}) {
  const repoUrl = props.repoUrl ?? 'https://github.com/brimmar/dotfiles.git';
  const basePath = props.dotfilesPath ?? '~/dotfiles';

  // Clone dotfiles repo if not already cloned
  const repo = git(repoUrl, {
    dest: basePath,
    depth: 1,
    sparse: ['dotfiles', 'dotts', '.dotts'],
    force: true,
  });

  // Clone Oh My Bash
  const ohMyBash = git('https://github.com/ohmybash/oh-my-bash.git', {
    dest: '~/.oh-my-bash',
    depth: 1,
    branch: 'master',
    force: true,
  });

  const configDir = dir('~/.config');
  const localBin = dir('~/.local/bin');
  const geminiDir = dir('~/.gemini');
  const geminiCliDir = dir('~/.gemini/antigravity-cli', { dependsOn: [geminiDir] });
  const codexDir = dir('~/.codex');
  const grokDir = dir('~/.grok');
  const grokbotDir = dir('~/.grokbot');
  const opencodeDir = dir('~/.config/opencode', { dependsOn: [configDir] });

  const binFiles = [
    'timer',
    'zellij-agent-runner',
    'zellij-agent-status',
    'zellij-cpu-status',
    'zellij-disk-status',
    'zellij-memory-status',
    'zellij-timer-status',
    'zmux',
    'zmux-agy-hook',
    'zmux-codex-hook',
    'dotts-vault-decrypt',
  ];

  const binLinks = binFiles.map((name) =>
    link(`~/.local/bin/${name}`, `${basePath}/dotfiles/bin/${name}`, {
      dependsOn: [repo, localBin],
    }),
  );

  const links = [
    link('~/.config/nvim', `${basePath}/dotfiles/nvim/.config/nvim`, {
      dependsOn: [repo, configDir],
    }),
    link('~/.gitconfig', `${basePath}/dotfiles/gitconfig/.gitconfig`, {
      dependsOn: [repo],
    }),
    link('~/.config/alacritty', `${basePath}/dotfiles/alacritty/.config/alacritty`, {
      dependsOn: [repo, configDir],
    }),
    link('~/.bashrc', `${basePath}/dotfiles/oh-my-bash/.bashrc`, {
      dependsOn: [repo, ohMyBash],
    }),
    link('~/.config/zellij', `${basePath}/dotfiles/zellij/.config/zellij`, {
      dependsOn: [repo, configDir],
    }),
    link(
      '~/.oh-my-bash/themes/sexy/sexy.theme.sh',
      `${basePath}/dotfiles/oh-my-bash/.oh-my-bash/themes/sexy/sexy.theme.sh`,
      {
        dependsOn: [repo, ohMyBash],
      },
    ),
    link(
      '~/.oh-my-bash/custom/aliases/ytdl.aliases.sh',
      `${basePath}/dotfiles/oh-my-bash/.oh-my-bash/custom/aliases/ytdl.aliases.sh`,
      {
        dependsOn: [repo, ohMyBash],
      },
    ),
    // Coding agents configuration
    link('~/.gemini/config', `${basePath}/dotfiles/gemini/config`, {
      dependsOn: [repo, geminiDir],
    }),
    link('~/.gemini/settings.json', `${basePath}/dotfiles/gemini/settings.json`, {
      dependsOn: [repo, geminiDir],
    }),
    link(
      '~/.gemini/antigravity-cli/settings.json',
      `${basePath}/dotfiles/gemini/antigravity-cli/settings.json`,
      {
        dependsOn: [repo, geminiCliDir],
      },
    ),
    link(
      '~/.gemini/antigravity-cli/trusted_hooks.json',
      `${basePath}/dotfiles/gemini/antigravity-cli/trusted_hooks.json`,
      {
        dependsOn: [repo, geminiCliDir],
      },
    ),
    link(
      '~/.gemini/antigravity-cli/skills',
      `${basePath}/dotfiles/gemini/antigravity-cli/skills`,
      {
        dependsOn: [repo, geminiCliDir],
      },
    ),
    link(
      '~/.gemini/antigravity-cli/mcp',
      `${basePath}/dotfiles/gemini/antigravity-cli/mcp`,
      {
        dependsOn: [repo, geminiCliDir],
      },
    ),
    link('~/.codex/config.toml', `${basePath}/dotfiles/codex/config.toml`, {
      dependsOn: [repo, codexDir],
    }),
    link('~/.codex/hooks.json', `${basePath}/dotfiles/codex/hooks.json`, {
      dependsOn: [repo, codexDir],
    }),
    link('~/.codex/skills', `${basePath}/dotfiles/codex/skills`, {
      dependsOn: [repo, codexDir],
    }),
    link('~/.codex/prompts', `${basePath}/dotfiles/codex/prompts`, {
      dependsOn: [repo, codexDir],
    }),
    link('~/.grok/config.toml', `${basePath}/dotfiles/grok/config.toml`, {
      dependsOn: [repo, grokDir],
    }),
    link('~/.grok/hooks', `${basePath}/dotfiles/grok/hooks`, {
      dependsOn: [repo, grokDir],
    }),
    link('~/.grok/skills', `${basePath}/dotfiles/grok/skills`, {
      dependsOn: [repo, grokDir],
    }),
    link('~/.grokbot/settings.json', `${basePath}/dotfiles/grokbot/settings.json`, {
      dependsOn: [repo, grokbotDir],
    }),
    link('~/.config/opencode/opencode.json', `${basePath}/dotfiles/opencode/opencode.json`, {
      dependsOn: [repo, opencodeDir],
    }),
    link('~/.config/opencode/commands', `${basePath}/dotfiles/opencode/commands`, {
      dependsOn: [repo, opencodeDir],
    }),
    link('~/.config/opencode/plugins', `${basePath}/dotfiles/opencode/plugins`, {
      dependsOn: [repo, opencodeDir],
    }),
    ...binLinks,
  ];

  return { repo, configDir, localBin, links };
}
