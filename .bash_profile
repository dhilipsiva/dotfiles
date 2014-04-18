export LANG="en_US.UTF-8"
export PS1=' \[\033[4;35m\]\W \[\033[4;36m\]->\[\033[0m\] '
export PATH="/usr/local/sbin:/usr/local/bin:/usr/local/opt/ruby/bin:$PATH"
export CUDA_ROOT="/usr/local/cuda/bin"
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/{path,exports,aliases,functions,extra}.sh; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion

# My private bash scripts that I do not want to put on GitHub. Top Secret :P
. ~/private.sh

# Functions

function m {
    if [[ $1 = "" ]]; then
        mvim .
    else
        mvim $*
    fi
}

function rs {
    if [[ $1 = "" ]]; then
        ./manage.py runserver 0.0.0.0:8000
    else
        ./manage.py runserver 0.0.0.0:$1
    fi
}

### Added by the Heroku Toolbelt

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Shortcut to google search from commandline. Handy, huh?
function google {
    open "https://google.com/search?q=$*"
}

function commit {
    if [[ $1 = "" ]]; then
        git commit -m "Quick commit"
    else
        git commit -m "$*"
    fi
}

# brew bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# open Dash docs
function dash {
    open "dash://$*"
}

function search {
    grep -irl --exclude=\*.{pyc,swp,un~,png,jpg} --exclude-dir=".git" --color "$*" .
}

function tc {
    # Just a true caller shortcut
    open "http://www.truecaller.com/in/$*"
}

function irc-ext {
     . ~/ENV/irc-ext/bin/activate
     cd ~/WIP/irc-ext/
}

# Function for my site - dhilipsiva.com
function site {
     . ~/ENV/site/bin/activate
     cd ~/WIP/site/
}

# Activate an environment
function act {
    . ~/ENV/$(@x_repo $*)/bin/activate
    cd ~/WIP/$(@x_repo $*)
}
