# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

# Path configuration
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Set default editor
export EDITOR='nvim'
export VISUAL='nvim'

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS  # Don't save duplicates
setopt HIST_SAVE_NO_DUPS     # Don't write duplicates
setopt HIST_REDUCE_BLANKS    # Remove unnecessary blanks
setopt INC_APPEND_HISTORY    # Immediately append to history file
setopt EXTENDED_HISTORY      # Record timestamp in history

# =============================================================================
# ZINIT INSTALLATION & CONFIGURATION
# =============================================================================

# Load Zinit if it doesn't exist, install it
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# =============================================================================
# PLUGINS
# =============================================================================

# Essential plugins
zinit light zsh-users/zsh-autosuggestions      # Fish-like autosuggestions
zinit light zsh-users/zsh-completions          # Additional completion definitions

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Ensure completion styling doesn't override our autosuggestion colors
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select=0

# Load fzf for fuzzy finding
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

# fzf-tab for enhanced tab completion with fzf
zinit light Aloxaf/fzf-tab

# zsh-autopair for auto-closing quotes and brackets
zinit light hlissner/zsh-autopair

# Directory navigation
zinit light agkozak/zsh-z

# =============================================================================
# FZF CONFIGURATION
# =============================================================================

# fzf keybindings and completion
zinit snippet OMZP::fzf

# fzf options
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export FZF_DEFAULT_COMMAND="fd --type file --color=always --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type directory --color=always --hidden --follow --exclude .git"

# =============================================================================
# STARSHIP PROMPT
# =============================================================================

# Initialize Starship prompt if installed
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
else
  echo "Starship is not installed. Install it with 'sudo pacman -Syu starship'"
fi

# =============================================================================
# ZSH OPTIONS
# =============================================================================

# Basic auto/tab completion
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{yellow}[%d]%f'
zstyle ':completion:*:messages' format '%F{purple}%d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches for: %d%f'
zstyle ':completion:*:corrections' format '%F{green}%d (errors: %e)%f'
zstyle ':completion:*' group-name ''

# Useful options
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Push the current directory onto the stack
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack
setopt PUSHD_SILENT         # Do not print directory stack
setopt COMPLETE_IN_WORD     # Complete from both ends of a word
setopt ALWAYS_TO_END        # Move cursor to end of word after completion

# =============================================================================
# ALIASES
# =============================================================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# List directories
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glo='git log --oneline --graph --decorate'

# Misc
alias zed='zeditor'
alias zshrc='$EDITOR ~/.zshrc'
alias reload='source ~/.zshrc'

# =============================================================================
# KEY BINDINGS
# =============================================================================

# Set emacs keybindings
bindkey -e

# Use built-in zsh history search with better keybindings
bindkey '^[[A' up-line-or-search                    # Up arrow for history search
bindkey '^[[B' down-line-or-search                  # Down arrow for history search
bindkey '^P' up-line-or-search                      # Ctrl+P for history search
bindkey '^N' down-line-or-search                    # Ctrl+N for history search
bindkey '^R' history-incremental-search-backward    # Ctrl+R for incremental history search

# History search keybindings (built-in alternative)
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey "$terminfo[kcuu1]" up-line-or-search
bindkey "$terminfo[kcud1]" down-line-or-search

# Word navigation with Ctrl+Left/Right
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Alt+Left/Right as fallback for some terminals
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word

# Standard sequences often used by many terminals
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word

# Ctrl+Space to accept suggestion
bindkey '^ ' autosuggest-accept

# More custom configurations (tbd)
# =============================================================================

# Load local configuration if exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Finished all the boring stuff, now show the cool stuff :)
fastfetch
