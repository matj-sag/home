PROMPTMODE=3 #0=basic, 1=standard, 2=coloured, 3=multi-line

export GRAY="\[\033[1;30m\]"
export LIGHT_GRAY="\[\033[0;37m\]"
export CYAN="\[\033[1;36m\]"
export WHITE="\[\033[1;37m\]"
export GREEN="\[\033[1;32m\]"
export RED="\[\033[1;31m\]"
export NO_COLOUR="\[\033[0m\]"

export LIGHT_BLUE="\[\033[1;34m\]"
export YELLOW="\[\033[1;33m\]"

# hash the hostname to get a colour
if [ -z "$hostcolour" ]; then
	hcdata="$HOSTNAME `uname -a`"
	hcdata2="$hcdata"
	sum=0
	while [ -n "$hcdata2" ]; do
		case "${hcdata2:0:1}" in
			0|1|2|3|4|5|6|7|8|9)
				sum=$(( $sum + ${hcdata2:0:1} ))
			;;
		esac
		hcdata2=${hcdata2:1}
	done
	hostcolour="\[\033[1;3$(( ( ${#hcdata} + ${sum} ) % 10 ))m\]"
fi
export hostcolour

unset task
if [ -x /usr/bin/lsb_release ]; then
	uname="`lsb_release -s -i` `uname -m`"
else
	uname="`grep ^NAME= /etc/os-release | cut -d'"' -f2` `uname -m`"
fi
if [ -x /usr/bin/whoami ]; then
	USER=`whoami`
fi

function t()
{
	unset svntask
	export task=$1
}

parse_svn_repository_root() {
   local LD_LIBRARY_PATH= 
	svn info 2>/dev/null | sed -ne '/^Repository Root/s#^Repository Root: *\(.*\)#\1\/#gp'
}

parse_svn() {
   local LD_LIBRARY_PATH= 
	unset IFS
	sed 's/ /@/' <<< $(echo `svn info 2>/dev/null | egrep '^(URL|Revision)' | sed -ne 's,analyticskit/branches/,branches/ak:,;/^Revision/s/.*: //p;/^URL/s#^URL: '"$(parse_svn_repository_root)"'*[^/]*/\([^/]*\)/\([^/]*\).*$#\1/\2#p'` )
}

function title {
	if [ "${TMUX}" != "" ]; then
		# tmux
		echo -en "\033]2;<${hostnam}> [$prompttask] ($rc): $last\033\\"
	elif [ "${TERM/screen/}" != "${TERM}" ]; then
		# also tmux, to deal with ssh from inside tmux. Sorry screen users
		echo -en "\033]2;<${hostnam}> [$prompttask] ($rc): $last\033\\"
		# screen
		# echo -en "\033k<${hostnam}> [$prompttask] ($rc): $last\033\\"
	else
		# xterm
		echo -en "\033]2;<${hostnam}> [$prompttask] ($rc): $last\007"
	fi
}

function rc {
   local LD_LIBRARY_PATH= 
	unset IFS
	export rc=`cut -d: -f1 <<< $rcinput`
	export last=`cut -d: -f2- <<< $rcinput`
}

if [ -f "$HOME/bin/git-prompt.sh" ]; then
	. "$HOME/bin/git-prompt.sh" 
fi

function vcs {
	local LD_LIBRARY_PATH= 
	if ([ -d .svn ] && which svn 2>/dev/null | grep ^/ >/dev/null) || (which svn 2>/dev/null | grep ^/ >/dev/null && svn info &>/dev/null); then
		svndata=`parse_svn`
		vcsprompt="(svn:$svndata) "
		if egrep '/apama-(src|test|build)($|/)' <<< $PWD &> /dev/null; then
			export svntask="`sed 's,.*/\(.*\)@.*,\1,' <<< $svndata`-`sed 's,.*/[^/]*/apama-\([^/]*\).*,\1,' <<< $PWD`"
		elif egrep '^ak:' <<< $svndata &> /dev/null; then
			export svntask="`sed 's,.*/\(.*\)@.*,\1,' <<< $svndata`"
		fi
	else
		vcsprompt="`__git_ps1 "(git:%s) " 2>/dev/null || true`"
		if egrep '/apama-(src|test|build)($|/)' <<< $PWD &> /dev/null; then
			export svntask="`sed 's,.*/\(.*\),\1,' <<< $(__git_ps1 "%s")`-`sed 's,.*/[^/]*/apama-\([^/]*\).*,\1,' <<< $PWD`"
		else
			export svntask="`__git_ps1 "%s"`"
		fi
	fi
	if [ -z "$vcsprompt" ]; then
		vcsprompt='(\A) '
	fi
}

