#!/bin/bash

# Everything apt can't provide (no package, too outdated, or needs a
# version manager). Mirrors install_scripts/osx/install_packages.sh.
# Not sourced into an interactive shell, so PATH additions needed by later
# steps in this script are exported inline.

# Release tarballs/binaries below are per-architecture; don't hardcode amd64 or
# this whole script silently produces an unusable box on arm64 hosts.
case "$(uname -m)" in
  x86_64 | amd64)
    GO_ARCH=amd64
    KUBECTL_ARCH=amd64
    HADOLINT_ARCH=x86_64
    LUA_LS_ARCH=x64
    COURSIER_ARCH=x86_64
    NVIM_ARCH=x86_64
    ;;
  aarch64 | arm64)
    GO_ARCH=arm64
    KUBECTL_ARCH=arm64
    HADOLINT_ARCH=arm64
    LUA_LS_ARCH=arm64
    COURSIER_ARCH=aarch64
    NVIM_ARCH=arm64
    ;;
  *)
    echo "Unsupported architecture: $(uname -m)" >&2
    return 1 2>/dev/null || exit 1
    ;;
esac

mkdir -p ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

# neovim: apt only has a current version behind the Ubuntu PPA (see
# apt-install.sh), so on Debian pull the upstream release instead.
if ! command -v nvim >/dev/null 2>&1; then
  curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz" -o /tmp/nvim.tar.gz
  sudo rm -rf "/usr/local/nvim-linux-${NVIM_ARCH}"
  sudo tar -C /usr/local -xzf /tmp/nvim.tar.gz
  rm /tmp/nvim.tar.gz
  ln -sf "/usr/local/nvim-linux-${NVIM_ARCH}/bin/nvim" ~/.local/bin/nvim
fi

# Go (apt's golang-go lags too far behind on Debian/Ubuntu stable)
GO_VERSION="$(curl -s 'https://go.dev/VERSION?m=text' | head -n 1)"
curl -fsSL "https://go.dev/dl/${GO_VERSION}.linux-${GO_ARCH}.tar.gz" -o /tmp/go.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz
export PATH=/usr/local/go/bin:$HOME/go/bin:$PATH

# Go-installable CLIs
go install github.com/mikefarah/yq/v4@latest
go install github.com/gpanders/ijq@latest
go install github.com/simeji/jid/cmd/jid@latest
go install github.com/lindell/multi-gitter@latest
go install github.com/terraform-linters/tflint@latest
go install github.com/hashicorp/terraform-ls@latest

# Standalone release binaries -> ~/.local/bin (already on PATH per .zshrc)

# kubectl
KUBECTL_VERSION="$(curl -s https://dl.k8s.io/release/stable.txt)"
curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl" -o ~/.local/bin/kubectl
chmod +x ~/.local/bin/kubectl

# hadolint (Dockerfile linter, no apt package)
curl -fsSL "https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-${HADOLINT_ARCH}" -o ~/.local/bin/hadolint
chmod +x ~/.local/bin/hadolint

# lua-language-server
LUA_LS_VERSION="$(curl -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | grep '"tag_name"' | cut -d '"' -f4)"
mkdir -p ~/.local/share/lua-language-server
curl -fsSL "https://github.com/LuaLS/lua-language-server/releases/download/${LUA_LS_VERSION}/lua-language-server-${LUA_LS_VERSION}-linux-${LUA_LS_ARCH}.tar.gz" -o /tmp/lua-language-server.tar.gz
tar -C ~/.local/share/lua-language-server -xzf /tmp/lua-language-server.tar.gz
rm /tmp/lua-language-server.tar.gz
cat > ~/.local/bin/lua-language-server <<'EOF'
#!/bin/sh
exec "$HOME/.local/share/lua-language-server/bin/lua-language-server" "$@"
EOF
chmod +x ~/.local/bin/lua-language-server

# JetBrains Mono Nerd Font (brew installs the cask on macOS; alacritty.toml and
# the p10k prompt both expect the nerd glyphs)
if ! fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font"; then
  mkdir -p ~/.local/share/fonts
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" -o /tmp/JetBrainsMono.tar.xz
  tar -C ~/.local/share/fonts -xf /tmp/JetBrainsMono.tar.xz
  rm /tmp/JetBrainsMono.tar.xz
  fc-cache -f >/dev/null
fi

# fnm/node/npm globals (fnm itself installed via cargo in shared/install-packages.sh)
export PATH="$HOME/.cargo/bin:$PATH"
eval "$(fnm env)"
fnm install --lts
fnm use --install-if-missing lts-latest
eval "$(fnm env)"
# tree-sitter-cli is only packaged by apt on very recent releases, and
# nvim-treesitter's `main` branch needs it to build parsers.
npm install -g \
  cspell \
  markdownlint-cli2 \
  yaml-language-server \
  @fsouza/prettierd \
  yarn \
  tree-sitter-cli \
  eslint_d \
  @commitlint/cli \
  @commitlint/config-conventional

# Python CLIs via pipx
pipx install ansible-lint
pipx install ruff
pipx install pipenv
pipx install flake8
pipx install black
pipx install isort

# poetry
curl -sSL https://install.python-poetry.org | python3 -

# pyenv
if [ ! -d "$HOME/.pyenv" ]; then
  curl https://pyenv.run | bash
fi

# tfenv (no apt package)
if [ ! -d "$HOME/.tfenv" ]; then
  git clone https://github.com/tfenv/tfenv.git ~/.tfenv
fi
export PATH="$HOME/.tfenv/bin:$PATH"
tfenv install latest
tfenv use latest

# mise + lua plugin
curl https://mise.run | sh
mise plugins add --yes lua
mise use -g lua@5.1

# Scala via Coursier (no apt package). Deliberately not `cs setup` since it
# auto-appends PATH exports to the detected shell rc file, and ~/.zshrc here
# is a symlink into this git repo (would silently mutate the tracked file).
curl -fL "https://github.com/coursier/coursier/releases/latest/download/cs-${COURSIER_ARCH}-pc-linux.gz" -o /tmp/cs.gz
gunzip -f /tmp/cs.gz
chmod +x /tmp/cs
mv /tmp/cs ~/.local/bin/cs
export PATH="$HOME/.local/share/coursier/bin:$PATH"
~/.local/bin/cs install scala scalac sbtn scalafmt

# stylua (conform formats lua with it; no apt package)
cargo install stylua

# luarocks packages (luarocks itself came from apt; --local avoids needing
# sudo, and .zshrc puts ~/.luarocks/bin on PATH)
luarocks install --local luacheck
luarocks install --local luaformatter
