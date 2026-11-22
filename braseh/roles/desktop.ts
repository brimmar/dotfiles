import { aptRepository, pkg, script, service } from 'braseh';

export interface DesktopRoleProps {
  user?: string;
}

export function desktopRole(props: DesktopRoleProps = {}) {
  const targetUser = props.user ?? process.env.USER ?? 'brimmar';

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

  return { vlc, syncthingRepo, syncthing, syncthingService, obsidian };
}
