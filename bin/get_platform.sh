#  $Copyright(c) 2005-2006, 2008 Progress Software Corporation (PSC). All rights reserved.$
#
# Shell script fragment to define the mapping from APAMA_MACHTYPE to
# APAMA_LIBTYPE and APAMA_BUILDTYPE.  Should be sourced by another script
# that can then read the values of the APAMA_LIBTYPE and APAMA_BUILDTYPE
# shell variables.
#
# If APAMA_MACHTYPE is not set it will default to the string "unknown".
# If APAMA_MACHTYPE does not match any known value, both APAMA_LIBTYPE
# and APAMA_BUILDTYPE will be set to the value of APAMA_MACHTYPE.
#
# $Id: get_platform.sh 95669 2008-12-09 22:18:24Z kdillon $
#

#
# We can no-longer assume this!
#
if [ "$APAMA_MACHTYPE" = "" ] && [ "$OS" = "Windows_NT" ]; then
   echo ""
   echo "Howdy doodly do. How's it going? I'm Talkie, Talkie Toaster, your chirpy breakfast"
   echo "companion. Talkie's the name, toasting's the game. Anyone like any toast?"
   echo ""
   echo "You did not set APAMA_MACHTYPE. If you aren't sure why the build is"
   echo "suddenly failing, you should probably just run this command and try again:"
   echo ""
   echo "export APAMA_MACHTYPE=ia32-win32-msvc9"
   echo ""
   echo "If you are trying to build on Windows 64 you should set a different value."
   echo "The currently supported values are:"
   echo ""
   echo "ia32-win32-msvc9 or amd64-win64-msvc9"
   echo ""
   echo "If, of course, you _did_ set one of those values then it's probably due to"
   echo "techtonic stress."
   exit 1
fi

if [ "$APAMA_MACHTYPE" = "" ]; then
    APAMA_MACHTYPE=unknown
fi

APAMA_LIBTYPE=unknown
APAMA_BUILDTYPE=unknown

case "$APAMA_MACHTYPE" in

# TODO: Maybe split off SLES9 so it gets it's own cert type

#suse 10 32 bit
ia32-suse10-linux2.6-gnu2.4-gcc4.1.*)
    APAMA_LIBTYPE=ia32-rhel4-linux-gnu3.4.6
    APAMA_BUILDTYPE=ia32-rhel4-linux-gnu
    APAMA_CERTTYPE=ia32-suse10-linux-gnu
;;

#red hat 5 32 bit
ia32-rhel5-linux2.6-gnu2.5-gcc4.1.*)
    APAMA_LIBTYPE=ia32-rhel4-linux-gnu3.4.6
    APAMA_BUILDTYPE=ia32-rhel4-linux-gnu
    APAMA_CERTTYPE=ia32-rhel5-linux-gnu
;;


ia32-rhel3-linux2.4-gnu2.3-gcc3.2.* | ia32-sles9-linux2.6-gnu2.3-gcc3.3.*)
    APAMA_LIBTYPE=ia32-rhel3-linux-gnu3.2.3
    APAMA_BUILDTYPE=ia32-rhel3-linux-gnu
    APAMA_CERTTYPE=ia32-rhel3-linux-gnu
;;


ia32-rhel4-linux2.6-gnu2.3-gcc3.4.*)
    APAMA_LIBTYPE=ia32-rhel4-linux-gnu3.4.6
    APAMA_BUILDTYPE=ia32-rhel4-linux-gnu
    APAMA_CERTTYPE=ia32-rhel4-linux-gnu
;;

ia32-rhel4-linux-gnu3.4.6)
    APAMA_LIBTYPE=ia32-rhel4-linux-gnu3.4.6
    APAMA_BUILDTYPE=ia32-rhel4-linux-gnu
    APAMA_CERTTYPE=ia32-rhel4-linux-gnu
;;

#suse 10 64bit
amd64-suse10-linux2.6-gnu2.4-gcc4.1.*)
    APAMA_LIBTYPE=amd64-rhel4-linux-gnu3.4.6
    APAMA_BUILDTYPE=amd64-rhel4-linux-gnu
    APAMA_CERTTYPE=amd64-suse10-linux-gnu
;;

