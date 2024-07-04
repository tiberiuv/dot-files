if [[ $(uname -m) == arm64 ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export SPARK_HOME="$HOMEBREW_PREFIX/opt/apache-spark/libexec"
  export RUST_ANALYZER_TARGET="aarch64-apple-darwin"
else
  eval "$(/usr/local/bin/brew shellenv)"
  export SPARK_HOME="$HOMEBREW_PREFIX/Cellar/apache-spark/3.2.0/libexec"
  export RUST_ANALYZER_TARGET="x86_64-apple-darwin"
fi

# Python version manager
eval "$(pyenv init --path)"
