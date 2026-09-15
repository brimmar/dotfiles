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

  // Coding agents credentials
  const geminiDir = dir('~/.gemini');
  const agyOAuth = file('~/.gemini/oauth_creds.json', {
    content: secret('agy_oauth_creds'),
    mode: 0o600,
    dependsOn: [geminiDir],
  });

  const agyAccounts = file('~/.gemini/google_accounts.json', {
    content: secret('agy_google_accounts'),
    mode: 0o600,
    dependsOn: [geminiDir],
  });

  const agyInstallationId = file('~/.gemini/installation_id', {
    content: secret('agy_installation_id'),
    mode: 0o600,
    dependsOn: [geminiDir],
  });

  const codexDir = dir('~/.codex');
  const codexAuth = file('~/.codex/auth.json', {
    content: secret('codex_auth'),
    mode: 0o600,
    dependsOn: [codexDir],
  });

  const grokDir = dir('~/.grok');
  const grokAuth = file('~/.grok/auth.json', {
    content: secret('grok_auth'),
    mode: 0o600,
    dependsOn: [grokDir],
  });

  const grokAgentId = file('~/.grok/agent_id', {
    content: secret('grok_agent_id'),
    mode: 0o600,
    dependsOn: [grokDir],
  });

  const grokbotDir = dir('~/.grokbot');
  const grokbotCred = file('~/.grokbot/local-exec-daemon-credential.json', {
    content: secret('grokbot_credential'),
    mode: 0o600,
    dependsOn: [grokbotDir],
  });

  const opencodeDir = dir('~/.local/share/opencode');
  const opencodeAuth = file('~/.local/share/opencode/auth.json', {
    content: secret('opencode_auth'),
    mode: 0o600,
    dependsOn: [opencodeDir],
  });

  return {
    sshDir,
    sshPrivate,
    sshPublic,
    sshConfig,
    userGitConfig,
    localrc,
    psqlrc,
    agyOAuth,
    agyAccounts,
    agyInstallationId,
    codexAuth,
    grokAuth,
    grokAgentId,
    grokbotCred,
    opencodeAuth,
  };
}
