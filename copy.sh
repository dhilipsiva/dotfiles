rsync \
    --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude "install.sh" \
    --exclude "README.md" \
    --exclude "LICENSE.txt" \
    -av --no-perms . ~
