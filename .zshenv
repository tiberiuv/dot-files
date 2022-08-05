if [[ $(uname -m) == arm64 ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
  export SPARK_HOME="$HOMEBREW_PREFIX/opt/apache-spark/libexec"
  export RUST_ANALYZER_TARGET="aarch64-apple-darwin"
else
  eval $(/usr/local/bin/brew shellenv)
  export SPARK_HOME="$HOMEBREW_PREFIX/Cellar/apache-spark/3.2.0/libexec"
  export RUST_ANALYZER_TARGET="x86_64-apple-darwin"
fi

# ------------------------------------------------------------ #
# Environment variables
# ------------------------------------------------------------ #
export RUST_HOME="$HOME/.rustup"
export CARGO_HOME="$HOME/.cargo"

export PYENV_ROOT="$HOME/.pyenv"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home
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
# Path
# ------------------------------------------------------------ #
export PATH=$PYENV_ROOT/bin:$PATH
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
export PATH=$HOMEBREW_PREFIX/opt/llvm/bin:$PATH
export PATH=$HOMEBREW_PREFIX/p/versions/python:$PATH
export PATH=$HOMEBREW_PREFIX/opt/openssl@3/bin:$PATH
# ------------------------------------------------------------ #
# Compiler flags
# ------------------------------------------------------------ #
# export LIBRARY_PATH=$LIBRARY_PATH:$HOMEBREW_PREFIX/opt/openssl/lib/
# export LIBRARY_PATH=$LIBRARY_PATH:$HOMEBREW_PREFIX/lib/
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl@3/include"
# ------------------------------------------------------------ #
. "$HOME/.cargo/env"
