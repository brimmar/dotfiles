import { aptRepository, dir, link, pkg, script } from 'dotts';

export function cliToolsRole() {
  const localBin = dir('~/.local/bin');

  // Terminal & Editor
  const alacritty = pkg('alacritty');
  const neovim = pkg('neovim');

  // Bat & symlink batcat -> bat
  const batPkg = pkg('bat');
  const batLink = link('~/.local/bin/bat', '/usr/bin/batcat', {
    dependsOn: [batPkg, localBin],
  });

  // GitHub CLI
  const ghRepo = aptRepository('github-cli', {
    uri: 'https://cli.github.com/packages',
    distribution: 'stable',
    components: ['main'],
    key: 'https://cli.github.com/packages/githubcli-archive-keyring.gpg',
  });
  const ghPkg = pkg('gh', { dependsOn: [ghRepo] });

  // Delta via cargo
  const delta = script('~/.cargo/bin/cargo install git-delta', {
    unless: 'command -v delta >/dev/null 2>&1 || test -f ~/.cargo/bin/delta',
  });

  // Zellij terminal multiplexer
  const zellij = script('~/.cargo/bin/cargo install --locked zellij', {
    unless: 'command -v zellij >/dev/null 2>&1 || test -f ~/.cargo/bin/zellij',
  });

  return { localBin, alacritty, neovim, batPkg, batLink, ghRepo, ghPkg, delta, zellij };
}
