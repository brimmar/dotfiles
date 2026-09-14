# Source local, non-versioned configurations
if [ -f ~/.localrc ]; then
    . ~/.localrc
fi
# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# Path to your oh-my-bash installation.
export OSH=$HOME'/.oh-my-bash'

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="sexy"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
  general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: 
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

source "$OSH"/oh-my-bash.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=pt_BR.UTF-8
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# export PATH=/usr/local/cuda-13.0/bin${PATH:+:${PATH}}
# export LD_LIBRARY_PATH=/usr/local/cuda-13.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export PATH=/usr/local/cuda-12.8/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

uv_use() {
  local ver="${1:-3.11}"
  local pybin
  pybin="$(uv python list 2>/dev/null | grep "cpython-${ver}" | head -1 | awk '{print $NF}')"
  if [[ -z "$pybin" || "$pybin" == *"<download available>"* ]]; then
    echo "Installing Python ${ver}..."
    uv python install "$ver"
    pybin="$(uv python list 2>/dev/null | grep "cpython-${ver}" | head -1 | awk '{print $NF}')"
  fi
  export PATH="${pybin%/*}:$PATH"
  echo "Using $(python3 --version) from ${pybin%/*}"
}

zstack() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: zstack <search_term> \"<command_to_run>\""
    echo "Example: zstack api \"nvim .\""
    return 1
  fi

  local search_term="$1"
  local command_to_run="$2"
  local PANE_IDS_FILE="/tmp/zellij_pane_ids_$$"

  touch "$PANE_IDS_FILE"

  find . -mindepth 1 -maxdepth 1 -type d -name "*${search_term}*" -print0 | xargs -0 -I {} \
    zellij action new-pane --cwd {} -- bash -c "echo \$ZELLIJ_PANE_ID >> '$PANE_IDS_FILE' && exec ${command_to_run}"

  sleep 0.2

  local pane_count
  pane_count=$(wc -l < "$PANE_IDS_FILE")
  if [ "$pane_count" -gt 1 ]; then
    zellij action stack-panes -- $(tr '\n' ' ' < "$PANE_IDS_FILE")
  fi

  rm "$PANE_IDS_FILE"
}

delete_branches() {
	deleted_branches=$(git branch -l | awk '/^[*]/{print $2} !/^[*]/{print $1}')

	for branch in $deleted_branches; do
		if ! git rev-parse --verify --quiet --symbolic origin/$branch > /dev/null; then
			git branch -d $branch
		fi
	done
}

_gf() {
	git fetch -p && git switch main && git pull origin main
	if [ "$1" = "-m" ]; then
		return
	fi
	delete_branches
}

google() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: google \"<your question>\"" >&2
        return 1
    fi
    local tmp
    tmp=$(mktemp)
    opencode run --format json --command google "$*" 2>/dev/null | \
      tee "$tmp" | jq -r 'select(.type == "text") | .part.text'
    opencode session delete "$(head -1 "$tmp" | jq -r '.sessionID')" 2>/dev/null
    rm -f "$tmp"
}

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-bash libs,
# plugins, and themes. Aliases can be placed here, though oh-my-bash
# users are encouraged to define aliases within the OSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# Comandos pra configurar o bash
alias bashconfig="v ~/.bashrc"
alias ohmybash="v ~/.oh-my-bash"

# Comandos pro vim
alias v='nvim'
alias sv='sudo -E nvim'

# Comandos pro git
alias gc='git commit -m'
alias ga='git add'
alias gs='git status'
alias gb='git branch'
alias gp='git push origin'
alias gf='_gf'

# Comandos pra ajudar na navegação no cli
alias cl='_cl() { cd "$1"; la; }; _cl'
alias la='exa --header --tree --level=1 --long --no-time --icons --all --group-directories-first --no-time'

# Comandos pra imitar a saída do vim
alias :wq='exit'
alias :q='exit'
alias :qa='exit'

# Comando pra mudar a versão do php localmente
alias php-version='_php-version() { sudo update-alternatives --set php /usr/bin/php"$1"; }; _php-version'

# Comando pro laravel sail
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

alias ytdl='yt-dlp'



# Rust Cargo
. "$HOME/.cargo/env"

# bash_completion
source ~/.bash_completion/alacritty

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

# go
export PATH=$PATH:/usr/local/go/bin



