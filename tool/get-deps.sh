#!/usr/bin/env bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
\curl -sSL https://get.rvm.io | bash -s stable
echo "export PATH=\"$PATH:$HOME/.rvm/bin\"" >> $HOME/.bashrc