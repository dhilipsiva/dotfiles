export LANG="en_US.UTF-8"
export PATH="/usr/local/sbin:/usr/local/bin:/usr/local/opt/ruby/bin:$PATH:/usr/local/opt/go/libexec/bin/bin"
export CUDA_ROOT="/usr/local/cuda/bin"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"

# Make vim the default editor
export EDITOR="vim"
export SHELL=/usr/local/bin/bash

# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"

export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
export LSCOLORS="gxfxcxdxbxegedabagacad"

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
        MAGENTA=$(tput setaf 9)
        ORANGE=$(tput setaf 172)
        GREEN=$(tput setaf 190)
        PURPLE=$(tput setaf 141)
        WHITE=$(tput setaf 0)
    else
        MAGENTA=$(tput setaf 5)
        ORANGE=$(tput setaf 4)
        GREEN=$(tput setaf 2)
        PURPLE=$(tput setaf 1)
        WHITE=$(tput setaf 7)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
fi

export MAGENTA
export ORANGE
export GREEN
export PURPLE
export WHITE
export BOLD
export RESET

if [ "$(uname)" == "Darwin" ]; then
    export PS1=' \[${BOLD}${MAGENTA}\]\W\[$RESET\] \n 🙌  '
else
    export PS1=' \[${BOLD}${MAGENTA}\]\W \[$GREEN\]->\[$RESET\] '
fi

# Highlight section titles in manual pages
export LESS_TERMCAP_mb="$MAGENTA"
export LESS_TERMCAP_md="$GREEN"
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so="$ORANGE"
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us="$PURPLE"

export ANDROID_HOME=/usr/local/opt/android-sdk

export FIGNORE=$FIGNORE:.hi:.pyc:.o:.swp
export GOPATH=/usr/local/opt/go/libexec/bin
export PATH=$PATH:$GOPATH

export PATH=/opt/local/bin:$PATH

export LDFLAGS=-L/usr/local/opt/libffi/lib:$LDFLAGS
export LDFLAGS=-L/usr/local/opt/openssl/lib:$LDFLAGS
export CPPFLAGS=-I/usr/local/opt/openssl/include

export PATH=$PATH:/usr/local/Cellar/gettext/0.19.8.1/bin
