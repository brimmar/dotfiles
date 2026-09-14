import { aptRepository, group, pkg, service, user } from 'dotts';

export interface DockerRoleProps {
  user?: string;
  distroCodename?: string;
}

export function dockerRole(props: DockerRoleProps = {}) {
  const targetUser = props.user ?? process.env.USER ?? 'brimmar';
  const codename = props.distroCodename ?? 'noble';

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
