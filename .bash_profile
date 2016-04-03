# Load the shell dotfiles, and then some:
for file in ~/{exports,aliases,functions,private}.sh; do
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

if [ "$(uname)" == "Darwin" ]; then
    {
        # brew bash completion
        if [ -f $(brew --prefix)/etc/bash_completion ]; then
            . $(brew --prefix)/etc/bash_completion
        fi
        if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
            . $(brew --prefix)/share/bash-completion/bash_completion
        fi
		if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    		source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
		fi
    } || {
    echo "Brew not installed.."
}
fi

### Added by the Heroku Toolbelt

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

complete -C aws_completer aws

# A `faric` auto completion utility
_fab()
{
    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    local tags=$(fab -l 2>/dev/null | grep "^    " | awk '{print $1;}')
    COMPREPLY=($(compgen -W "${tags}" $cur))
}
complete -F _fab fab

complete -o bashdefault -o default -o nospace -F _git g 2>/dev/null \
    || complete -o default -o nospace -F _git g

complete -F _docker d

complete -F _docker-machine dm

complete -F _docker-compose dc
