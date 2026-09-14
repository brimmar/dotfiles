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
  });

  const configDir = dir('~/.config');
  const localBin = dir('~/.local/bin');
  const ombThemesDir = dir('~/.oh-my-bash/themes/sexy', {
    dependsOn: [ohMyBash],
  });

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
        dependsOn: [repo, ombThemesDir],
      },
    ),
    ...binLinks,
  ];

  return { repo, configDir, localBin, links };
}
