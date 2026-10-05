#!/bin/sh

# Keep the coding agents on their providers' stable release channels instead
# of waiting for nixpkgs and rebuilding the flake to update them.
curl -fsSL https://claude.ai/install.sh | bash -s stable
npm install -g @openai/codex@latest
