# If not running interactively, don't do anything

case $- in
    *i*) ;;
      *) return;;
esac

## Fzf + Rg
export FZF_DEFAULT_COMMAND="fdfind --type f --hidden"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Fzf completion when typing in ** doesn't use $FZF_DEFAULT_COMMAND. The below
# is necessary.
_fzf_compgen_path() {
  command fdfind . --hidden "$1" 2>/dev/null
}
_fzf_compgen_dir() {
  command fdfind . --type d --hidden "$1" 2>/dev/null
}


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Expand shell variables on bash-compleition
shopt -s direxpand

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# With this, multiline commands are not translated into semicolon-separated
# commands before being written to history.
shopt -s lithist

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# Enable autocomplete for aliases:
# https://unix.stackexchange.com/questions/4219/how-do-i-get-bash-completion-for-command-aliases
source ~/.bash_completion.d/complete_alias

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# This sourcing needs to happen strictly after the block above for
# ** completion to not malfunction in cases like cd **, cp ** (probably
# they have something in common)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Some systems still have old vi by default
alias vi=vim

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
	[ -s "$BASE16_SHELL/profile_helper.sh" ] && \
	eval "$("$BASE16_SHELL/profile_helper.sh")"

# UTF8 issues
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
alias tmux='tmux -u'

# Ptpython vim
alias ptpython='ptpython --vi'
# I don't know where this is getting set, but I need to unset it
export PYTHONPATH=
export PYTHONBREAKPOINT=ipdb.set_trace

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history


# Scripts in dotfiles/bin/
for bin_dir in {$HOME/git/dotfiles/bin,$HOME/.local/bin}; do
	if [[ -d "$bin_dir"  ]]; then
	    export PATH=$bin_dir:$PATH
	fi
done

# Source customizations that differ across machines
if [[ -f ~/.bashrc_specific  ]]; then
    source ~/.bashrc_specific
    :
fi

# Show virtual env in custom prompt
# https://stackoverflow.com/a/20026992
function virtualenv_info(){
    # Get Virtual Env
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Strip out the path and just leave the env name
        venv="${VIRTUAL_ENV##*/}"
    else
        # In case you don't have one activated
        venv=''
    fi
    [[ -n "$venv" ]] && echo "(venv:$venv) "

} 
# disable the default virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1 

# Color prompt according to exit code: https://stackoverflow.com/a/16715681
PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

# https://tldp.org/HOWTO/Xterm-Title-4.html
ppwd () 
{ 
    echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"
}

set_ps1() {
    local EXIT="$?"             # This needs to be first
    VENV="\$(virtualenv_info)";


    local RCol='\[\e[0m\]'

    local Red='\[\e[0;31m\]'
    local Gre='\[\e[0;32m\]'
    local BBlu='\[\e[1;34m\]'

    PS1="${Gre}$VENV\u@\h:"
    if [ $EXIT != 0 ]; then
        PS1+="${Red}\w\$ ${RCol}"      # Add red if exit code non 0
    else
        PS1+="${BBlu}\w\$ ${RCol}"
    fi
    PS1="$PS1"
    ppwd
}

auto_change_venv() {
  # Check all parents from $PWD until /
  parent="$PWD"
  found_venv=0
  while  ((${#parent} > 1 )); do
    if [ -d "$parent/.venv" ]; then
      found_venv=1
      break
    fi
    parent=${parent%/*} # (shortest match) parameter subsiution ${param%word}
  done
  if [ $found_venv = 0 ]; then
    return
  fi
  if [ -n "$VIRTUAL_ENV" ]; then
    deactivate;
  fi;

  # shellcheck disable=SC1090
  source "$parent/.venv/bin/activate";
}

__prompt_command() {
  set_ps1 # This needs to be first to change color based on return value
  auto_change_venv
}



export EDITOR=nvim

# Define a shortcut to copy to clipboard
alias copy="xclip -selection clipboard"

# Attach to "def" (for default) tmux session if it already exists
tmux attach -t def &> /dev/null

# Create a session if not
if [[ $? != 0 && ! $TERM =~ screen ]]; then
    tmux new -s def
fi

## Aliases
# Taskwarrior 
alias t=task
complete -F _complete_alias t 
alias tw=timew
complete -F _complete_alias tw
alias x=xsv
complete -F _complete_alias x
alias xs="xsv select"
alias xh="xsv headers" 
# lowercase
alias lower="tr '[:upper:]' '[:lower:]'"
alias bat=batcat
alias fd=fdfind
complete -F _complete_alias fd

alias bash="bash --noprofile"