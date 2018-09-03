#!/usr/bin/env bash

scriptPath="${BASH_SOURCE[0]}"
scriptDirPath=`dirname ${scriptPath}`
realScriptDirPath=`realpath ${scriptDirPath}`
currentDateTime=`date +"%Y-%m-%d_%H%M%S"`

echo "Linux configs are located in '${realScriptDirPath}'"

[[ "$@" = '--force' ]] && force=true || force=false

# ------------ BASH
if [[ ${force} = true ]]; then
    if [[ -f ~/.bashrc ]]; then
        echo "Backup '~/.bashrc'"

        newFilePath="${HOME}/.bashrc-${currentDateTime}.bak"
        mv ~/.bashrc ${newFilePath}

        echo "File '~/.bashrc' backuped in '${newFilePath}'"
    fi
else
    if [[ -f ~/.bashrc ]]; then
        echo "File '~/.bashrc' is already exists."
        echo "Run this command with '--force' option to backup and overwrite it"
    fi
fi

echo "source ${realScriptDirPath}/bash/.bashrc" > ~/.bashrc

# ------------ SCREEN
if [[ ${force} = true ]]; then
    if [[ -f ~/.screenrc ]]; then
        echo "Backup '~/.screenrc'"

        newFilePath="${HOME}/.screenrc-${currentDateTime}.bak"
        mv ~/.screenrc ${newFilePath}

        echo "File '~/.screenrc' backuped in '${newFilePath}'"
    fi
else
    if [[ -f ~/.screenrc ]]; then
        echo "File '~/.screenrc' is already exists."
        echo "Run this command with '--force' option to backup and overwrite it"
    fi
fi

echo "source ${realScriptDirPath}/screen/.screenrc" > ~/.screenrc

# ------------ VIM
if [[ ${force} = true ]]; then
    if [[ -f ~/.vimrc ]]; then
        echo "Backup '~/.vimrc'"

        newFilePath="${HOME}/.vimrc-${currentDateTime}.bak"
        mv ~/.vimrc ${newFilePath}

        echo "File '~/.vimrc' backuped in '${newFilePath}'"
    fi
else
    if [[ -f ~/.vimrc ]]; then
        echo "File '~/.vimrc' is already exists."
        echo "Run this command with '--force' option to backup and overwrite it"
    fi
fi

echo "source ${realScriptDirPath}/vim/.vimrc" > ~/.vimrc

# ------------ GIT
git config --global --add --path include.path "${realScriptDirPath}/git/.gitconfig"

