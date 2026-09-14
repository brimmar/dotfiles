import { dir, git, lineInFile, pkg, type ResourceHandle, script } from 'dotts';

export interface AlacrittyRoleProps {
  rustup?: ResourceHandle;
  buildEssential?: ResourceHandle;
}

export function alacrittyRole(props: AlacrittyRoleProps = {}) {
  // Dependencies required to compile Alacritty from source
  const cmake = pkg('cmake');
  const pkgConfig = pkg('pkg-config');
  const freetype = pkg('libfreetype6-dev');
  const fontconfig = pkg('libfontconfig1-dev');
  const xcbXfixes = pkg('libxcb-xfixes0-dev');
  const xkbcommon = pkg('libxkbcommon-dev');
  const desktopUtils = pkg('desktop-file-utils');

  const deps = [
    cmake,
    pkgConfig,
    freetype,
    fontconfig,
    xcbXfixes,
    xkbcommon,
    desktopUtils,
    ...(props.buildEssential ? [props.buildEssential] : []),
    ...(props.rustup ? [props.rustup] : []),
  ];

  // Download Alacritty repository
  const repo = git('https://github.com/alacritty/alacritty.git', {
    dest: '~/alacritty',
    force: true,
    dependsOn: deps,
  });

  // Build release binary
  const build = script('~/.cargo/bin/cargo build --release', {
    workingDir: '~/alacritty',
    unless: 'test -x /usr/local/bin/alacritty && /usr/local/bin/alacritty --version | grep -qE "0.15|0.16"',
    dependsOn: [repo],
  });

  // Install terminfo
  const terminfo = script('tic -xe alacritty,alacritty-direct extra/alacritty.info', {
    workingDir: '~/alacritty',
    unless: 'infocmp alacritty >/dev/null 2>&1',
    dependsOn: [repo],
  });

  // Install binary to /usr/local/bin
  const installBin = script('install -m 755 target/release/alacritty /usr/local/bin/alacritty', {
    workingDir: '~/alacritty',
    become: true,
    unless: 'test -f /usr/local/bin/alacritty && cmp -s target/release/alacritty /usr/local/bin/alacritty',
    dependsOn: [build],
  });

  // Desktop integration (icon, .desktop file, desktop database)
  const desktop = script(
    'install -m 644 extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg && desktop-file-install extra/linux/Alacritty.desktop && update-desktop-database',
    {
      workingDir: '~/alacritty',
      become: true,
      unless: 'test -f /usr/share/pixmaps/Alacritty.svg && test -f /usr/share/applications/Alacritty.desktop',
      dependsOn: [repo, desktopUtils],
    },
  );

  // Man pages
  const man = script(
    'mkdir -p /usr/local/share/man/man1 && gzip -c extra/alacritty.man > /usr/local/share/man/man1/alacritty.1.gz && gzip -c extra/alacritty-msg.man > /usr/local/share/man/man1/alacritty-msg.1.gz',
    {
      workingDir: '~/alacritty',
      become: true,
      unless: 'test -f /usr/local/share/man/man1/alacritty.1.gz',
      dependsOn: [repo],
    },
  );

  // Bash completion
  const completionDir = dir('~/.bash_completion');
  const completion = script('cp extra/completions/alacritty.bash ~/.bash_completion/alacritty', {
    workingDir: '~/alacritty',
    unless: 'test -f ~/.bash_completion/alacritty',
    dependsOn: [repo, completionDir],
  });
  const bashrc = lineInFile('~/.bashrc', 'source ~/.bash_completion/alacritty', {
    dependsOn: [completion],
  });

  return {
    cmake,
    pkgConfig,
    freetype,
    fontconfig,
    xcbXfixes,
    xkbcommon,
    desktopUtils,
    repo,
    build,
    terminfo,
    installBin,
    desktop,
    man,
    completionDir,
    completion,
    bashrc,
  };
}
