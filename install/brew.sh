#!/usr/bin/env bash

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
# brew install bash
# brew tap homebrew/versions
# brew install bash-completion2
# # Switch to using brew-installed bash as default shell
# if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
#   echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
#   chsh -s /usr/local/bin/bash;
# fi;

# Install `wget` with IRI support.
brew install wget --with-iri
brew install curl

# Install more recent versions of some macOS tools.
# brew install vim --override-system-vi
brew install grep --with-default-names
brew install openssh
# brew install screen
# brew install homebrew/php/php56 --with-gmp

# Install other useful binaries.
brew install git
brew install stow

brew install zsh
brew install zsh-syntax-highlighting

brew install tmux

#window manager
brew tap crisidev/homebrew-chunkwm
brew install chunkwm
brew install koekeishiya/formulae/skhd
brew services start chunkwm
brew services start skhd

brew install aspell
brew install emacs

brew install tcl-tk
brew install r

brew install perl
brew install cpanminus
brew install mysql
brew install node
npm install --global pure-prompt
brew install pandoc

# Remove outdated versions from the cellar.
brew cleanup
