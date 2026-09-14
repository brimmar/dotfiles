import { type ResourceHandle, script } from 'dotts';

export interface UvRoleProps {
  curl?: ResourceHandle;
}

export function uvRole(props: UvRoleProps = {}) {
  const installUv = script('curl -LsSf https://astral.sh/uv/install.sh | sh', {
    unless: 'command -v uv >/dev/null 2>&1 || test -f ~/.local/bin/uv || test -f ~/.cargo/bin/uv',
    dependsOn: props.curl ? [props.curl] : [],
  });

  const installPython = script(
    'PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH" uv python install',
    {
      unless: 'PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH" uv python find >/dev/null 2>&1',
      dependsOn: [installUv],
    },
  );

  const installPosting = script(
    'PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH" uv tool install posting',
    {
      unless: 'command -v posting >/dev/null 2>&1 || test -f ~/.local/bin/posting',
      dependsOn: [installUv],
    },
  );

  const installYtDlp = script(
    'PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH" uv tool install yt-dlp',
    {
      unless: 'command -v yt-dlp >/dev/null 2>&1 || test -f ~/.local/bin/yt-dlp',
      dependsOn: [installUv],
    },
  );

  return { installUv, installPython, installPosting, installYtDlp };
}
