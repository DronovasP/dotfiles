#!/bin/bash
set -e

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  echo "Cloning Tmux Plugin Manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "Tmux Plugin Manager (TPM) already installed."
fi