#red hat 5 64 bit
amd64-rhel5-linux2.6-gnu2.5-gcc4.1.*)
    APAMA_LIBTYPE=amd64-rhel4-linux-gnu3.4.6
    APAMA_BUILDTYPE=amd64-rhel4-linux-gnu
    APAMA_CERTTYPE=amd64-rhel5-linux-gnu
;;

amd64-rhel3-linux2.4-gnu2.3-gcc3.2.*)
    APAMA_LIBTYPE=amd64-rhel3-linux-gnu3.2.3
    APAMA_BUILDTYPE=amd64-rhel3-linux-gnu
    APAMA_CERTTYPE=amd64-rhel3-linux-gnu
;;

amd64-rhel4-linux2.4-gnu2.3-gcc3.2.*)
    APAMA_LIBTYPE=amd64-rhel3-linux-gnu3.2.3
    APAMA_BUILDTYPE=amd64-rhel3-linux-gnu
    APAMA_CERTTYPE=amd64-rhel4-linux-gnu
;;

amd64-rhel4-linux-gnu3.4.6)
    APAMA_LIBTYPE=amd64-rhel4-linux-gnu3.4.6
    APAMA_BUILDTYPE=amd64-rhel4-linux-gnu
    APAMA_CERTTYPE=amd64-rhel4-linux-gnu
;;

amd64-rhel4-linux2.6-gnu2.3-gcc3.4.6)
    APAMA_LIBTYPE=amd64-rhel4-linux-gnu3.4.6
    APAMA_BUILDTYPE=amd64-rhel4-linux-gnu
    APAMA_CERTTYPE=amd64-rhel4-linux-gnu
;;

sparc-sun-solaris2.*-studio8)
    APAMA_LIBTYPE=sparc-sun-solaris2.8-forte6r2
    APAMA_BUILDTYPE=sparc-sun-solaris
    APAMA_CERTTYPE=sparc-sun-solaris
;;

sparc-sun-solaris10-studio11)
    APAMA_LIBTYPE=sparc-sun-solaris2.8-forte6r2
    APAMA_BUILDTYPE=sparc-sun-solaris
    APAMA_CERTTYPE=sparc-sun-solaris
;;

amd64-sun-solaris10-studio12)
    APAMA_LIBTYPE=amd64-sun-solaris10-studio12
    APAMA_BUILDTYPE=amd64-sun-solaris
    APAMA_CERTTYPE=amd64-sun-solaris
;;

# Compatibility fallback for Debian/Ubuntu Linux
i?86-pc-linux-gnu)
    APAMA_LIBTYPE=ia32-rhel3-linux-gnu3.2.3
    APAMA_BUILDTYPE=i386-pc-linux-gnu
    APAMA_CERTTYPE=i386-pc-linux-gnu
;;

# Windows
i586-win32-msvc7.1)
	echo ""
	echo "Fry, as you know, there are lots of things I'm willing to kill for... jewels, vengeance, Father O'Mallee's weed-whacker. "
	echo "But at long last I've found something I'm willing to die for... this mindless turtle."
	echo ""
	echo "You have set your APAMA_MACHTYPE to i586-win32-msvc7.1. This is no longer supported "
	echo "in Aztec. The correct APAMA_MACHTYPE for 32bit Windows is now:"
	echo
	echo "   ia32-win32-msvc9"
	echo
	echo "Please reset APAMA_MACHTYPE to this value and try again."
	echo
	echo "Of course, you may have already done this, in which case it might be because the firewall needs cooling."
	exit 1

;;
ia32-win32-msvc9)
    APAMA_LIBTYPE=ia32-win32-msvc9
    APAMA_BUILDTYPE=ia32-win32-msvc9
    APAMA_CERTTYPE=ia32-win32-msvc9
;;
amd64-win64-msvc9)
    APAMA_LIBTYPE=amd64-win64-msvc9
    APAMA_BUILDTYPE=amd64-win64-msvc9
    APAMA_CERTTYPE=amd64-win64-msvc9
;;
# Default
*)
    APAMA_LIBTYPE="$APAMA_MACHTYPE"
    APAMA_BUILDTYPE="$APAMA_MACHTYPE"
    APAMA_CERTTYPE="$APAMA_MACHTYPE"
