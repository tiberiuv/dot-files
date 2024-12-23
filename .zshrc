if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  . "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# ------------------------------------------------------------ #
# Path
# ------------------------------------------------------------ #
if [[ $(uname -m) == arm64 ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
  export SPARK_HOME="$HOMEBREW_PREFIX/opt/apache-spark/libexec"
  export RUST_ANALYZER_TARGET="aarch64-apple-darwin"
else
  eval $(/usr/local/bin/brew shellenv)
  export SPARK_HOME="$HOMEBREW_PREFIX/Cellar/apache-spark/3.2.0/libexec"
  export RUST_ANALYZER_TARGET="x86_64-apple-darwin"
fi

export PATH=$PYENV_ROOT/bin:$PATH
export PATH=$PATH:$HOME/bin
export PATH=$PATH:/Applications
export PATH=$PATH:$HOMEBREW_PREFIX/texlive/2019/texmf-dist/tex/xelatex
export PATH=$PATH:$JAVA_HOME/bin
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$HOME/Library/Application\ Support/Coursier/bin
export PATH=$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin
export PATH=$HOMEBREW_PREFIX/bin:$PATH
export PATH=$HOMEBREW_PREFIX/sbin:$PATH
export PATH=$HOMEBREW_PREFIX/opt/llvm/bin:$PATH
export PATH=$HOMEBREW_PREFIX/p/versions/python:$PATH
export PATH=$HOMEBREW_PREFIX/opt/openssl@3/bin:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# ------------------------------------------------------------ #
# Env vars
# ------------------------------------------------------------ #
export RUST_HOME="$HOME/.rustup"
export CARGO_HOME="$HOME/.cargo"

export PYENV_ROOT="$HOME/.pyenv"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home
export SCALA_HOME=$HOMEBREW_PREFIX/opt/scala@2.12/idea
export PYSPARK_PYTHON=python3
export GOROOT=$HOMEBREW_PREFIX/opt/go/libexec
export GOPATH=$HOME/go
export SPARK_CLASSPATH=/Users/tiberiusimionvoicu/dev/reporting-backend/utils/dataproc/lib/
export KITTY_CONFIG_DIRECTORY=~/.config/kitty/kitty.conf
export CARGO_NET_GIT_FETCH_WITH_CLI=true
export EDITOR=nvim
export GPG_TTY=$(tty)
# ssh
export SSH_KEY_PATH=~/.ssh/rsa_id
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
export LS_COLORS='ow=36:di=34:fi=32:ex=31:ln=35:'
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
# For minikube
export KUBERNETES_PROVIDER=docker
# ------------------------------------------------------------ #
# Compiler flags
# ------------------------------------------------------------ #
# export LIBRARY_PATH=$LIBRARY_PATH:$HOMEBREW_PREFIX/opt/openssl/lib/
# export LIBRARY_PATH=$LIBRARY_PATH:$HOMEBREW_PREFIX/lib/
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl@3/include"
# ------------------------------------------------------------ #
# Minifort
alias STAGING_CLUSTER=gcloud container clusters get-credentials staging-2 --zone europe-west1-b
# ------------------------------------------------------------ #
# Without the bindkey alt+right/left is broken it tmux
# ------------------------------------------------------------ #
bindkey -e
bindkey "^[[1;9C" forward-word
bindkey "^[[1;9D" backward-word

WORDCHARS="*?[]~=&;!#$%^(){}<>"
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

# ------------------------------ Aliases ------------------------------ #

alias kc="kubectl"
alias kcgc='kubectl config get-contexts'
alias kcuc='kubectl config use-context'
alias ssh="TERM=xterm-256color ssh"
alias update-all=". ~/dot-files/update.zsh"
alias clean_evicted="kubectl get pod | grep Evicted | awk '{print $1}' | xargs kubectl delete pod"

if [[ $(uname) == "Darwin" ]]; then
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

alias vim=nvim
if type exa >/dev/null 2>&1; then
  alias ls=exa
fi
if type bat >/dev/null 2>&1; then
  alias cat=bat
fi
if type procs >/dev/null 2>&1; then
  alias ps=procs
fi

# Forward port 80 and 443 from host to nginx running in kubernetes (minikube)
alias forward_nginx='sudo kubectl port-forward svc/nginx 80:80 443:443'
# ------------------------------------------------------------ #
#
# ------------------------------------------------------------ #
# Zinit install chunk
# ------------------------------------------------------------ #
# if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
#     print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
#     command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
#     command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
#         pushd "$HOME/.zinit/bin" && \
#         git checkout c27bf53f060d4584333ebdff8cfcd6aed60ca430 && \
#         popd && \
#         print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
#         print -P "%F{160}▓▒░ The clone has failed.%f%b"
# fi
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# . "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# ------------------------------------------------------------ #
# PROMPT
# ------------------------------------------------------------ #

zinit depth=1 lucid light-mode nocd for romkatv/powerlevel10k
POWERLEVEL10K_MODE="nerfont-complete"
setopt promptsubst

# eval "$(starship init zsh)"

# ------------------------------------------------------------ #
# PLUGINS
# ------------------------------------------------------------ #
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/z-a-submods \
    zdharma-continuum/declare-zsh

zinit wait"0a" lucid light-mode for \
  atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions

zinit wait lucid light-mode for \
  blockf atpull"zinit creinstall -q ." zsh-users/zsh-completions \
  zdharma-continuum/fast-syntax-highlighting

zinit wait lucid light-mode for zsh-users/zsh-history-substring-search

zinit wait lucid for \
  OMZL::git.zsh \
  atload"unalias grv" OMZP::git

# ------------------------------------------------------------ #
# Programs
# ------------------------------------------------------------ #
# Fzf
zinit ice depth"1" as"program" pick"bin/fzf" \
  atclone"rm -rf bin/fzf && sh install" \
  atpull"%atclone"
zinit light junegunn/fzf

zinit wait lucid light-mode for Aloxaf/fzf-tab

# ------------------------------------------------------------ #

autoload -Uz compinit 
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;

zstyle ":completion:*:match:*" original only
zstyle ":completion:*:git-checkout:*" sort false
zstyle ":completion:*:descriptions" format '[%d]'
zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}
zstyle ":fzf-tab:complete:cd:*" fzf-preview "exa -1 --color=always $realpath"
zstyle ":fzf-tab:*" fzf-command fzf

# In the line editor, number of matches to show before asking permission
LISTMAX=9999

# updates PATH for the Google Cloud SDK.
if [ -f "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; then . "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"; fi

# enables shell command completion for gcloud.
if [ -f "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"; fi

# enable k8s command completion
[[ ${commands[kubectl]} ]] && . <(kubectl completion zsh)

# enable velero command completion
[[ ${commands[velero]} ]] &&  . <(velero completion zsh)

[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || . ~/.p10k.zsh

eval "$(pyenv init -)"

printf "\e[?1042l"
### End of Zinit's installer chunk

# Node version manager
eval "$(fnm env)"

export PATH="/usr/local/p/versions/python:$PATH"

zinit cdreplay -q
