# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/usr/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/usr/share/oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# iee https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="flazz"

COMPLETION_WAITING_DOTS="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi
export SYSTEMD_EDITOR="/bin/vim" 

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

source ~/.aliasesrc

DEFAULT_USER=`whoami`
