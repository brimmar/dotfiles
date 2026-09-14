import { aptRepository, pkg, type ResourceHandle, script } from 'dotts';

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

  const bunDepends = [
    ...(props.curl ? [props.curl] : []),
    ...(props.unzip ? [props.unzip] : []),
  ];

  // Bun runtime
  const bun = script('curl -fsSL https://bun.sh/install | bash', {
    unless: 'test -f ~/.bun/bin/bun',
    dependsOn: bunDepends,
  });

  // Go
  const golang = pkg('golang-go');

  // Python
  const python = pkg('python3');
  const pythonPip = pkg('python3-pip');

  // PHP 8.5 via Ondrej PPA
  const phpRepo = aptRepository('ondrej-php', {
    uri: 'https://ppa.launchpadcontent.net/ondrej/php/ubuntu',
    distribution: 'noble',
    components: ['main'],
    key: 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c',
  });

  const phpPackages = [
    'php8.5-cli',
    'php8.5-common',
    'php8.5-curl',
    'php8.5-mbstring',
    'php8.5-xml',
    'php8.5-zip',
  ].map((name) => pkg(name, { dependsOn: [phpRepo] }));

  return { rustup, bun, golang, python, pythonPip, phpRepo, phpPackages };
}
