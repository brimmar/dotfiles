import { aptRepository, dir, link, pkg, type ResourceHandle, script } from 'dotts';

export interface CliToolsRoleProps {
  rustup?: ResourceHandle;
  buildEssential?: ResourceHandle;
  libsslDev?: ResourceHandle;
}

export function cliToolsRole(props: CliToolsRoleProps = {}) {
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

  const cargoDepends = [
    ...(props.rustup ? [props.rustup] : []),
    ...(props.buildEssential ? [props.buildEssential] : []),
    ...(props.libsslDev ? [props.libsslDev] : []),
  ];

  // Delta via cargo
  const delta = script('~/.cargo/bin/cargo install git-delta', {
    unless: 'command -v delta >/dev/null 2>&1 || test -f ~/.cargo/bin/delta',
    dependsOn: cargoDepends,
  });

  // Zellij terminal multiplexer
  const zellij = script('~/.cargo/bin/cargo install --locked zellij', {
    unless: 'command -v zellij >/dev/null 2>&1 || test -f ~/.cargo/bin/zellij',
    dependsOn: cargoDepends,
  });

  return { localBin, alacritty, neovim, batPkg, batLink, ghRepo, ghPkg, delta, zellij };
}
