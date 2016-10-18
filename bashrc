# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=always'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=always -riIn'
    alias fgrep='fgrep --color=always'
    alias egrep='egrep --color=always'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

################
# Custom changes
################

# Inspiration from
# - http://justinlilly.com/dotfiles/zsh.html

# Figure out where the dotfiles are located.
# http://stackoverflow.com/a/246128

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DOT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Alias definitions.
if [ -f "$DOT_DIR"/shell_aliases ]; then
    . "$DOT_DIR"/shell_aliases
fi

# Color the prompt depending on what host we are on.
# Lets make it absolutely clear when we are on Live
# and needs to be super careful.

HOSTNAME=`hostname`
if [ "$HOSTNAME" = "ubuntu" ] || [ "$HOSTNAME" = "of-pc-3" ] ; then
  # Local boxes. Blue
  PS1="\[$(tput bold 5)\]\[$(tput setaf 4)\]$PS1\[$(tput sgr0)\]"
elif [[ $HOSTNAME = of* ]]; then
  # Reincubate other office. Cyan
  PS1="\[$(tput bold 5)\]\[$(tput setaf 6)\]$PS1\[$(tput sgr0)\]"
elif [[ $HOSTNAME = lo* ]] || [[ $HOSTNAME = nj* ]]; then
  # Reincubate Live Boxes. Red.
  PS1="\[$(tput bold 5)\]\[$(tput setaf 1)\]$PS1\[$(tput sgr0)\]"
elif [[ $HOSTNAME = letsgo* ]] || [[ $HOSTNAME = nj* ]]; then
  # Letsgo Live Boxes. Red.
  PS1="\[$(tput bold 5)\]\[$(tput setaf 1)\]$PS1\[$(tput sgr0)\]"
elif [[ $HOSTNAME = ocean* ]]; then
  # Personal Live boxes. Magenta
  PS1="\[$(tput bold 5)\]\[$(tput setaf 5)\]$PS1\[$(tput sgr0)\]"
elif [[ $HOSTNAME = pi-* ]]; then
  # Raspberry pi box. Magenta
  PS1="\[$(tput bold 5)\]\[$(tput setaf 5)\]$PS1\[$(tput sgr0)\]"
else
  # Unknown. Yellow.
  PS1="\[$(tput bold 5)\]\[$(tput setaf 3)\]$PS1\[$(tput sgr0)\]"
fi

# Print a fortune at shell startup
have_fortune=`which fortune`
if [ -e have_fortune ]; then
    echo ""
    fortune
    echo ""
fi

PATH=$PATH:~/dotfiles/bin/

# Add autojump
if which autojump &> /dev/null; then
  . /usr/share/autojump/autojump.bash
fi

# Run the
PYTHONSTARTUP=~/.pythonrc.py
export PYTHONSTARTUP
