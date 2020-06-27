# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export GPG_TTY=$(tty)
# Set Path
# ------------------------------------------------------------ #
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/Applications"
export PATH="$PATH:/usr/local/opt/go/libexec/bin"
export PATH="$PATH:/usr/local/texlive/2019/texmf-dist/tex/xelatex"
# ------------------------------------------------------------ #
# Compiler flags
# ------------------------------------------------------------ #
# Env vars
# ------------------------------------------------------------ #
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-13.0.2.jdk/Contents/Home"
export SCALA_HOME="/usr/local/opt/scala/idea"
export SPARK_HOME="/usr/local/Cellar/apache-spark/2.4.4/libexec"
export GOROOT="/usr/local/Cellar/go/1.11.1"
export GOPATH="$HOME/go"
export PYENV_ROOT=$(pyenv root)
#export TERM=xterm-256color

export FZF_BASE="/Users/tiberiusimionvoicu/.config/nvim/plugged/fzf"

export N_PRESERVE_NPM=1
export N_PREFIX=$HOME/.n
export PATH="$PATH:$N_PREFIX/bin"
# ------------------------------------------------------------ #
# Eval
# ------------------------------------------------------------ #
#eval $(thefuck --alias)
eval "$(pyenv init - --no-rehash)"

# ------------------------------------------------------------ #


# Path to your oh-my-zsh installation.
export ZSH="/Users/tiberiusimionvoicu/.oh-my-zsh"

#ZSH_THEME="awesomepanda"

COMPLETION_WAITING_DOTS=true
DISABLE_MAGIC_FUNCTIONS=true
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

plugins=(
  git
  docker
)

source $ZSH/oh-my-zsh.sh

# ------------------------------------------------------------ #
# Work
# ------------------------------------------------------------ #
alias build_server="ssh build@build.passfortdev.com"
export VAULT_ADDR=https://vault.blockops.co
# ------------------------------------------------------------ #
# FZF
# ------------------------------------------------------------ #
export FZF_COMPLETION_TRIGGER='**'
export FZF_DEFAULT_COMMAND='rg --smart-case --files --hidden --follow --no-messages'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

_fzf_compgen_path() {
  rg --smart-case --files --hidden --no-messages ${1}
}

_fzf_compgen_dir() {
  rg --smart-case --files --hidden --no-messages ${1}

}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# ------------------------------------------------------------ #

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tiberiusimionvoicu/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tiberiusimionvoicu/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tiberiusimionvoicu/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tiberiusimionvoicu/google-cloud-sdk/completion.zsh.inc'; fi

# Aliases
# ------------------------------------------------------------ #
alias ssh='TERM=xterm-256color ssh'
if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi
if type exa >/dev/null 2>&1; then
  alias ls=exa
fi
# ------------------------------------------------------------ #
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### Added by Zinit's installer
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

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node


# autosuggestions, trigger precmd hook upon load
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=10

# Tab completions
zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# Syntax highlighting
zinit ice wait lucid atinit'zpcompinit; zpcdreplay'
zinit light zdharma/fast-syntax-highlighting
### End of Zinit's installer chunk
