#!/usr/bin/env bash

# Install cask tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

brew cask install xquartz

brew cask install spotify
brew cask install amethyst
brew cask install google-chrome
brew cask install papers
brew cask install textmate
brew cask install whatsapp
brew cask install rescuetime

brew cask install iterm2-nightly

brew cask install emacs

brew cask install alfred

# Remove outdated versions from the cellar.
brew cleanup
