import { git, type ResourceHandle, script } from 'dotts';

export interface ZjstatusRoleProps {
  rustup?: ResourceHandle;
}

export function zjstatusRole(props: ZjstatusRoleProps = {}) {
  const repo = git('https://github.com/brimmar/zjstatus.git', {
    dest: '~/zjstatus',
    force: true,
    dependsOn: props.rustup ? [props.rustup] : [],
  });

  const wasmTarget = script(
    '~/.cargo/bin/rustup target add wasm32-wasip1 wasm32-wasi 2>/dev/null || ~/.cargo/bin/rustup target add wasm32-wasip1',
    {
      unless: '~/.cargo/bin/rustup target list --installed | grep -qE "wasm32-wasip1|wasm32-wasi"',
      dependsOn: props.rustup ? [props.rustup] : [],
    },
  );

  const build = script(
    '~/.cargo/bin/cargo build --release --target wasm32-wasip1 2>/dev/null || ~/.cargo/bin/cargo build --release --target wasm32-wasi',
    {
      workingDir: '~/zjstatus',
      unless:
        'test -f ~/zjstatus/target/wasm32-wasip1/release/zjstatus.wasm || test -f ~/zjstatus/target/wasm32-wasi/release/zjstatus.wasm',
      dependsOn: [repo, wasmTarget],
    },
  );

  return { repo, wasmTarget, build };
}
