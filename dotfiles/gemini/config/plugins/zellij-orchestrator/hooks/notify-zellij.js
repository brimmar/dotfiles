#!/usr/bin/env node
import { exec } from 'node:child_process';

const state = process.argv[2] || 'working';
const engine = process.argv[3] || 'agy';
const message = process.argv[4] || state;

if (process.env.ZELLIJ) {
  const safeMsg = message.replace(/"/g, '\\"');
  const cmd = `/home/brimmar/.local/bin/zmux emit "${state}" "${engine}" "${safeMsg}"`;
  exec(cmd, () => process.exit(0));
} else {
  process.exit(0);
}
