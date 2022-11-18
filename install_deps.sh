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

# Assumes ruby is already installed
gem install solargraph
# If this doesn't install into ruby/3.0.0 the path will need updated in init.el

# Assumes npm is installed

npm i -g markdown-it

# Assumes Python is installed
pip install 'python-lsp-server[all]'

## Random stuff to buld out the emacs env 
mkdir ~/.emacs-saves

## THere are a couple steps that should be taken to avoid issues with org babel
# 1, after installing all deps, execute this:
# sed -i 's/jq -r/jq -j/g' ~/.emacs.d/elpa/ob-http-*/ob-http.el*
