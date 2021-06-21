#!/usr/bin/bash

# Repos needed for non-MELPA/ELPA deps
mkdir -p ~/Projects/src/github.com/sebastiencs
cd ~/Projects/src/github.com/sebastiencs
git clone https://github.com/sebastiencs/sidebar.el
git clone https://github.com/sebastiencs/icons-in-terminal
cd -

# Rust analyzer installer so we don't have to use rustup and nightly
mkdir -p ~/Projects/src/github.com/rust-analyzer
cd ~/Projects/src/github.com/rust-analyzer
git clone https://github.com/rust-analyzer/rust-analyzer.git
cd rust-analyzer
cargo xtask install --server

# Assumes Go toolchain is already installed/configured
GO111MODULE=on go get golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest

# Assumes npm is installed

npm i -g intelephense
npm i -g bash-language-server

# Assumes Python is installed

pip install python-language-server[all]

## Random stuff to buld out the emacs env 
mkdir ~/.emacs-saves
