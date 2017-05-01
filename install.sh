#!/bin/bash

DOTFILES_DIRECTORY="${HOME}/.dotfiles"

cd ${DOTFILES_DIRECTORY}

source utils.sh

# Before relying on Homebrew, check that packages can be compiled
if ! type_exists 'gcc'; then
    printf "Installing Xcode Command line tools. Try again once the tools are installed."
	xcode-select --install
    exit 1
fi

# Check for Homebrew
if ! type_exists 'brew'; then
    e_header "Installing Homebrew..."	
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Check for git
if ! type_exists 'git'; then
    e_header "Updating Homebrew..."
    brew update
    e_header "Installing Git..."
    brew install git
fi


link() {
    # Force create/replace the symlink.
    ln -fs "${DOTFILES_DIRECTORY}/${1}" "${HOME}/${2}"
}

mirrorfiles() {
    # Force remove the vim directory if it's already there.
    if [ -e "${HOME}/.emacs.d" ]; then
        rm -rf "${HOME}/.emacs.d"
    fi

    # Create the necessary symbolic links between the `.dotfiles` and `HOME`
    # directory. The `bash_profile` sources other files directly from the
    # `.dotfiles` repository.
    link "emacs"              ".emacs.d"
	link "bash_prompt"        ".bash_prompt"
	link "bash_profile"       ".bash_profile"
	
    e_success "Dotfiles update complete!"
}

# Ask before potentially overwriting OS X defaults
seek_confirmation "Warning: This step may modify your OS X system defaults."

if is_confirmed; then
    bash ${DOTFILES_DIRECTORY}/macos.sh
    e_success "OS X settings updated! You may need to restart."
else
    printf "Skipped OS X settings update.\n"
fi

# Ask before downloading apps from Appstore
seek_confirmation "Warning: This step downloads apps from the App store. Double check the apps do not cost money."

if is_confirmed; then
    bash ${DOTFILES_DIRECTORY}/appstore.sh
    e_success "Apps correctly downloaded from the AppStore."
else
    printf "App Store downloads stopped.\n"
fi

# Ask before installing cask-apps
seek_confirmation "Warning: This step may install apps (cask) in your Application folder."

if is_confirmed; then
    bash ${DOTFILES_DIRECTORY}/brew_cask.sh
    e_success "Applications installed!."
else
    printf "Brew cask skipped.\n"
fi

# Ask before installing brew apps
seek_confirmation "Warning: This step may overwrite default command-line tools."

if is_confirmed; then
    bash ${DOTFILES_DIRECTORY}/brew.sh
    e_success "Homebrew binaries installed!."
else
    printf "Brewing skipped.\n"
fi

# Ask before potentially overwriting files
seek_confirmation "Warning: This step may overwrite your existing dotfiles."

if is_confirmed; then
    mirrorfiles
    source ${HOME}/.bash_profile
else
    printf "Aborting...\n"
    exit 1
fi
