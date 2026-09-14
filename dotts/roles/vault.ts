import { dir, file, secret } from 'dotts';

export function vaultRole() {
  const sshDir = dir('~/.ssh', { mode: 0o700 });

  const sshPrivate = file('~/.ssh/id_ed25519', {
    content: secret('ssh_private_key'),
    mode: 0o600,
    dependsOn: [sshDir],
  });

  const sshPublic = file('~/.ssh/id_ed25519.pub', {
    content: secret('ssh_public_key'),
    mode: 0o644,
    dependsOn: [sshDir],
  });

  const sshConfig = file('~/.ssh/config', {
    content: secret('ssh_config'),
    mode: 0o600,
    dependsOn: [sshDir],
  });

  const userGitConfig = file('~/user.gitconfig', {
    content: secret('user_git_config'),
    mode: 0o644,
  });

  const localrc = file('~/.localrc', {
    content: secret('localrc'),
    mode: 0o600,
  });

  const psqlrc = file('~/.psqlrc', {
    content: secret('psqlrc'),
    mode: 0o644,
  });

  return {
    sshDir,
    sshPrivate,
    sshPublic,
    sshConfig,
    userGitConfig,
    localrc,
    psqlrc,
  };
}