# zellij auto-start
# Optimized for auto-attach: always attach to 'main' or create it.
zellij_auto_start() {
  # Prevent nesting inside existing Zellij, Neovim terminal, or IDE integrated terminals
  if [ -z "$ZELLIJ" ] && [ -z "$NVIM" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
    if [[ $- == *i* ]]; then
      # Attach to 'main' session, or create it if it doesn't exist (-c).
      zellij attach -c main
    fi
  fi
}

# Execute the function to start Zellij on terminal launch
zellij_auto_start

#
# Installation:
#
# Via shell config file  ~/.bashrc  (or ~/.zshrc)
#
#   Append the contents to config file
#   'source' the file in the config file
#
# You may also have a directory on your system that is configured
#    for completion files, such as:
#
#    /usr/local/etc/bash_completion.d/


export PATH="$HOME/zig-linux-x86_64-0.13.0:$PATH"

# opencode
export PATH=/home/brimmar/.opencode/bin:$PATH


# Added by Antigravity CLI installer
export PATH="/home/brimmar/.local/bin:$PATH"

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
[[ -r "$HOME/.grok/completions/bash/grok.bash" ]] && source "$HOME/.grok/completions/bash/grok.bash"
# <<< grok installer <<<

# Vite+ bin (https://viteplus.dev)
if [ -f "$HOME/.config/vite-plus/env" ]; then
    . "$HOME/.config/vite-plus/env"
elif [ -f "$HOME/.vite-plus/env" ]; then
    . "$HOME/.vite-plus/env"
fi

# -------------------------------------------------------------------
# VM management (VirtualBox + CIFS mounts)
# -------------------------------------------------------------------
_VM_CONFIG="$HOME/.vmconfig"
_VM_CIFS_OPTS="username=brimmar,password=password,uid=1000,gid=1000,file_mode=0777,dir_mode=0777"

_vm_load_config() {
  if [[ ! -f "$_VM_CONFIG" ]]; then
    cat > "$_VM_CONFIG" <<-EOF
			# name mount_point share_path
			Demo        $HOME/demo          //192.168.56.105/html
			ProspectChat $HOME/prospectchat //192.168.56.101/html
			Catacliente $HOME/catacliente   //192.168.56.104/html
			LeadSearch  $HOME/leadsearch    //192.168.56.108/html
			EOF
  fi
}

_vm_all() {
  _vm_load_config
  awk '!/^#/ && NF>=3 {print $1}' "$_VM_CONFIG"
}

_vm_info() {
  local vm_name="$1"
  _vm_load_config
  awk -v name="$vm_name" '!/^#/ && $1==name {print $2, $3}' "$_VM_CONFIG"
}

_vm_mount() {
  local vm_name="$1"
  local info
  info="$(_vm_info "$vm_name")"
  local mount_point="${info%% *}"
  local share="${info#* }"
  [[ -z "$mount_point" || -z "$share" ]] && { echo "  $vm_name: not found in config"; return 1; }
  mkdir -p "$mount_point"
  if mountpoint -q "$mount_point" 2>/dev/null; then
    echo "  $vm_name: already mounted at $mount_point, skipping"
    return 0
  fi

  local ip="${share#//}"; ip="${ip%%/*}"
  echo "  $vm_name: waiting for $ip to be reachable..."
  local attempt=0
  until ping -c1 -W1 "$ip" &>/dev/null; do
    sleep 2
    ((attempt++))
    if [[ $attempt -ge 30 ]]; then
      echo "  $vm_name: $ip not reachable after 60s, skipping mount"
      return 1
    fi
  done
  echo "  $vm_name: $ip is up, waiting a moment for services..."
  sleep 3

  echo "  mounting $share -> $mount_point"
  sudo mount -t cifs -o "$_VM_CIFS_OPTS" "$share" "$mount_point"
}

_vm_unmount() {
  local vm_name="$1"
  local info
  info="$(_vm_info "$vm_name")"
  local mount_point="${info%% *}"
  [[ -z "$mount_point" ]] && { echo "  $vm_name: not found in config"; return 1; }
  if mountpoint -q "$mount_point" 2>/dev/null; then
    echo "  unmounting $mount_point..."
    sudo umount "$mount_point"
    rmdir "$mount_point" 2>/dev/null && echo "  removed $mount_point"
  else
    echo "  $vm_name: $mount_point not mounted, skipping"
    rmdir "$mount_point" 2>/dev/null && echo "  removed $mount_point"
  fi
}

_vm_resolve_names() {
  local names=("$@")
  local all=($(_vm_all))
  if [[ ${#names[@]} -eq 0 ]]; then
    printf '%s\n' "${all[@]}"
    return
  fi
  for name in "${names[@]}"; do
    local found=0
    for v in "${all[@]}"; do
      if [[ "${v,,}" == "${name,,}" ]]; then
        echo "$v"
        found=1
        break
      fi
    done
    if [[ $found -eq 0 ]]; then
      echo "  unknown VM: $name" >&2
    fi
  done
}

vm() {
  _vm_load_config
  local cmd="${1:-help}"
  shift 2>/dev/null || true
  local all=($(_vm_all))
  case "$cmd" in
    start|up)
      echo "starting VMs..."
      while IFS= read -r v; do
        [[ -z "$v" ]] && continue
        echo "  $v: starting..."
        VBoxManage startvm "$v" --type headless
        _vm_mount "$v"
      done < <(_vm_resolve_names "$@")
      ;;
    stop|down)
      echo "stopping VMs..."
      local running=()
      while IFS= read -r v; do
        [[ -z "$v" ]] && continue
        _vm_unmount "$v"
        local state
        state=$(VBoxManage showvminfo "$v" --machinereadable 2>/dev/null | grep '^VMState=' | cut -d= -f2 | tr -d '"')
        if [[ "$state" == "running" ]]; then
          echo "  $v: shutting down..."
          running+=("$v")
          VBoxManage controlvm "$v" acpipowerbutton
        else
          echo "  $v: already off, skipping shutdown"
        fi
      done < <(_vm_resolve_names "$@")
      if [[ ${#running[@]} -gt 0 ]]; then
        echo "waiting for VMs to shut down..."
        sleep 10
      fi
      ;;
    mount)
      while IFS= read -r v; do
        [[ -z "$v" ]] && continue
        _vm_mount "$v"
      done < <(_vm_resolve_names "$@")
      ;;
    unmount)
      while IFS= read -r v; do
        [[ -z "$v" ]] && continue
        _vm_unmount "$v"
      done < <(_vm_resolve_names "$@")
      ;;
    status|ps|list)
      for v in "${all[@]}"; do
        local state
        state=$(VBoxManage showvminfo "$v" --machinereadable 2>/dev/null | grep '^VMState=' | cut -d= -f2)
        state="${state:-unknown}"
        local info
        info="$(_vm_info "$v")"
        local mnt="${info%% *}"
        local mnt_status
        mountpoint -q "$mnt" 2>/dev/null && mnt_status="mounted" || mnt_status="unmounted"
        printf "  %-15s %-12s %s\n" "$v" "[$state]" "($mnt_status)"
      done
      ;;
    add)
      local name="$1" mnt="$2" share="$3"
      if [[ -z "$name" || -z "$mnt" || -z "$share" ]]; then
        echo "usage: vm add <name> <mount_point> <share_path>"
        echo "  vm add ParedeViva ~/paredeviva //192.168.56.110/html"
        return 1
      fi
      echo "$name  $mnt  $share" >> "$_VM_CONFIG"
      echo "added $name to $_VM_CONFIG"
      ;;
    remove|rm)
      local name="$1"
      [[ -z "$name" ]] && { echo "usage: vm remove <name>"; return 1; }
      sed -i "/^$name[[:space:]]/d" "$_VM_CONFIG"
      echo "removed $name from $_VM_CONFIG"
      ;;
    edit)
      v "$_VM_CONFIG"
      ;;
    help|*)
      echo "usage: vm <command> [args]"
      echo ""
      echo "commands:"
      echo "  start|up [vm...]   Start VM(s) and mount shares"
      echo "  stop|down [vm...]  Shut down VM(s) and unmount shares"
      echo "  mount [vm...]      Mount shares"
      echo "  unmount [vm...]    Unmount shares"
      echo "  status|ps|list     Show status of all VMs"
      echo "  add <n> <mnt> <s>  Add a VM to the config"
      echo "  remove|rm <name>   Remove a VM from the config"
      echo "  edit               Edit config file with vim"
      echo ""
      echo "available VMs: ${all[*]}"
      echo ""
      echo "examples:"
      echo "  vm start                    Start all VMs"
      echo "  vm start demo               Start Demo only"
      echo "  vm stop                     Stop all + unmount"
      echo "  vm add ParedeViva ~/pv //host/pv  Add new VM"
      echo "  vm edit                     Edit ~/.vmconfig"
      ;;
  esac
}

