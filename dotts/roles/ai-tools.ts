import { aptRepository, pkg, type ResourceHandle, script } from 'dotts';

export interface AiToolsRoleProps {
  vp?: ResourceHandle;
  curl?: ResourceHandle;
}

export function aiToolsRole(props: AiToolsRoleProps = {}) {
  // Antigravity (Google)
  const antigravityRepo = aptRepository('antigravity', {
    uri: 'https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian',
    distribution: 'main',
    components: [],
    key: 'https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg',
  });
  const antigravity = pkg('antigravity', { dependsOn: [antigravityRepo] });

  // OpenAI Codex via Vite+
  const codex = script(
    'PATH="$HOME/.local/share/vite-plus/bin:$HOME/.vite-plus/bin:$PATH" vp install -g @openai/codex',
    {
      unless:
        'command -v codex >/dev/null 2>&1 || test -f ~/.local/share/vite-plus/bin/codex || test -f ~/.vite-plus/bin/codex',
      dependsOn: props.vp ? [props.vp] : [],
    },
  );

  // Opencode
  const opencode = script('curl -fsSL https://opencode.ai/install | bash', {
    unless: 'command -v opencode >/dev/null 2>&1 || test -f ~/.local/bin/opencode',
    dependsOn: props.curl ? [props.curl] : [],
  });

  return { antigravityRepo, antigravity, codex, opencode };
}
