if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------------------------------------ #
# Env vars
# ------------------------------------------------------------ #
# Minifort
export KUBERNETES_PROVIDER=docker
alias STAGING_CLUSTER=gcloud container clusters get-credentials staging-2 --zone europe-west1-b
# ------------------------------------------------------------ #
if [[ $(uname -m) == arm64 ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
  export HOMEBREW_HOME="/opt/homebrew/opt"
  export SPARK_HOME="$HOMEBREW_HOME/apache-spark/libexec"
  export RUST_ANALYZER_TARGET="aarch64-apple-darwin"
else
  eval $(/usr/local/bin/brew shellenv)
  export HOMEBREW_HOME="/usr/local/Cellar"
  export SPARK_HOME="$HOMEBREW_HOME/apache-spark/3.1.2/libexec"
  export RUST_ANALYZER_TARGET="x86_64-apple-darwin"
fi

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home
export SCALA_HOME=/usr/local/opt/scala@2.12/idea
export PYSPARK_PYTHON=python3
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/go
export FZF_BASE=~/.fzf
export N_PRESERVE_NPM=1
export N_PREFIX=$HOME/.n
export PATH=$PATH:$N_PREFIX/bin
export SPARK_CLASSPATH=/Users/tiberiusimionvoicu/dev/reporting-backend/utils/dataproc/lib/
export KITTY_CONFIG_DIRECTORY=~/.config/kitty/kitty.conf
export CARGO_NET_GIT_FETCH_WITH_CLI=true
export EDITOR=nvim
export GPG_TTY=$(tty)
# ssh
export SSH_KEY_PATH=~/.ssh/rsa_id
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
# Set Path
# ------------------------------------------------------------ #
# default PATH
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin
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
export PATH="/usr/local/p/versions/python:$PATH"
# ------------------------------------------------------------ #
# Compiler flags
# ------------------------------------------------------------ #
# export LIBRARY_PATH=$LIBRARY_PATH:$HOMEBREW_PREFIX/opt/openssl/lib/
# export LIBRARY_PATH=$LIBRARY_PATH:$HOMEBREW_PREFIX/lib/
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

# ------------------------------ Aliases ------------------------------ #
# alias ssh="TERM=xterm-256color ssh"
alias update-all="source ~/icloud/dot-files/update.zsh"

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
# Forward port 80 and 443 from host to nginx running in kubernetes (minikube)
alias forward_nginx='sudo kubectl port-forward svc/nginx 80:80 443:443'
# ------------------------------------------------------------ #
#
# ------------------------------------------------------------ #
# Zinit install chunk
# ------------------------------------------------------------ #
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        pushd "$HOME/.zinit/bin" && \
        git checkout c27bf53f060d4584333ebdff8cfcd6aed60ca430 && \
        popd && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# ------------------------------------------------------------ #
# THEME
# ------------------------------------------------------------ #
zinit depth=1 lucid light-mode nocd for romkatv/powerlevel10k
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

zinit wait lucid light-mode for Aloxaf/fzf-tab

zinit wait lucid light-mode for \
  blockf atpull"zinit creinstall -q ." zsh-users/zsh-completions \
  zdharma/fast-syntax-highlighting

zinit wait lucid light-mode for zsh-users/zsh-history-substring-search

zinit wait lucid for \
  OMZL::git.zsh \
  atload"unalias grv" OMZP::git

# ------------------------------------------------------------ #
# Programs
# ------------------------------------------------------------ #

# Just install rust and make it available globally in the system
zinit ice id-as"rust" wait"0" lucid rustup as"command" \
            pick"bin/rustc" atload="export \
                CARGO_HOME=\$PWD RUSTUP_HOME=\$PWD/rustup"
zinit load zdharma/null

# Installs rust and then the `exa' and `lsd' crates
# and exposes their binaries by altering $PATH
zinit ice rustup as"command" \
  cargo'exa;bat;procs;ripgrep;diesel_cli' \
  pick"bin/(exa|bat|procs|rg|diesel)"
zinit load zdharma/null

# Fzf
zinit ice as"program" mv"fzf-* -> ~/.fzf" \
  atclone"./install" \
  atpull"%atclone"
zinit light junegunn/fzf

# Rust analyzer
zinit ice as"program" \
  atclone"cargo +nightly xtask install --server" \
  atpull"%atclone"
zinit light rust-analyzer/rust-analyzer

# Alacritty
zinit ice as"program" \
  atclone"make app;
          cp -r target/release/osx/Alacritty.app /Applications/" \
  atpull"%atclone"
zinit light alacritty/alacritty

# Lua lsp
zinit ice as"program" \
  atclone"git submodule update --init --recursive;
          cd 3rd/luamake;
          compile/install.sh;
          cd ../..;
          ./3rd/luamake/luamake rebuild;" \
  atpull"%atclone"
zinit light sumneko/lua-language-server

# Neovim
zinit ice as"program" \
  atclone"sudo rm -rf ./build;
          sudo rm -rf ./.deps;
          make CMAKE_BUILD_TYPE=Release DCMAKE_C_COMPILER=/usr/bin/clang DCMAKE_CXX_COMPILER=/usr/bin/clang++;
          sudo make install" \
  atpull"%atclone"
zinit light neovim/neovim

# Tmux
zinit ice as"program" \
  atclone"sh autogen.sh;
          ./configure --enable-utf8proc && make -j 8" \
  atpull"%atclone"
zinit light tmux/tmux

# Colorful diffs
zinit ice as"program" pick"bin/git-dsf"
zinit light zdharma/zsh-diff-so-fancy

# ------------------------------------------------------------ #

zstyle ":completion:*:match:*" original only
zstyle ":completion:*:git-checkout:*" sort false
zstyle ":completion:*:descriptions" format '[%d]'
zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}
zstyle ":fzf-tab:complete:cd:*" fzf-preview "exa -1 --color=always $realpath"
zstyle ":fzf-tab:*" fzf-command fzf

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

# updates PATH for the Google Cloud SDK.
if [ -f "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; then . "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; then . "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"; fi

# enables shell command completion for gcloud.
if [ -f "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" ]; then . "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"; fi
if [ -f "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" ]; then . "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"; fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

printf "\e[?1042l"
