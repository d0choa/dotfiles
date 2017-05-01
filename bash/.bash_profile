#!/bin/bash


########################################################################
# PROMPT
########################################################################

source ${HOME}/.bash_prompt

########################################################################
# GENERAL
########################################################################
export EDITOR=vim

# Make ls & grep pretty
export CLICOLOR=1

# set 256 color profile where possible
if [[ $COLORTERM == gnome-* && $TERM == xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi


########################################################################
# HISTORY
########################################################################
# When the command contains an invalid history operation (for instance when
# using an unescaped "!" (I get that a lot in quick e-mails and commit
# messages) or a failed substitution (e.g. "^foo^bar" when there was no "foo"
# in the previous command line), do not throw away the command line, but let me
# correct it.
shopt -s histreedit;

# append to the history file rather than overwriting
shopt -s histappend

# Keep a reasonably long history.
export HISTSIZE=4096;

# Keep even more history lines inside the file, so we can still look up
# previous commands without needlessly cluttering the current shell's history.
export HISTFILESIZE=16384;

# When executing the same command twice or more in a row, only store it once.
export HISTCONTROL=ignoredups;

# Keep track of the time the commands were executed.
# The xterm colour escapes require special care when piping; e.g. "| less -R".
export HISTTIMEFORMAT="${FG_BLUE}${FONT_BOLD}%Y/%m/%d %H:%M:%S${FONT_RESET} ";

# let the history ignore the following commands
export HISTIGNORE="ls:ll:la:pwd:clear:h:j"

########################################################################
# LOCALE AND COMPLETION
########################################################################

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;


########################################################################
# Alias
########################################################################

#ssh to EBI cluster
alias sshebi="ssh -l ochoa -o proxycommand='ssh -Y -l ochoa gate.ebi.ac.uk proxy %h' -X ebi-004.ebi.ac.uk"

#ssh EBI webproxy
alias sshebiweb="ssh -l ochoa -o proxycommand='ssh -Y -l ochoa gate.ebi.ac.uk proxy %h' ebi-004.ebi.ac.uk -L 8080:www-proxy.ebi.ac.uk:3128"


test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
export PATH="/usr/local/sbin:$PATH"
