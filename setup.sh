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
    sudo apt install -y \
        socat inetutils-ping telnet \  # Networking Doodads
        vim shellcheck # Editors and whatnot

    # Default to ZSH
    sudo chsh -s /usr/bin/zsh

    # copy all aliases over
    cat aliases/* >> ~/.zshrc
    cat aliases/* >> ~/.bashrc

    
    if [ -d "/workspaces/groups" ]; then
      # Copy over workspaces settings
      cp vscode/groups.code-workspace  /workspaces/groups/.code-workspace
      
      # Gem installs
      gem install solargraph ruby-debug-ide debase

      # Expose Redis to local 
      socat TCP4-LISTEN:6379,reuseaddr,fork TCP:customink-redis:6379 &

      # Expose MySQL to local
      socat TCP4-LISTEN:3306,reuseaddr,fork TCP:customink-mysl57:3306 &  
    fi    
fi





