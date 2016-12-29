function parse_git_dirty() {
    [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}

function parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

function rs {
    if [[ $1 = "" ]]; then
        ./manage.py runserver 0.0.0.0:8000
    else
        ./manage.py runserver 0.0.0.0:$1
    fi
}

# Shortcut to google search from commandline. Handy, huh?
function goog {
    open ~/clean.html
}

# open Dash docs
function dash {
    open "dash://$*"
}

function search {
    grep -irl \
        --exclude=\*.{pyc,swp,un~,png,jpg} \
        --exclude-dir=".git" \
        --exclude-dir="node_modules" \
        --exclude-dir="bower_components" \
        --exclude-dir="dist" \
        --exclude-dir="tmp" \
        --exclude-dir=".sass-cache" \
        --exclude-dir="Appknox" \
        --exclude-dir="build" \
        --exclude-dir="uploads" \
        --color "$*" .
}

function tc {
    # Just a true caller shortcut
    open "http://www.truecaller.com/in/$*"
}

# Function for my site - dhilipsiva.com
function site {
     . ~/ENV/site/bin/activate
     cd ~/Projects/site/
}

# Activate an environment
function act {
    . ~/ENV/$(@x_repo $*)/bin/activate
    cd ~/Projects/$(@x_repo $*)
}

# Simple calculator
function calc() {
    local result=""
    result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')"
    #                       └─ default (when `--mathlib` is used) is 20
    #
    if [[ "$result" == *.* ]]; then
        # improve the output for decimal numbers
        printf "$result" |
        sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
            -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
            -e 's/0*$//;s/\.$//'   # remove trailing zeros
    else
        printf "$result"
    fi
    printf "\n"
}

# Create a new directory and enter it
function mkd() {
    mkdir -p "$@" && cd "$@"
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
    local tmpFile="${@%/}.tar"
    tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

    size=$(
        stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
        stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
    )

    local cmd=""
    if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
        # the .tar file is smaller than 50 MB and Zopfli is available; use it
        cmd="zopfli"
    else
        if hash pigz 2> /dev/null; then
            cmd="pigz"
        else
            cmd="gzip"
        fi
    fi

    echo "Compressing .tar using \`${cmd}\`…"
    "${cmd}" -v "${tmpFile}" || return 1
    [ -f "${tmpFile}" ] && rm "${tmpFile}"
    echo "${tmpFile}.gz created successfully."
}

# Determine size of a file or total size of a directory
function fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh
    else
        local arg=-sh
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@"
    else
        du $arg .[^.]* *
    fi
}

# Use Git’s colored diff when available
hash git &>/dev/null
if [ $? -eq 0 ]; then
    function diff() {
        git diff --no-index --color-words "$@"
    }
fi

# Create a data URL from a file
function dataurl() {
    local mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Create a git.io short URL
function gitio() {
    if [ -z "${1}" -o -z "${2}" ]; then
        echo "Usage: \`gitio slug url\`"
        return 1
    fi
    curl -i http://git.io/ -F "url=${2}" -F "code=${1}"
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
    local port="${1:-8000}"
    sleep 1 && open "http://localhost:${port}/" &
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
    python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}


# All the dig info
function digga() {
    dig +nocmd "$1" any +multiline +noall +answer
}

# Escape UTF-8 characters into their 3-byte format
function escape() {
    printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo # newline
    fi
}

# Decode \x{ABCD}-style Unicode escape sequences
function unidecode() {
    perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo # newline
    fi
}

# Get a character’s Unicode code point
function codepoint() {
    perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))"
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo # newline
    fi
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
    if [ -z "${1}" ]; then
        echo "ERROR: No domain specified."
        return 1
    fi

    local domain="${1}"
    echo "Testing ${domain}…"
    echo # newline

    local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
        | openssl s_client -connect "${domain}:443" 2>&1);

    if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
        local certText=$(echo "${tmp}" \
            | openssl x509 -text -certopt "no_header, no_serial, no_version, \
            no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux");
            echo "Common Name:"
            echo # newline
            echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//";
            echo # newline
            echo "Subject Alternative Name(s):"
            echo # newline
            echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
                | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2
            return 0
    else
        echo "ERROR: Certificate not found.";
        return 1
    fi
}

