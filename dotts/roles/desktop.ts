import { aptRepository, pkg, script, service } from 'dotts';

export interface DesktopRoleProps {
  user?: string;
}

export function desktopRole(props: DesktopRoleProps = {}) {
  const targetUser = props.user ?? process.env.USER ?? 'brimmar';

  // Brave Browser
  const braveRepo = aptRepository('brave-browser', {
    uri: 'https://brave-browser-apt-release.s3.brave.com/',
    distribution: 'stable',
    components: ['main'],
    key: 'https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg',
  });
  const brave = pkg('brave-browser', { dependsOn: [braveRepo] });

  // VLC media player
  const vlc = pkg('vlc');

  // Syncthing
  const syncthingRepo = aptRepository('syncthing', {
    uri: 'https://apt.syncthing.net/',
    distribution: 'syncthing',
    components: ['stable'],
    key: 'https://syncthing.net/release-key.txt',
  });
  const syncthing = pkg('syncthing', { dependsOn: [syncthingRepo] });
  const syncthingService = service(`syncthing@${targetUser}`, {
    state: 'started',
    enabled: true,
    dependsOn: [syncthing],
  });

  // Obsidian Flatpak
  const obsidian = script('flatpak install -y flathub md.obsidian.Obsidian', {
    unless: 'flatpak list --app 2>/dev/null | grep -q md.obsidian.Obsidian',
  });

  return { braveRepo, brave, vlc, syncthingRepo, syncthing, syncthingService, obsidian };
}
