import { spawnSync } from 'node:child_process';
import * as fs from 'node:fs';

const tabId = process.env.ZELLIJ_TAB_ID || '0';
const paneId = process.env.ZELLIJ_PANE_ID || '0';

function emit(state, message) {
  const agentDir = '/tmp/zellij_agents';
  try {
    if (!fs.existsSync(agentDir)) fs.mkdirSync(agentDir, { recursive: true });
    const payload = JSON.stringify({
      pane_id: paneId,
      tab_id: tabId,
      engine: 'opencode',
      state: state,
      message: message || state,
      pid: process.pid,
      time: Math.floor(Date.now() / 1000)
    });
    fs.writeFileSync(`${agentDir}/event_pane_${paneId}.json`, payload);
  } catch (e) {}

  if (process.env.ZELLIJ) {
    const safeMsg = (message || state).replace(/"/g, '\\"');
    const args = ['emit', state, 'opencode', safeMsg, tabId, paneId, String(process.pid)];
    try {
      spawnSync('/home/brimmar/.local/bin/zmux', args, {
        stdio: 'ignore'
      });
    } catch (e) {}
  }
}

export const ZellijOrchestratorPlugin = async () => {
  emit('ready', 'Ready');

  return {
    event: async ({ event } = {}) => {
      if (!event) return;
      if (event.type === 'session.created' || event.type === 'session.start') {
        emit('ready', 'Ready');
      } else if (event.type === 'session.idle') {
        emit('ready', 'Ready');
      } else if (event.type === 'session.wait_input') {
        emit('needs_input', 'Awaiting input');
      }
    },

    'chat.message': async () => {
      emit('working', 'Thinking...');
    },

    'tool.execute.before': async (_input, output) => {
      const toolName = (output && output.name) || 'tool';
      if (toolName === 'ask_question' || toolName === 'ask_permission') {
        emit('needs_input', `Awaiting ${toolName}`);
      } else {
        emit('working', `Tool: ${toolName}`);
      }
    },

    'tool.execute.after': async () => {
      emit('working', 'Processing...');
    },

    'session.wait_input': async () => {
      emit('needs_input', 'Awaiting input');
    },

    'session.idle': async () => {
      emit('ready', 'Ready');
    }
  };
};

export default ZellijOrchestratorPlugin;