;;

esac

# Prints the path under apama-lib2 to install third parties based on APAMA_MACHTYPE and
# some parameters (you only need to set one of these):
#
# Options:
#		SYSTEM_I=all			- works on any architecture, operating system and compiler
#		ARCH_I=all				- specific to one OS, but any architecture
#		COMPILER_I=all       - not specific to any compiler, but is OS/arch specific
#
# Usage: [options] get_install_path
get_install_path() {
	if [ -z "$APAMA_LIBTYPE" ]; then
		echo "Error: APAMA_MACHTYPE is unset." 1>&2
		return 1
	fi

	if [ -n "$SYSTEM_I" ]; then
		echo "all"
		return 0;
	elif [ "" != "`echo $APAMA_LIBTYPE | sed -n '/-linux/p'`" ]; then
		IPATH="linux"
	elif [ "" != "`echo $APAMA_LIBTYPE | sed -n '/-win[0-9]/p'`" ]; then
		IPATH="win"
	elif [ "" != "`echo $APAMA_LIBTYPE | sed -n '/-solaris/p'`" ]; then
		IPATH="sunos"
	fi
	
	if [ -n "$ARCH_I" ]; then
		echo "$IPATH/all"
		return 0;
	elif [ "" != "`echo $APAMA_LIBTYPE | sed -n '/^amd64/p'`" ]; then
		IPATH="$IPATH/amd64"
	elif [ "" != "`echo $APAMA_LIBTYPE | sed -n '/^sparc/p'`" ]; then
		IPATH="$IPATH/sparc32"
	elif [ "" != "`echo $APAMA_LIBTYPE | sed -n '/^ia32/p'`" ]; then
		IPATH="$IPATH/ia32"
	elif [ "" != "`echo $APAMA_LIBTYPE | sed -n '/^i586/p'`" ]; then
		IPATH="$IPATH/ia32"
	fi	
	
	if [ -n "$COMPILER_I" ]; then
		echo "$IPATH/all"
		return 0;
	elif [ "" != "`echo $APAMA_LIBTYPE | sed -n '/msvc9$/p'`" ]; then
		IPATH="$IPATH/msvc9"
	elif [ "" != "`echo $APAMA_LIBTYPE | sed -n '/msvc7.1$/p'`" ]; then
		IPATH="$IPATH/msvc7.1"
	elif [ "" != "`echo $APAMA_MACHTYPE | sed -n '/studio10$/p'`" ]; then
		IPATH="$IPATH/ss10"
	elif [ "" != "`echo $APAMA_MACHTYPE | sed -n '/studio11$/p'`" ]; then
		IPATH="$IPATH/ss11"
	elif [ "" != "`echo $APAMA_MACHTYPE | sed -n '/studio12$/p'`" ]; then
		IPATH="$IPATH/ss12"
	# This grep/sed produces rhel4-gcc3.4.6 from amd64-rhel4-linux2.6-gnu2.3-gcc3.4.6.
	# Should be generic enough to work on any linux/gcc machtype.
	elif [ "" != "`echo $APAMA_LIBTYPE | sed -n '/^[^-]*-[^-]*-linux.*-gcc[\.0-9]*$/p'`" ]; then
		IPATH="$IPATH/`echo $APAMA_LIBTYPE | sed 's/^[^-]*-\([^-]*\)-linux.*-\(gcc[\.0-9]*\)$/\1-\2/'`"
	# Turns out it's not generic enough. 
	# _This_ grep/sed produces rhel4-gcc3.4.6 from ia32-rhel4-linux-gnu3.4.6
	elif [ "" != "`echo $APAMA_LIBTYPE | sed -n '/^[^-]*-[^-]*-linux-gnu[\.0-9]*$/p'`" ]; then
		IPATH="$IPATH/`echo $APAMA_LIBTYPE | sed 's/^[^-]*-\([^-]*\)-linux-gnu\([\.0-9]*\)$/\1-gcc\2/'`"
	else
		echo "Error! could not get apama-lib2 install path from $APAMA_LIBTYPE"
		exit 1
	fi	

	echo "$IPATH"
	unset IPATH
	return 0
}



