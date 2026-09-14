import { aptRepository, pkg, script } from 'dotts';

export function aiToolsRole() {
  // Antigravity (Google)
  const antigravityRepo = aptRepository('antigravity', {
    uri: 'https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian',
    distribution: 'main',
    components: [],
    key: 'https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg',
  });
  const antigravity = pkg('antigravity', { dependsOn: [antigravityRepo] });

  // OpenAI Codex via Vite+
  const codex = script('~/.vite-plus/bin/vp install -g @openai/codex', {
    unless: 'command -v codex >/dev/null 2>&1 || test -f ~/.vite-plus/bin/codex',
  });

  // Opencode
  const opencode = script('curl -fsSL https://opencode.ai/install | bash', {
    unless: 'command -v opencode >/dev/null 2>&1 || test -f ~/.local/bin/opencode',
  });

  return { antigravityRepo, antigravity, codex, opencode };
}
