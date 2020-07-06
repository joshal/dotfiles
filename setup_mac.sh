#!/bin/sh

set -x

if [ "$(uname)" != "Darwin" ]; then
    echo "Unable to establish that this is Mac. Skipping..."
fi

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle install -f -v
brew bundle cleanup -f
brew bundle check -v

# Make homebrew installed zsh the default shell
if ! grep -Fxq "/usr/local/bin/zsh" /etc/shells; then
    echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
fi

chsh -s /usr/local/bin/zsh
