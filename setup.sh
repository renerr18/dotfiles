#!/bin/sh

if [ "$CODESPACES" = "true" ]; then
    # Source dotfiles for bash.
    persistedBash="/workspaces/.codespaces/.persistedshare/dotfiles/bashrc"
    if [ -e persistedBash ]; then 
        echo "source $persistedBash" >> $HOME/.bashrc  
    fi

    # Source dotfiles for zsh.
    persistedZsh="/workspaces/.codespaces/.persistedshare/dotfiles/rc"
    if [ -e persistedZsh ]; then 
        echo "source $persistedZsh" >> $HOME/.zshrc
    fi

    # Apt installs
    sudo apt update -y
    sudo apt install -y socat inetutils-ping telnet shellcheck vim

    # Default to ZSH
    sudo chsh -s /usr/bin/zsh

    # copy all aliases over
    cat aliases/* >> ~/.zshrc
    cat aliases/* >> ~/.bashrc

    # Copy over workspace config    
    cp vscode/code-workspace  /workspaces/$(ls /workspaces)/.code-workspace
    
    if [ -d "/workspaces/groups" ]; then      
      # Expose Redis to local 
      socat TCP4-LISTEN:6379,reuseaddr,fork TCP:customink-redis:6379 &

      # Expose MySQL to local
      socat TCP4-LISTEN:3306,reuseaddr,fork TCP:customink-mysql57:3306 &  
    fi    
fi
