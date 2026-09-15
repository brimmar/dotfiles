import { aptRepository, pkg, type ResourceHandle, script } from 'dotts';

export interface BraveRoleProps {
  dotfiles?: ResourceHandle;
}

export function braveRole(props: BraveRoleProps = {}) {
  const braveRepo = aptRepository('brave-browser', {
    uri: 'https://brave-browser-apt-release.s3.brave.com/',
    distribution: 'stable',
    components: ['main'],
    key: 'https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg',
  });

  const bravePkg = pkg('brave-browser', { dependsOn: [braveRepo] });

  const restoreProfile = script(
    'cat ~/dotfiles/dotfiles/brave/brave-profile.tar.xz.part-* | python3 ~/dotfiles/dotfiles/bin/dotts-vault-decrypt - | tar -xJ -C ~',
    {
      unless: 'test -f ~/.config/BraveSoftware/Brave-Browser/Default/Preferences',
      dependsOn: props.dotfiles ? [props.dotfiles, bravePkg] : [bravePkg],
    },
  );

  return { braveRepo, bravePkg, restoreProfile };
}
