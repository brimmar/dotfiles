import { dir, link, remoteFile, script, service, unarchive } from 'dotts';

export function systemRole() {
  // Stop and disable bluetooth service
  const bluetooth = service('bluetooth', {
    state: 'stopped',
    enabled: false,
  });

  // GNOME / Pop screensaver settings (disable lock on idle)
  const screensaver = script(
    'gsettings set org.gnome.desktop.screensaver lock-enabled false && ' +
      'gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false && ' +
      'gsettings set org.gnome.desktop.session idle-delay 0',
    {
      onlyIf: 'command -v gsettings >/dev/null 2>&1',
    },
  );

  // Android ADB Platform Tools
  const androidDir = dir('~/.local/opt/android-tools');
  const adbZip = remoteFile('~/.local/opt/android-tools/platform-tools.zip', {
    url: 'https://dl.google.com/android/repository/platform-tools-latest-linux.zip',
    dependsOn: [androidDir],
  });
  const adbUnarchive = unarchive('platform-tools', {
    src: '~/.local/opt/android-tools/platform-tools.zip',
    dest: '~/.local/opt/android-tools',
    dependsOn: [adbZip],
  });
  const adbLink = link('~/.local/bin/adb', '~/.local/opt/android-tools/platform-tools/adb', {
    dependsOn: [adbUnarchive],
  });

  return { bluetooth, screensaver, androidDir, adbZip, adbUnarchive, adbLink };
}
