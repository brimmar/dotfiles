#!/usr/bin/env bash
# zmux-emit.sh: Grok -> zmux bridge for Zellij state sync
# Usage: zmux-emit.sh <state> [message]
# Reads GROK_HOOK_EVENT env or first arg state; emits via zmux if inside Zellij.

set -euo pipefail

STATE="${1:-ready}"
MSG="${2:-$STATE}"

# Resolve Zellij context; fallback gracefully outside Zellij
TAB_ID="${ZELLIJ_TAB_ID:-0}"
PANE_ID="${ZELLIJ_PANE_ID:-0}"

# Try to refresh TAB_ID from zellij if empty / 0 and ZELLIJ is set
if [ -n "${ZELLIJ:-}" ] && { [ -z "$TAB_ID" ] || [ "$TAB_ID" = "0" ]; }; then
    TAB_ID=$(zellij action current-tab-info 2>/dev/null | grep '^id:' | awk '{print $2}' || echo "0")
fi

# Only emit if zmux exists
ZMUX="/home/brimmar/.local/bin/zmux"
if [ ! -x "$ZMUX" ]; then
    exit 0
fi

# Read stdin hook payload (consume to avoid broken pipe, but not used for state decision)
# Use timeout 0.1s to not block if no stdin
INPUT=""
if [ -p /dev/stdin ] || [ ! -t 0 ]; then
    INPUT=$(cat 2>/dev/null || true)
fi

# Optional: extract tool name for working state to make message more descriptive
if [ "$STATE" = "working" ] && [ -n "$INPUT" ]; then
    TOOL=$(echo "$INPUT" | grep -o '"toolName"[[:space:]]*:[[:space:]]*"[^"]*"' 2>/dev/null | head -1 | cut -d'"' -f4 || true)
    if [ -n "$TOOL" ] && [ "$TOOL" != "null" ]; then
        MSG="Tool: $TOOL"
    fi
fi

# Emit; suppress errors when not in Zellij
"$ZMUX" emit "$STATE" grok "$MSG" "$TAB_ID" "$PANE_ID" "$$" 2>/dev/null || true

# For ready states that signal end-of-turn, also ensure sync
if [ "$STATE" = "ready" ] || [ "$STATE" = "needs_input" ]; then
    # On session end, clean up event file is handled by runner's trap; but also handle here
    :
fi

exit 0
