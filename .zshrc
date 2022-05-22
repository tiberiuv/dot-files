if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------------------------------------ #
# Env vars
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

alias kc="kubectl"
alias ssh="TERM=xterm-256color ssh"
alias update-all="source ~/icloud/dot-files/update.zsh"
alias clean_evicted="kubectl get pod | grep Evicted | awk '{print $1}' | xargs kubectl delete pod"

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
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
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
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-bin-gem-node \
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
# Just install rust and make it available globally in the system
zinit ice id-as"rust" wait"0" lucid rustup as"command" \
            pick"bin/rustc" atload="export \
                CARGO_HOME=\$PWD RUSTUP_HOME=\$PWD/rustup"
zinit load zdharma-continuum/null

# Installs rust and then a few CLI tools
# and exposes their binaries by altering $PATH
zinit ice rustup as"command" \
  cargo"exa;bat;procs;ripgrep;diesel_cli;du-dust" \
  pick"bin/(exa|bat|procs|rg|diesel|dust)"
zinit load zdharma-continuum/null

# Fzf
zinit ice depth"1" as"program" pick"bin/fzf" \
  atclone"rm -rf bin/fzf && make install" \
  atpull"%atclone"
zinit light junegunn/fzf

zinit wait lucid light-mode for Aloxaf/fzf-tab

# Rust analyzer
zinit ice as"program" \
  atclone"cargo +nightly xtask install --server && rm -rf target" \
  atpull"%atclone"
zinit light rust-analyzer/rust-analyzer

# Alacritty
zinit ice \
  atclone"make app;
          rm -rf /Applications/Alacritty.app;
          cp -r target/release/osx/Alacritty.app /Applications/" \
  atpull"%atclone" \
  pullopts"--rebase --no-ff"
  ver="master"
zinit light alacritty/alacritty

# Lua lsp
zinit ice as"program" pick"bin/macOs" \
  atclone"cd 3rd/luamake;
          compile/install.sh;
          cd ../..;
          ./3rd/luamake/luamake rebuild;" \
  atpull"%atclone"
zinit light sumneko/lua-language-server

# Neovim
zinit ice as"program" pick"build/bin/nvim" \
  atclone"sudo rm -rf ./build;
          sudo rm -rf ./.deps;
          make CMAKE_BUILD_TYPE=Release DCMAKE_C_COMPILER=/usr/bin/clang DCMAKE_CXX_COMPILER=/usr/bin/clang++;
          sudo make install" \
  atpull"%atclone"
zinit light neovim/neovim

# Colorful diffs
zinit ice as"program" pick"bin/git-dsf"
zinit light zdharma-continuum/zsh-diff-so-fancy

# ------------------------------------------------------------ #

zstyle ":completion:*:match:*" original only
zstyle ":completion:*:git-checkout:*" sort false
zstyle ":completion:*:descriptions" format '[%d]'
zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}
zstyle ":fzf-tab:complete:cd:*" fzf-preview "exa -1 --color=always $realpath"
zstyle ":fzf-tab:*" fzf-command fzf

autoload -U compinit
compinit

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
if [ -f "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; then . "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"; fi

# enables shell command completion for gcloud.
if [ -f "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"; fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

printf "\e[?1042l"
# Python version manager
eval "$(pyenv init -)"

# Node version manager
eval "$(fnm env)"
