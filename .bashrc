# if test -f /etc/profile.d/git-sdk.sh
# then
# 	TITLEPREFIX=SDK-${MSYSTEM#MINGW}
# else
# 	TITLEPREFIX=$MSYSTEM
# fi

# affiche dans quelle branche Git on se trouve
# parse_git_branch() {
#      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
# }


# if test -f ~/.config/git/git-prompt.sh
# then
# 	. ~/.config/git/git-prompt.sh
# else
	# PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]' # set window title
	PS1='\[\033]0;$PWD\007\]' # set window title
	# PS1="$PS1"'\n'                 # new line
	PS1="$PS1"'\[\033[33m\]'       # change to green
	# PS1="$PS1"'\u@\h'             # user@host<space>
	#PS1="$PS1"'\[\033[37m\]'       # change to purple
	#PS1="$PS1"'$MSYSTEM '          # show MSYSTEM
	# PS1="$PS1"'\[\033[1;95m\]'       # change to brownish yellow
	PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
	PS1="$PS1"'\w'                 # current working directory
	# PS1="$PS1"'$parse_git_branch' # appel à parse_git_branch
	if test -z "$WINELOADERNOEXEC"
	then
		GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
		COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
		COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
		COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
		if test -f "$COMPLETION_PATH/git-prompt.sh"
		then
			. "$COMPLETION_PATH/git-completion.bash"
			. "$COMPLETION_PATH/git-prompt.sh"
			PS1="$PS1"'\[\033[36m\]'  # change color to cyan
			PS1="$PS1"'`__git_ps1`'   # bash function
		fi
	fi
	PS1="$PS1"'\[\033[0m\]'        # change color
	PS1="$PS1"'\n'                 # new line
	PS1="$PS1"'$ '                 # prompt: always $
# fi

MSYS2_PS1="$PS1"               # for detection by MSYS2 SDK's bash.basrc


# Uncomment to use the terminal colours set in DIR_COLORS
eval "$(dircolors -b /etc/DIR_COLORS)"


alias ll='ls -alF --color=auto --show-control-chars'


# mise en place du ssh-agent
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

#ssh-add ~/.ssh/gitlabkey

#ssh-add ~/.ssh/githubkey


# définit le répertoire home et se place dedans au démarrage
# HOME=/c/10_GIT
#cd ~

# HOME=/c/10_GIT/Colis

alias cdd='cd /c/10_GIT/Colis'

# cd /c/10_GIT/Colis

lns() {
        # lns: ln -s for absent-minded people, English edition
        # Under the WTFPL license

        if [ "$#" -ne 2 ]; then
                echo 'lns expects two parameters: the name of the link, and the pointed object, in any order.'
                echo 'lns calls ln -s $target $linkname.'
                echo 'The pointed object must exist, and should be an absolute path, unless you know what you are doing.'
        else
                if [ -e "$1" ]; then
                        target=$1
                        linkName=$2
                elif [ -e "$2" ]; then
                        target=$2
                        linkName=$1
                else
                        echo "None of the parameters reference an existing object."
                        return
                fi

                ln -s "$target" "$linkName"
        fi
}

# disable flashing screen
# set bell-style none