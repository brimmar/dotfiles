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

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

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
    local script_name="google"
    echo ""

    if [[ -z "$LOCAL_GEMINI_API_KEY" ]]; then
        echo "[$script_name] > ERROR: GEMINI_API_KEY environment variable not set." >&2
        return 1
    fi

    if ! command -v jq &> /dev/null; then
        echo "[$script_name] > ERROR: jq is not installed. Please install it to proceed." >&2
        return 1
    fi

    local model="gemini-2.5-flash-lite"
    local query_string=""

    case "$1" in
        --pro)
            model="gemini-2.5-pro"
            shift
            ;;
        --flash)
            model="gemini-2.5-flash"
            shift
            ;;
        *)
            ;;
    esac

    if [[ $# -eq 0 ]]; then
        echo "[$script_name] > ERROR: No query provided." >&2
        echo "Usage: google [--pro | --flash] \"<your query>\"" >&2
        return 1
    fi

    query_string="$@"

    local api_url="https://generativelanguage.googleapis.com/v1beta/models/${model}:streamGenerateContent?key=${LOCAL_GEMINI_API_KEY}&alt=sse"

    local json_payload
    json_payload=$(cat <<EOF
{
  "contents": [{
    "parts": [{
      "text": "You are a world-class AI research assistant designed to simulate high-quality web research and deliver fast, trusted answers like Perplexity AI.

When I ask a question:

• Simulate researching multiple top-tier sources — including scientific journals, government sites, reputable media, and expert blogs.

• Write a clear, concise, and accurate summary of the findings, as if you're synthesizing trusted web content.

• Avoid jargon; aim for clarity and brevity, especially on complex topics.

• Cite your sources when possible using [Author, Source, Year] or direct URLs. If no credible source is available, say “Source unavailable.”

• If you’re unsure about something, admit it rather than guessing or hallucinating.

• Present your output in the following format:

Summary:

A well-structured explanation that gets to the point.

Citations:

• [Source Name, Year]
• [Direct link if appropriate]

Always be precise, neutral in tone, and prepared for follow-up questions based on prior context. Query: ${query_string}"
    }]
  }],
  "tools": [{
    "google_search": {}
  }]
}
EOF
)
    curl --fail --silent --location -N -X POST \
      -H "Content-Type: application/json" \
      -d "${json_payload}" \
      "${api_url}" | \
    while read -r line; do
        if [[ $line == "data: "* ]]; then
            local json_chunk="${line#data: }"
            
            local text_chunk
            text_chunk=$(echo "$json_chunk" | jq -r '.candidates[0].content.parts[0].text // ""')
            printf "%s" "$text_chunk"
        fi
    done

    echo ""
    echo ""
    
    return 0
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

# ADB Android
alias adb='sudo $HOME/Android/Sdk/platform-tools/adb'

# Rust Cargo
. "$HOME/.cargo/env"

# Nvm - Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bash_completion
source ~/.bash_completion/alacritty

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

# go
export PATH=$PATH:/usr/local/go/bin

# flutter
export PATH=$PATH:/usr/bin/flutter/bin

# zellij auto-start
eval "$(zellij setup --generate-auto-start bash)"

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

###-begin-flutter-completion-###

if type complete &>/dev/null; then
  __flutter_completion() {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           flutter completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F __flutter_completion flutter
elif type compdef &>/dev/null; then
  __flutter_completion() {
    si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 flutter completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef __flutter_completion flutter
elif type compctl &>/dev/null; then
  __flutter_completion() {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       flutter completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K __flutter_completion flutter
fi

###-end-flutter-completion-###

## Generated 2024-06-08 14:32:59.443088Z
## By /usr/bin/flutter/bin/cache/flutter_tools.snapshot
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$HOME/zig-linux-x86_64-0.13.0:$PATH"
