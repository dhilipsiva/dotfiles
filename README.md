dotfiles
========

My dotfiles

## Installation

WARNING: Please take a back-up of your dotfiles if you have any. This file may overwrite some stuff in `~` and `~/Projects` and `~/Projects/dotfiles` directories.

### Requirements

Common Requirements:

* *nix systems (Ofcourse, Mac OS too)
* Curl
* Git
* Make sure your machine's public key is added to your GitHub account.

Mac OS requirement:

* Xcode command line tools
* Homebrew (for scripts to run properly)
* Homebrew Cask (Optional)

Copy-Paste the following line in your terminal

`curl https://raw.githubusercontent.com/dhilipsiva/dotfiles/master/install.sh | sh`

## Updating

Just run the following command from your termianl

`~/update.sh`

Or if you prefer to use the latest update scripts, execute:

`curl https://raw.githubusercontent.com/dhilipsiva/dotfiles/master/update.sh | sh`

That is it.


# Things to backup before new OS installation:

SSH Keys

# Setting up new systems

1. `brew info sqlite`
1. `brew install sqlite --universal --with-dbstat --with-docs --with-fts --with-fts5 --with-functions --with-icu4c --with-json1 --with-secure-delete --with-session --with-unlock-notify`
1. `brew info perl`
1. `brew install perl --with-dtrace`
1. `PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib`
1. `brew info ruby`
1. `brew install ruby --universal --with-doc --with-gdbm --with-gmp --with-libffi`
1. `brew info python3`
1. `brew install python3 --universal --with-quicktest --with-sphinx-doc`
1. `brew link --overwrite python3`
1. `pip install --upgrade pip setuptools`

Create Default Python3 Venv called default
create a default py 2 env called default2
