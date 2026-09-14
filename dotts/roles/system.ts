import { dir, file, link, type ResourceHandle, remoteFile, script, service, unarchive } from 'dotts';

export interface SystemRoleProps {
  unzip?: ResourceHandle;
}

export function systemRole(props: SystemRoleProps = {}) {
  // Ensure chrony allows stepping clock indefinitely after snapshot restores
  file('/etc/chrony/conf.d/snapshot-timesync.conf', {
    content: 'makestep 1 -1\n',
    mode: 0o644,
    become: true,
  });

  // Stop and disable bluetooth service
  const bluetooth = service('bluetooth', {
    state: 'stopped',
    enabled: false,
  });


  // Android ADB Platform Tools
  const localBin = dir('~/.local/bin');
  const androidDir = dir('~/.local/opt/android-tools');
  const adbZip = remoteFile('~/.local/opt/android-tools/platform-tools.zip', {
    url: 'https://dl.google.com/android/repository/platform-tools-latest-linux.zip',
    dependsOn: [androidDir],
  });
  const unarchiveDepends = [adbZip, ...(props.unzip ? [props.unzip] : [])];
  const adbUnarchive = unarchive('platform-tools', {
    src: '~/.local/opt/android-tools/platform-tools.zip',
    dest: '~/.local/opt/android-tools',
    dependsOn: unarchiveDepends,
  });
  const adbLink = link('~/.local/bin/adb', '~/.local/opt/android-tools/platform-tools/adb', {
    dependsOn: [adbUnarchive, localBin],
  });

  return { bluetooth, localBin, androidDir, adbZip, adbUnarchive, adbLink };
}
