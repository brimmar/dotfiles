import { pkg, type ResourceHandle } from 'dotts';

const SYSTEM_PACKAGES = [
  'build-essential',
  'libssl-dev',
  'libgtk-3-dev',
  'libgtk-4-dev',
  'libayatana-appindicator3-dev',
  'librsvg2-dev',
  'git-all',
  'btop',
  'pass',
  'kdeconnect',
  'curl',
  'wget',
  'unzip',
  'tar',
  'iproute2',
  'pop-wallpapers',
  'python3-secretstorage',
] as const;

export type SystemPackageName = (typeof SYSTEM_PACKAGES)[number];

export function packagesRole(): Record<SystemPackageName, ResourceHandle> {
  const result = {} as Record<SystemPackageName, ResourceHandle>;
  for (const name of SYSTEM_PACKAGES) {
    result[name] = pkg(name);
  }
  return result;
}
