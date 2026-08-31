#!/bin/bash

# Everything apt can't provide (no package, too outdated, or needs a
# version manager). Mirrors install_scripts/osx/install_packages.sh.
# Not sourced into an interactive shell, so PATH additions needed by later
# steps in this script are exported inline.

# Go (apt's golang-go lags too far behind on Debian/Ubuntu stable)
GO_VERSION="$(curl -s https://go.dev/VERSION?m=text | head -n 1)"
curl -fsSL "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz
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
mkdir -p ~/.local/bin

# kubectl
KUBECTL_VERSION="$(curl -s https://dl.k8s.io/release/stable.txt)"
curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o ~/.local/bin/kubectl
chmod +x ~/.local/bin/kubectl

# hadolint (Dockerfile linter, no apt package)
curl -fsSL "https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64" -o ~/.local/bin/hadolint
chmod +x ~/.local/bin/hadolint

# lua-language-server
LUA_LS_VERSION="$(curl -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | grep '"tag_name"' | cut -d '"' -f4)"
mkdir -p ~/.local/share/lua-language-server
curl -fsSL "https://github.com/LuaLS/lua-language-server/releases/download/${LUA_LS_VERSION}/lua-language-server-${LUA_LS_VERSION}-linux-x64.tar.gz" -o /tmp/lua-language-server.tar.gz
tar -C ~/.local/share/lua-language-server -xzf /tmp/lua-language-server.tar.gz
rm /tmp/lua-language-server.tar.gz
cat > ~/.local/bin/lua-language-server <<'EOF'
#!/bin/sh
exec "$HOME/.local/share/lua-language-server/bin/lua-language-server" "$@"
EOF
chmod +x ~/.local/bin/lua-language-server

# fnm/node/npm globals (fnm itself installed via cargo in shared/install-packages.sh)
export PATH="$HOME/.cargo/bin:$PATH"
eval "$(fnm env)"
fnm install --lts
fnm use --install-if-missing lts-latest
eval "$(fnm env)"
npm install -g cspell markdownlint-cli2 yaml-language-server @fsouza/prettierd yarn

# Python CLIs via pipx
pipx install ansible-lint
pipx install ruff
pipx install pipenv

# poetry
curl -sSL https://install.python-poetry.org | python3 -

# pyenv
curl https://pyenv.run | bash

# tfenv (no apt package)
if [ ! -d "$HOME/.tfenv" ]; then
  git clone https://github.com/tfenv/tfenv.git ~/.tfenv
fi
export PATH="$HOME/.tfenv/bin:$PATH"
tfenv install latest
tfenv use latest

# mise + lua plugin
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
mise plugins add lua
mise use -g lua@5.1

# Scala via Coursier (no apt package). Deliberately not `cs setup` since it
# auto-appends PATH exports to the detected shell rc file, and ~/.zshrc here
# is a symlink into this git repo (would silently mutate the tracked file).
curl -fL "https://github.com/coursier/coursier/releases/latest/download/cs-x86_64-pc-linux.gz" -o /tmp/cs.gz
gunzip -f /tmp/cs.gz
chmod +x /tmp/cs
mv /tmp/cs ~/.local/bin/cs
export PATH="$HOME/.local/share/coursier/bin:$PATH"
~/.local/bin/cs install scala scalac sbtn scalafmt

# luarocks packages (luarocks itself came from apt; --local avoids needing sudo)
luarocks install --local luacheck
luarocks install --local luaformatter

# nvim plugins already handled by shared/install-packages.sh
