import { git, script } from 'dotts';

export function fontsRole() {
  const repo = git('https://github.com/ryanoasis/nerd-fonts', {
    dest: '~/nerd-fonts',
    depth: 1,
    sparse: ['bin/scripts', 'patched-fonts/Hack'],
  });

  const installHack = script(
    './install.sh install Hack 2>/dev/null || (./install.sh -s Hack 2>/dev/null || ./install.sh -s)',
    {
      workingDir: '~/nerd-fonts',
      unless: 'fc-list | grep -qi "HackNerdFontMono-Regular"',
      dependsOn: [repo],
    },
  );

  return { repo, installHack };
}
