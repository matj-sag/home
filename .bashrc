# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
    
    if [[ $TERM != "DUMB" ]]; then case `uname` in
      "SunOS")
         FEATURES=disable
         TERM=xterm
         export $TERM
         alias ls='ls -F' 
         alias psa='ps -ef'
         ;;
      "IRIX")
         alias ls='ls -F' 
         alias psa='ps -ef'
         ;;
      "Linux")
         eval `dircolors -b`
         alias ls='ls --color=auto'
         alias psa='ps aux'
         ;;
      "GNU")
         eval `dircolors -b`
         alias ls='ls --color=auto'
         alias psa='ps aux'
         ;;
      "GNU/kFreeBSD")
         eval `dircolors -b`
         alias ls='ls --color=auto'
         alias psa='ps aux'
         ;;
    esac ; fi


# If running interactively, then:
if [ "$PS1" ]; then
    
    # machine-specifics
    HOST=`hostname`
    if [ -f $HOME/.bashrc-$HOST ]
    then 	
     	 source .bashrc-$HOST
    fi

	 HISTTIMEFORMAT="%h/%d - %H:%M:%S "
   
    # some more ls aliases
    alias ll='ls -l'
    alias la='ls -A'
    alias close='eject -t'
    alias svim='sudo vim -X'
    alias sgvim='sudo gvim'
    alias vim='vim -X'
    alias xterm='xterm -bg black -fg white'
    alias cdd='cd'
    alias note='cat > /dev/null'
    alias swerrout='3>&2 2>&1 1>&3'
    alias rn='ls'
    alias changelogcommit="git status -v changelog | grep ^+ | git commit -a -e -F -"
    alias rls='ls | head -n $(( $RANDOM % `ls | wc -l` + 1)) | tail -n1'
	 alias cd='pushd $PWD;popd +20 -n&>/dev/null || true;cd'
	 alias mine='psa | grep $USER'
	 alias svnls='svn ls'
	 alias tt='/tools/apama-util/scripts/testing/testtriage.py'

	function addup()
	{
		cat | sed '1s/^/8k /;2,$s/$/ +/;$s/$/ p/' | dc
	}

	function xpy()
	{
		if [ -f /var/tmp/mjj29/xpybuild-git/xpybuild.py ]; then
			/var/tmp/mjj29/xpybuild-git/xpybuild.py "$@"
		else
			./xpybuild.py "$@"
		fi
	}

	
	function svncd()
	{
		if [ -z "$1" ]; then
			echo "Usage: svncd <directory>"
			return
		fi
		if [ "." = "$1" ]; then
			return
		fi
		svncd "`dirname "$1"`"
		DIR="`basename "$1"`"
		if [ -e "$DIR" ]; then
			cd "$DIR"
		else
			svn -q up -N "$DIR" && cd "$DIR"
		fi
	}
	 
	function t()
	{
		export task=$1
	}
	function fgrep()
	{
		pat="$1"
		shift
		unset paths
		while [ -n "$1" ] && [ "${1:0:1}" != "-" ] && [ "${1}" != "(" ]; do
			paths="$paths $1"
			shift
		done
		if [ -z "$paths" ]; then
			paths=.
		fi
		if [ "`uname`" != "SunOS" ]; then
			if [ -z "$1" ]; then
				set -x
				find $paths -not -path '*/output-*/*' -and -not -path '*/.svn/*' -and -type f -print0 | xargs -0 grep -i "$pat"
				set +x
			else 
				set -x
				find $paths -not -path '*/output-*/*' -and -not -path '*/.svn/*' -and -type f -and "$@" -print0 | xargs -0 grep -i "$pat"
				set +x
			fi
		else
			if [ -z "$1" ]; then
				set -x
				find $paths -not -path '*/output-*/*' -and -not -path '*/.svn/*' -and -type f | xargs grep -i "$pat"
				set +x
			else 
				set -x
				find $paths -not -path '*/output-*/*' -and -not -path '*/.svn/*' -and -type f -and "$@" | xargs grep -i "$pat"
				set +x
			fi
		fi
	}
	function tests () 
	{ 
		ps aux | grep "^`whoami`.*correlator -l" | awk '{print $2}' | while read i
			do 
				echo -n "$i: "
				readlink -f /proc/$i/cwd | sed 's,.*\(testcases/[a-z]*\|testresults\)/\([^/]*\)/.*,\2,'
			done 
	}
    
    # set a fancy prompt
    if [ $TERM != "dumb" ] && [ -f $HOME/.magicprompt.bash ]; then
		. $HOME/.magicprompt.bash
    else
      PS1='\u@\h:\w \$'
    fi
	 
	 . $HOME/.makepath.sh

    # PATH
    if [[ "`uname`" = "IRIX" ]];
    then
       export PATH=/usr/freeware/bin:$PATH:$HOME/bin:/usr/bin/jdk:$HOME/Docs/programming/c/bin:/usr/etc/
    fi

    # bash completion
    if test -f /etc/bash_completion
    then
       . /etc/bash_completion
    fi

    # SFS agent
    if test -x /usr/bin/sfsagent
    then if ! psa | grep sfsagent | grep mjj29 | grep -v grep > /dev/null
    then
      if test -f $HOME/.sfs/identity
      then
         sfsagent >/dev/null
         . $HOME/.sfs/certprogs
      fi
    fi
    fi

    # GPG agent
    GPG_TTY=`tty`
    export GPG_TTY

    # SSH agent
    if [[ "`uname -n`" == "illythia" || "`uname -n`" == "ianthe" ]]; then
       keychain --quiet $HOME/.ssh/id_rsa  $HOME/.ssh/identity E62FA358
       . $HOME/.keychain/illythia-sh
       . $HOME/.keychain/illythia-sh-gpg
    elif test -x "`which keychain`"
    then
		if [ -f $HOME/.ssh/id_rsa ]; then
			 keychain --quiet $HOME/.ssh/id_rsa
		else
			 keychain --quiet
		fi
       . $HOME/.keychain/`uname -n`-sh
       . $HOME/.keychain/`uname -n`-sh-gpg
    fi

    if [ -f "$HOME/.otpw" ]; then
       if (( $(( `wc -l < $HOME/.otpw` - `grep -c ^--- $HOME/.otpw` - 2 )) < 25 )); then 
          echo -e "[01;25mWarning, only [01;31m$(( `wc -l < $HOME/.otpw` - `grep -c ^--- $HOME/.otpw` - 2 ))[01;37m OTPs remaining[00m"; 
       fi
    fi

if [ "`uname`" = "SunOS" ]; then
	export PAGER=more
else
	if which vim 2>/dev/null | grep ^/ >/dev/null ; then
		 export EDITOR=vim
		 export PAGER="sh -c 'sed s/.//g | view -'"
	elif which less 2>/dev/null | grep ^/ >/dev/null ; then
		 export EDITOR=vi
		 export PAGER="less"
	fi
fi
    export DEBEMAIL=mjj29@debian.org
    export LOCKPRG=/usr/bin/vlock
    export QUILT_PATCHES=debian/patches

# apama stuff
export AP_ASCII_COLOURS=true
export AP_IGNORE_MISSING_TEST_DIRS=true
export APB_SKIP_VERSION=true
export XPYBUILD_WORKERS_PER_CPU=0.2
if [ "$TERM" == "rxvt-unicode" ]; then export TERM=rxvt; fi
fi
    # env vars
# setup autolock   
#if test "$AUTOLOCK"="true";
#then
#   xautolock
#fi
