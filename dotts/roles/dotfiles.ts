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
    sparse: ['dotfiles'],
  });

  const configDir = dir('~/.config');
  const ombThemesDir = dir('~/.oh-my-bash/themes/sexy');

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
      dependsOn: [repo],
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
  ];

  return { repo, configDir, links };
}
