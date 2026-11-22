import { pkg, type ResourceHandle, script } from 'braseh';

export interface LanguagesRoleProps {
  curl?: ResourceHandle;
  buildEssential?: ResourceHandle;
  unzip?: ResourceHandle;
}

export function languagesRole(props: LanguagesRoleProps = {}) {
  const rustDepends = [
    ...(props.curl ? [props.curl] : []),
    ...(props.buildEssential ? [props.buildEssential] : []),
  ];

  // Rust toolchain
  const rustup = script("curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y", {
    unless: 'test -f ~/.cargo/bin/rustup',
    dependsOn: rustDepends,
  });

  // Go
  const golang = pkg('golang-go');

  // Python
  const python = pkg('python3');

  // PHP 8.5 from Ubuntu itself: 26.04 ships it, and the Ondrej PPA has no 26.04 builds.
  const phpPackages = [
    'php8.5-cli',
    'php8.5-common',
    'php8.5-curl',
    'php8.5-mbstring',
    'php8.5-xml',
    'php8.5-zip',
  ].map((name) => pkg(name));

  return { rustup, golang, python, phpPackages };
}
