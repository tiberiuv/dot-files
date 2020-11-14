if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------------------------------------ #
export GPG_TTY=$(tty)
# Set Path
# ------------------------------------------------------------ #
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/Applications"
export PATH="$PATH:/usr/local/opt/go/libexec/bin"
export PATH="$PATH:/usr/local/texlive/2019/texmf-dist/tex/xelatex"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
# ------------------------------------------------------------ #
# Compiler flags
# ------------------------------------------------------------ #
# Env vars
# ------------------------------------------------------------ #
export LANG="en_US.UTF-8"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-13.0.2.jdk/Contents/Home"
export SCALA_HOME="/usr/local/opt/scala/idea"
export SPARK_HOME="/usr/local/Cellar/apache-spark/3.0.1/libexec"
export PYSPARK_PYTHON=python3
export GOROOT="/usr/local/Cellar/go/1.11.1"
export GOPATH="$HOME/go"
export PYENV_ROOT=$(pyenv root)
export FZF_BASE="/Users/tiberiusimionvoicu/.config/nvim/plugged/fzf"
export N_PRESERVE_NPM=1
export N_PREFIX=$HOME/.n
export PATH="$PATH:$N_PREFIX/bin"
# ------------------------------------------------------------ #
# Without the bindkey alt+right/left is broken it tmux
# ------------------------------------------------------------ #
bindkey -e
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

WORDCHARS='*?[]~=&;!#$%^(){}<>'
# ------------------------------------------------------------ #
COMPLETION_WAITING_DOTS=true
DISABLE_MAGIC_FUNCTIONS=true
# ------------------------------------------------------------ #
# FZF
# ------------------------------------------------------------ #
export FZF_DEFAULT_COMMAND='rg --smart-case --files --hidden --follow --no-messages --glob "!{node_modules,.git,*.lock,target,dist}"'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

_fzf_compgen_path() {
  rg --smart-case --files --hidden --no-messages --glob "!{node_modules,.git,*.lock,target,dist}" ${1}
}

_fzf_compgen_dir() {
  rg --smart-case --files --hidden --no-messages --glob "!{node_modules,.git,*.lock,target,dist}" ${1}
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ------------------------------------------------------------ #

setopt AUTO_CD              # Change directory without cd
setopt AUTO_PUSHD           # Make cd push each old directory onto the stack
setopt no_beep
unsetopt LIST_BEEP          # Don't beep on an ambiguous completion
setopt auto_menu            # Automatically use menu completion
setopt auto_list            # Automatically List Choices On Ambiguous Completion.
setopt always_to_end        # Vove cursor to end if word had one match
setopt complete_in_word     # Complete From Both Ends Of A Word.

HISTFILE=${HOME}/.zsh_history
HISTSIZE=120000             # Larger than $SAVEHIST for HIST_EXPIRE_DUPS_FIRST to work
SAVEHIST=100000

setopt EXTENDED_HISTORY         # Save time stamps and durations
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicates first
setopt HIST_IGNORE_DUPS         # Do not enter 2 consecutive duplicates into history
setopt HIST_IGNORE_SPACE        # Ignore command lines with leading spaces
setopt HIST_VERIFY              # Reload results of history expansion before executing
setopt INC_APPEND_HISTORY       # Constantly update $HISTFILE
setopt SHARE_HISTORY            # Constantly share history between shell instances
setopt path_dirs                # Perform Path Search Even On Command Names With Slashes.
setopt auto_param_slash         # If Completed Parameter Is A Directory, Add A Trailing Slash.

export EDITOR='nvim'

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Aliases
# ------------------------------------------------------------ #
alias ssh='TERM=xterm-256color ssh'
if type nvim > /dev/null 2>&1; then
  alias vim=nvim
fi
if type exa >/dev/null 2>&1; then
  alias ls=exa
fi
if type bat >/dev/null 2>&1; then
  alias cat=bat
fi
if type procs >/dev/null 2>&1; then
  alias ps=procs
fi
if type htop >/dev/null 2>&1; then
  alias top=htop
fi

# ------------------------------------------------------------ #
#
# ------------------------------------------------------------ #
# Zinit install chunk
# ------------------------------------------------------------ #
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ------------------------------------------------------------ #
# THEME
# ------------------------------------------------------------ #
zinit ice depth=1; zinit light romkatv/powerlevel10k
POWERLEVEL10K_MODE="nerfont-complete"
setopt promptsubst
# ------------------------------------------------------------ #
# PLUGINS
# ------------------------------------------------------------ #
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-bin-gem-node \
    zinit-zsh/z-a-submods \
    zdharma/declare-zsh

zinit wait"0a" lucid light-mode for \
  atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

#zicompinit; zicdreplay

zinit light-mode for Aloxaf/fzf-tab

zinit wait lucid light-mode for \
  blockf atpull'zinit creinstall -q .' zsh-users/zsh-completions \
  zdharma/fast-syntax-highlighting

zinit wait lucid light-mode for zsh-users/zsh-history-substring-search

zinit wait lucid for \
  OMZL::git.zsh \
  atload"unalias grv" OMZP::git


#zstyle ':completion:*' menu select # select completions with arrow keys
#zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-command fzf
#zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
#zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0

# In the line editor, number of matches to show before asking permission
LISTMAX=9999

# Setup GitHub HTTPS credentials.
if git credential-osxkeychain 2>&1 | grep $Q "git.credential-osxkeychain" > /dev/null
then
  if [ "$(git config --global credential.helper)" != "osxkeychain" ]
  then
    git config --global credential.helper osxkeychain
  fi

  if [ -n "$STRAP_GITHUB_USER" ] && [ -n "$STRAP_GITHUB_TOKEN" ]
  then
    printf "protocol=https\\nhost=github.com\\n" | git credential-osxkeychain erase
    printf "protocol=https\\nhost=github.com\\nusername=%s\\npassword=%s\\n" \
          "$STRAP_GITHUB_USER" "$STRAP_GITHUB_TOKEN" \
          | git credential-osxkeychain store
  fi
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tiberiusimionvoicu/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tiberiusimionvoicu/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tiberiusimionvoicu/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tiberiusimionvoicu/google-cloud-sdk/completion.zsh.inc'; fi


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

printf "\e[?1042l"
