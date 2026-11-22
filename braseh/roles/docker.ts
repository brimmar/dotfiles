import { readFileSync } from 'node:fs';
import { aptRepository, group, pkg, service, user } from 'braseh';

/** Ubuntu codename of this machine (resolute on Pop!_OS 26.04), so Docker's repo matches the release. */
function ubuntuCodename(): string {
  const osRelease = readFileSync('/etc/os-release', 'utf8');
  const value =
    osRelease.match(/^UBUNTU_CODENAME=(.*)$/m)?.[1] ?? osRelease.match(/^VERSION_CODENAME=(.*)$/m)?.[1];
  return value?.replace(/^"|"$/g, '') ?? 'noble';
}

export interface DockerRoleProps {
  user?: string;
  distroCodename?: string;
}

export function dockerRole(props: DockerRoleProps = {}) {
  const targetUser = props.user ?? process.env.USER ?? 'brimmar';
  const codename = props.distroCodename ?? ubuntuCodename();

  const repo = aptRepository('docker', {
    uri: 'https://download.docker.com/linux/ubuntu',
    distribution: codename,
    components: ['stable'],
    key: 'https://download.docker.com/linux/ubuntu/gpg',
  });

  const dockerPkg = pkg('docker-ce', { dependsOn: [repo] });
  const dockerGroup = group('docker');

  const dockerUser = user(targetUser, {
    groups: ['docker'],
    dependsOn: [dockerGroup],
  });

  const dockerService = service('docker', {
    state: 'started',
    enabled: true,
    dependsOn: [dockerPkg],
  });

  return { repo, dockerPkg, dockerGroup, dockerUser, dockerService };
}
