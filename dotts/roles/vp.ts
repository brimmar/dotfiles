import { type ResourceHandle, script } from 'dotts';

export interface VpRoleProps {
  curl?: ResourceHandle;
}

export function vpRole(props: VpRoleProps = {}) {
  const installVp = script('curl -fsSL https://vite.plus | bash', {
    unless: 'command -v vp >/dev/null 2>&1 || test -f ~/.local/share/vite-plus/bin/vp || test -f ~/.vite-plus/bin/vp',
    environment: {
      VP_NODE_MANAGER: 'yes',
    },
    dependsOn: props.curl ? [props.curl] : [],
  });

  const installNode = script(
    'PATH="$HOME/.local/share/vite-plus/bin:$HOME/.vite-plus/bin:$PATH" vp env install lts',
    {
      unless: 'command -v node >/dev/null 2>&1 || test -f ~/.local/share/vite-plus/bin/node || test -f ~/.vite-plus/bin/node',
      dependsOn: [installVp],
    },
  );

  return { installVp, installNode };
}
