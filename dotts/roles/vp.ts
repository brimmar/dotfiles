import { type ResourceHandle, script } from 'dotts';

export interface VpRoleProps {
  curl?: ResourceHandle;
}

export function vpRole(props: VpRoleProps = {}) {
  const installVp = script('curl -fsSL https://vite.plus | bash', {
    unless: 'test -f ~/.vite-plus/bin/vp',
    environment: {
      VP_NODE_MANAGER: 'yes',
    },
    dependsOn: props.curl ? [props.curl] : [],
  });

  const installNode = script('~/.vite-plus/bin/vp env install lts', {
    unless: 'test -f ~/.vite-plus/bin/node',
    dependsOn: [installVp],
  });

  return { installVp, installNode };
}
