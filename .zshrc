# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
if [[ "$CODESPACES" = "true" ]]; then
  ZSH_THEME="zhann"
else
  ZSH_THEME="robbyrussell"
fi

# Other themes I like (best first)
#ZSH_THEME="agnoster" # if using a dark terminal
#ZSH_THEME="spaceship" # prompt too far left - neck strain - but shows icon for stashes

DEFAULT_USER="sam"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Other config from dotfiles
source $HOME/.zshrc-includes/add-to-path
source $HOME/.zshrc-includes/colourful-man-pages

# Stop pasted text being highlighted
# https://unix.stackexchange.com/questions/331850/zsh-selects-a-pasted-text
unset zle_bracketed_paste

# https://github.com/Bilalh/shellmarks
source ~/.local/bin/shellmarks.sh

# A place for config that we don't want to save into dotfiles
source $HOME/.zshrc-includes/machine-specific-config

# Things specific to my work setup
source $HOME/.zshrc-includes/work-config

if [[ "$OSTYPE" != "darwin"* ]]; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

# Codespaces don't have a way of making sound, but having a command
# to make a sound is useful for knowing when things have finished.
# Adapted from https://superuser.com/a/1274810/126533
# The command to run locally is `while true; do nc -l 2900 | say; done`
if [[ "$CODESPACES" = "true" ]]; then
  alias say="bash -c \"printf 'done' >> /dev/tcp/localhost/2900\""
fi

export EDITOR=nano
export VISUAL="$EDITOR"

if [[ "$CODESPACES" = "true" ]]; then
  if [ -z "$(git config --get core.editor)" ] && [ -z "${GIT_EDITOR}" ]; then
    if  [ "${TERM_PROGRAM}" = "vscode" ]; then
        if [[ -n $(command -v code-insiders) &&  -z $(command -v code) ]]; then
            export GIT_EDITOR="code-insiders --wait"
        else
            export GIT_EDITOR="code --wait"
        fi
    fi
  fi
fi

# If rbenv is installed, ensure that it's in the path and initialised
if [ -x "$(command -v rbenv)" ]; then
  echo $PATH | grep rbenv >/dev/null || export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# Stop zsh trying to intercept the ^ in e.g. `git show HEAD^`
# https://github.com/ohmyzsh/ohmyzsh/issues/449#issuecomment-1466968
unsetopt extendedglob

# Make it faster
# https://github.com/zsh-users/zsh-autosuggestions/issues/544
# https://github.com/zsh-users/zsh-autosuggestions?tab=readme-ov-file#disabling-automatic-widget-re-binding
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
