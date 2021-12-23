#!/usr/bin/bash

# Repos needed for non-MELPA/ELPA deps
mkdir -p ~/Projects/src/github.com/sebastiencs
cd ~/Projects/src/github.com/sebastiencs
git clone https://github.com/sebastiencs/sidebar.el
git clone https://github.com/sebastiencs/icons-in-terminal
cd -

# Assumes Go toolchain is already installed/configured
GO111MODULE=on go get golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest

# Assumes npm is installed

npm i -g markdown-it

# Assumes Python is installed
pip install 'python-lsp-server[all]'

## Random stuff to buld out the emacs env 
mkdir ~/.emacs-saves