_vm_complete() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"
  local all=($(_vm_all))
  local cmd=""
  local i
  for ((i=1; i<COMP_CWORD; i++)); do
    local w="${COMP_WORDS[i]}"
    if [[ "$w" =~ ^(start|up|stop|down|mount|unmount|remove|rm)$ ]]; then
      cmd="$w"
    fi
  done
  if [[ "$prev" == "vm" ]]; then
    mapfile -t COMPREPLY < <(compgen -W "start stop mount unmount status list ps add remove rm edit help ${all[*]}" -- "$cur")
  elif [[ "$prev" == "add" ]]; then
    :
  elif [[ "$cmd" == "remove" || "$cmd" == "rm" || "$cmd" == "start" || "$cmd" == "up" || "$cmd" == "stop" || "$cmd" == "down" || "$cmd" == "mount" || "$cmd" == "unmount" ]]; then
    mapfile -t COMPREPLY < <(compgen -W "${all[*]}" -- "$cur")
  fi
}
complete -F _vm_complete vm

# zmux: AI Agent Zellij Shell Integration (Instant tab and status updates)
if [ -n "$ZELLIJ" ]; then
    if [ -z "$ZELLIJ_TAB_ID" ]; then
        export ZELLIJ_TAB_ID=$(zellij action current-tab-info 2>/dev/null | grep '^id:' | awk '{print $2}')
    fi

    _zmux_prompt_hook() {
        if [ -n "$ZELLIJ_PANE_ID" ] && [ "$_ZMUX_AGENT_ACTIVE" == "1" ]; then
            _ZMUX_AGENT_ACTIVE=0
            rm -f "/tmp/zellij_agents/event_pane_${ZELLIJ_PANE_ID}.json"
            zmux sync-tab "${ZELLIJ_TAB_ID:-0}" 2>/dev/null || true
            echo "zjstatus::pipe::agent_status::" | zellij action pipe 2>/dev/null || true
        fi
    }
    PROMPT_COMMAND="_zmux_prompt_hook; ${PROMPT_COMMAND:-}"

    agy() {
        local tab_id="${ZELLIJ_TAB_ID:-$(zellij action current-tab-info 2>/dev/null | grep '^id:' | awk '{print $2}')}"
        local pane_id="${ZELLIJ_PANE_ID:-0}"
        export ZELLIJ_TAB_ID="$tab_id"
        export _ZMUX_AGENT_ACTIVE=1
        export _ZMUX_AGENT_ENGINE="agy"
        zmux emit ready agy "Ready" "$tab_id" "$pane_id" "$$" 2>/dev/null || true
        command agy "$@"
        local code=$?
        export _ZMUX_AGENT_ACTIVE=0
        rm -f "/tmp/zellij_agents/event_pane_${pane_id}.json"
        zmux sync-tab "$tab_id" 2>/dev/null || true
        echo "zjstatus::pipe::agent_status::" | zellij action pipe 2>/dev/null || true
        return $code
    }

    opencode() {
        local tab_id="${ZELLIJ_TAB_ID:-$(zellij action current-tab-info 2>/dev/null | grep '^id:' | awk '{print $2}')}"
        local pane_id="${ZELLIJ_PANE_ID:-0}"
        export ZELLIJ_TAB_ID="$tab_id"
        export _ZMUX_AGENT_ACTIVE=1
        export _ZMUX_AGENT_ENGINE="opencode"
        zmux emit ready opencode "Ready" "$tab_id" "$pane_id" "$$" 2>/dev/null || true
        command opencode "$@"
        local code=$?
        export _ZMUX_AGENT_ACTIVE=0
        rm -f "/tmp/zellij_agents/event_pane_${pane_id}.json"
        zmux sync-tab "$tab_id" 2>/dev/null || true
        echo "zjstatus::pipe::agent_status::" | zellij action pipe 2>/dev/null || true
        return $code
    }

    codex() {
        local tab_id="${ZELLIJ_TAB_ID:-$(zellij action current-tab-info 2>/dev/null | grep '^id:' | awk '{print $2}')}"
        local pane_id="${ZELLIJ_PANE_ID:-0}"
        export ZELLIJ_TAB_ID="$tab_id"
        export _ZMUX_AGENT_ACTIVE=1
        export _ZMUX_AGENT_ENGINE="codex"
        zmux emit ready codex "Ready" "$tab_id" "$pane_id" "$$" 2>/dev/null || true
        command codex "$@"
        local code=$?
        export _ZMUX_AGENT_ACTIVE=0
        rm -f "/tmp/zellij_agents/event_pane_${pane_id}.json"
        zmux sync-tab "$tab_id" 2>/dev/null || true
        echo "zjstatus::pipe::agent_status::" | zellij action pipe 2>/dev/null || true
        return $code
    }

    grok() {
        local tab_id="${ZELLIJ_TAB_ID:-$(zellij action current-tab-info 2>/dev/null | grep '^id:' | awk '{print $2}')}"
        local pane_id="${ZELLIJ_PANE_ID:-0}"
        export ZELLIJ_TAB_ID="$tab_id"
        export _ZMUX_AGENT_ACTIVE=1
        export _ZMUX_AGENT_ENGINE="grok"
        zmux emit ready grok "Ready" "$tab_id" "$pane_id" "$$" 2>/dev/null || true
        command grok "$@"
        local code=$?
        export _ZMUX_AGENT_ACTIVE=0
        rm -f "/tmp/zellij_agents/event_pane_${pane_id}.json"
        zmux sync-tab "$tab_id" 2>/dev/null || true
        echo "zjstatus::pipe::agent_status::" | zellij action pipe 2>/dev/null || true
        return $code
    }
fi

# Qwen Code PATH block begin
export PATH='/home/brimmar/.local/bin':$PATH
# Qwen Code PATH block end
