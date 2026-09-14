import { pkg } from 'dotts';

const SYSTEM_PACKAGES = [
  'build-essential',
  'libssl-dev',
  'libgtk-3-dev',
  'libgtk-4-dev',
  'libayatana-appindicator3-dev',
  'librsvg2-dev',
  'git-all',
  'btop',
  'eza',
  'pass',
  'kdeconnect',
  'curl',
  'wget',
  'unzip',
  'tar',
  'iproute2',
] as const;

export function packagesRole() {
  return SYSTEM_PACKAGES.map((name) => pkg(name));
}