function prompt_command {
   local LD_LIBRARY_PATH= 
	if [ "0" == "$rc" ] && [ "$rccolor" == "$RED" ]; then
		rccolor=$YELLOW
	elif [ "0" == "$rc" ]; then
		rccolor=$GREEN
	else
		rccolor=$RED
	fi

	TERMWIDTH=${COLUMNS}

	#   Calculate the width of the prompt:

	hostnam=`cut -d . -f 1 <<< $HOSTNAME`
	if [ -z "$hostnam" ]; then hostnam=$HOSTNAME; fi
	#   "whoami" and "pwd" include a trailing newline
	usernam=${USER}
	let usersize=${#usernam}
	newPWD="${PWD}"
	let pwdsize=${#newPWD}
	#   Add all the accessories below ...
	tempprompt="--(${usernam}@${hostnam}:${uname})---(${newPWD})--"
	let promptsize=${#tempprompt}
	let fillsize=${TERMWIDTH}-${promptsize}
	fill=""
	while [ "$fillsize" -gt "0" ] 
	do 
		fill="${fill}-"
		let fillsize=${fillsize}-1
	done

	if [ "$fillsize" -lt "0" ]
	then
		let cut=3-${fillsize}
		newPWD="...`sed -e "s/\(^.\{$cut\}\)\(.*\)/\2/" <<< ${newPWD}`"
	fi
	
	if [ -n "$task" ]; then
		prompttask="$task"
	elif [ -n "$svntask" ]; then
		prompttask="$svntask"
	else
		prompttask="`basename "$PWD"`"
	fi

	if [ "root" == "$usernam" ]; then
		export usercolor=$RED
	else
		export usercolor=$WHITE
	fi

}

unset ps1
unset PS1
unset PROMPT_COMMAND

# basic
if [[ "$PROMPTMODE" == "0" ]]; then
PS1="\u@\h:\w\$ "

# normal
elif [[ "$PROMPTMODE" == "1" ]]; then

function ps1 {
PS1="=${rc} [${prompttask}] \u@\h:\w\$ "
}
PROMPT_COMMAND='export rcinput=$?:$_;rc;title;prompt_command;vcs;ps1'

# single-line color
elif [[ "$PROMPTMODE" == "2" ]]; then

function ps1 {
PS1="$YELLOW=${rcolor}${rc} $LIGHT_BLUE[$NO_COLOUR${prompttask}$LIGHT_BLUE] \
${usercolor}\${usernam}${hostcolour}@\${hostnam}${GRAY}:\\w$LIGHT_BLUE\\\$$NO_COLOUR "
}
PROMPT_COMMAND='export rcinput=$?:$_;rc;title;prompt_command;vcs;ps1'

# multi-line  (PROMPTMODE=3)
else

function ps1 {
PS1="$YELLOW-$LIGHT_BLUE-(\
${usercolor}\${usernam}${hostcolour}@\${hostnam}${GRAY}:${CYAN}${uname}\
${LIGHT_BLUE})-${GRAY}-\${fill}${LIGHT_BLUE}-(\
$NO_COLOUR\${newPWD}\
$LIGHT_BLUE)-$YELLOW-\
\n\
 =${rccolor}${rc}$LIGHT_BLUE [$NO_COLOUR${prompttask}$LIGHT_BLUE]$YELLOW "'\!'"$CYAN ${vcsprompt}$LIGHT_BLUE"'\$'"\
$NO_COLOUR "
}
PROMPT_COMMAND='export rcinput=$?:$_;rc;title;prompt_command;vcs;ps1'

fi