# Add note to Notes.app (OS X 10.8)
# Usage: `note 'title' 'body'` or `echo 'body' | note`
# Title is optional
function note() {
    local title
    local body
    if [ -t 0 ]; then
        title="$1"
        body="$2"
    else
        title=$(cat)
    fi
    osascript >/dev/null <<EOF
tell application "Notes"
    tell account "iCloud"
        tell folder "Notes"
            make new note with properties {name:"$title", body:"$title" & "<br><br>" & "$body"}
        end tell
    end tell
end tell
EOF
}

# Add reminder to Reminders.app (OS X 10.8)
# Usage: `remind 'foo'` or `echo 'foo' | remind`
function remind() {
    local text
    if [ -t 0 ]; then
        text="$1" # argument
    else
        text=$(cat) # pipe
    fi
    osascript >/dev/null <<EOF
tell application "Reminders"
    tell the default list
        make new reminder with properties {name:"$text"}
    end tell
end tell
EOF
}

# Manually remove a downloaded app or file from the quarantine
function unquarantine() {
    for attribute in com.apple.metadata:kMDItemDownloadedDate com.apple.metadata:kMDItemWhereFroms com.apple.quarantine; do
        xattr -r -d "$attribute" "$@"
    done
}

# Install Grunt plugins and add them as `devDependencies` to `package.json`
# Usage: `gi contrib-watch contrib-uglify zopfli`
function gi() {
    npm install --save-dev ${*/#/grunt-}
}

# `o` with no arguments opens current directory, otherwise opens the given
# location

function o() {
    if [ $# -eq 0 ]; then
        open .
    else
        open "$@"
    fi
}

# `np` with an optional argument `patch`/`minor`/`major`/`<version>`
# defaults to `patch`
function np() {
    git pull --rebase && \
    rm -rf node_modules && \
    npm install && \
    npm test && \
    npm version ${1:=patch} && \
    npm publish && \
    git push origin master && \
    git push origin master --tags
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

# A function to install vim plugins (Vim INstaller)
# Make sure you are in `~` folder when you execute this command
function vin(){
    cd ~/Projects/dotfiles && git submodule add -f $1 .vim/bundle/$2
}

# Just a test function
function ttest(){
    echo $1 $2
}

function style {
     . ~/ENV/style/bin/activate
     cd ~/Projects/style.js/
}

function node_test {
    . ~/ENV/personal/node_test/bin/activate
    cd ~/Projects/personal/node_test/
}

function tunnel {
    ngrok -subdomain=dhilipsiva $1
}

function storage {
    . ~/ENV/file_storage/bin/activate
    cd ~/Projects/file_storage
}

function testf {
    . ~/ENV/testf/bin/activate
    cd ~/Projects/testf
}

function watchmen {
    . ~/ENV/watchmen/bin/activate
    cd ~/Projects/watchmen
}

function websockify1 {
    . ~/ENV/appknox/websockify/bin/activate
    cd ~/Projects/appknox/websokify
}

function junction {
    . ~/ENV/junction/bin/activate
    cd ~/Projects/junction
}

function dhilipsiva {
    . ~/ENV/dhilipsiva/bin/activate
    cd ~/Projects/dhilipsiva
}

function ember-cli-payments {
    . ~/ENV/ember-cli-payments/bin/activate
    cd ~/Projects/ember-cli-payments
}

function sortie {
    . ~/ENV/sortie/bin/activate
    cd ~/Projects/appknox/sortie
}

function appknox-python {
    . ~/ENV/appknox/appknox-python/bin/activate
    cd ~/Projects/appknox/appknox-python
}

function appknox.github.io {
    . ~/ENV/appknox/appknox.github.io/bin/activate
    cd ~/Projects/appknox/appknox.github.io
}

function nomnom {
    . ~/ENV/nomnom/bin/activate
    cd ~/Projects/nomnom
}

function start_docker() {
	docker-machine start default
	eval $(docker-machine env default)
	echo "The containers:"
	docker ps
}

function clean_docker() {
	# Delete all containers
	docker rm $(docker ps -a -q)
	# Delete all images
	docker rmi $(docker images -q)
}


function let_me_in {
    . ~/ENV/appknox/let_me_in/bin/activate
    cd ~/Projects/appknox/let_me_in
}

function stupid-sockets {
    . ~/ENV/appknox/stupid-sockets/bin/activate
    cd ~/Projects/appknox/stupid-sockets
}

function test3 {
    . ~/ENV/personal/test3/bin/activate
    cd ~/Projects/personal/test
}

function mailpile-client {
    electron-open http://localhost:33411/ &
}

function mailpile {
    [ -e "$HOME/Library/Application Support/Mailpile/osx.pwd" ] \
        && cd $(cat "$HOME/Library/Application Support/Mailpile/osx.pwd")
    export MAILPILE_BREW_ROOT="$(pwd)/Mailpile-Brew"
    export MAILPILE_ROOT="$(pwd)/Mailpile"
    export PATH="$MAILPILE_BREW_ROOT/bin:/usr/bin:/bin"
    export PYTHONHOME="$MAILPILE_BREW_ROOT/Cellar/python/2.7.8/Frameworks/Python.framework/Versions/2.7/"
    export OPENSSL_CONF="$MAILPILE_BREW_ROOT/etc/openssl/openssl.cnf"
    echo $MAILPILE_ROOT
    cd "$MAILPILE_ROOT"
    ./mp --www= --interact
}

function pull_from_device() {
	OP=`adb shell pm path $1 | sed -e "s/package://g"`
	echo "PATH:"
	echo $OP
	echo "type the folowwing command to get apk:"
	echo "adb pull <PATH> && mv *.apk ~/Downloads/ && open ~/Downloads/"
}

function apk_download() {
	adb shell am start -a android.intent.action.VIEW -d "market://details?id=$1"
	echo "once you install the app on your device enter the following command again:"
	echo "pull_from_device $1"
}

function fab-env() {
    . ~/ENV/fab-env/bin/activate
}

function playconda() {
    . ~/ENV/others/playconda/bin/activate
	cd ~/Projects/others/playconda
}

function pwdman-env() {
    . ~/ENV/personal/pwdman/bin/activate
	cd ~/Projects/personal/pwdman
}

function pymobiledevice() {
    . ~/ENV/appknox/pymobiledevice/bin/activate
	cd ~/Projects/appknox/pymobiledevice
}


function frida-runner-env() {
    . ~/ENV/appknox/frida-runner/bin/activate
	cd ~/Projects/appknox/frida-runner
}

function scrum-env() {
    . ~/ENV/personal/scrum/bin/activate
	cd ~/Projects/personal/scrum
}

function djocker() {
	docker-machine start djocker
	eval $(docker-machine env djocker)
	docker ps
    . ~/ENV/personal/djocker/bin/activate
	cd ~/Projects/personal/djocker
}

function termask-env() {
    . ~/ENV/personal/termask/bin/activate
	cd ~/Projects/personal/termask
}

function neural-doodle() {
    . ~/ENV/others/neural-doodle/bin/activate
	cd ~/Projects/others/neural-doodle
}

function bangpy() {
    . ~/ENV/others/bangpy/bin/activate
	cd ~/Projects/others/bangpy
}

function email-template-generator() {
    . ~/ENV/personal/email-template-generator/bin/activate
    cd ~/Projects/personal/email-template-generator
}

function bohemia() {
	. ~/ENV/appknox/bohemia/bin/activate
	cd ~/Projects/appknox/bohemia
}

function personal-server-ssh {
	gcloud compute \
	--project $PERSONAL_CLOUD_PROJECT \
	ssh \
	--zone $PERSONAL_SERVER_ZONE $PERSONAL_SERVER_NAME
}


function hostscli-env() {
    . ~/ENV/personal/hostscli-env/bin/activate
	cd ~/Projects/personal/hostscli
}
