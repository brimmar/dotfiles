import { script } from 'dotts';

export function vpRole() {
  const installVp = script('curl -fsSL https://vite.plus | bash', {
    unless: 'test -f ~/.vite-plus/bin/vp',
    environment: {
      VP_NODE_MANAGER: 'yes',
    },
  });

  const installNode = script('~/.vite-plus/bin/vp env install lts', {
    unless: 'test -f ~/.vite-plus/bin/node',
    dependsOn: [installVp],
  });

  return { installVp, installNode };
}
