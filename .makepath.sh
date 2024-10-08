if [ "`uname`" == "SunOS" ] || [ "`uname`" == "FreeBSD" ]; then
	if grep apama.com /etc/hosts &>/dev/null; then
		cambridge=1
	else
		cambridge=
	fi
else
	if [ "`hostname -d`" == "apama.com" ]; then
		cambridge=1
	else
		cambridge=
	fi
fi

if [ -x $HOME/apama-src/get_ipath ]; then
	ipath=`$HOME/apama-src/get_ipath`
elif [ -x /work/$USER/apama-src/get_ipath ]; then
	ipath=`/work/$USER/apama-src/get_ipath`
elif [ -x /shm/$USER/apama-src/get_ipath ]; then
	ipath=`/dev/shm/$USER/apama-src/get_ipath`
elif [ -x $HOME/bin/get_ipath ]; then
	ipath=`$HOME/bin/get_ipath`
fi

apama_lib=/apama-lib4

buildtime=$apama_lib/$ipath
buildtime_java=$apama_lib/all
runtime=$apama_lib/$ipath
runtime_java=$apama_lib/all

# Build paths for 3rd-party libraries needed to build/run Apama
tao_version=1.5.3-apama3
icu_version=3.8.1
libxml2_version=2.6.23
psepro_version=6.3.0
tao_ld_library_path=$runtime/tao/$tao_version/lib
icu_ld_library_path=$runtime/icu/$icu_version/lib
libxml2_ld_library_path=$buildtime/libxml2/$libxml2_version/lib
psepro_ld_library_path=$buildtime/pse-pro/$psepro_version/lib

# Build paths to 3rd-party Java tools needed to build/run Apama
java_version=jdk1.7.0_25
ant_version=1.7.1
ANT_HOME=$buildtime_java/jakarta-ant/$ant_version
python_version=2.7.13
PYTHON_HOME=$buildtime/python/$python_version
subversion_version=1.9.3
SVN_HOME=$buildtime/../all/subversion/$subversion_version

pysys_version=0.9.1
pysysapama_version=1.3.3

PYTHONPATH=$buildtime_java/pysys/$pysys_version/lib/python2.7/site-packages:$buildtime_java/pysys-apama/$pysysapama_version/lib/python2.7/site-packages

# Platform-specific setup
platform=`uname -s`-`uname -r`-`uname -m`
case $platform in
Linux-*-x86_64)
	tools=/tools/linuxx86_64
	java_arch=amd64
	JAVA_HOME=$tools/java64/$java_version
if [ -n "$cambridge" ]; then
	PATH=$HOME/bin/linux64:$PATH:$tools/bin:/usr/rdl/linuxx86/bin:$HOME/git/linuxx86_64/bin
else
	PATH=$PATH:$tools/bin:/usr/rdl/linuxx86/bin
fi
	;;
Linux-*-i686)
	tools=/tools/linuxx86
	java_arch=i386
if [ -n "$cambridge" ]; then
	PATH=$PATH:$tools/bin:/usr/rdl/linuxx86/bin:$HOME/git/linuxx86/bin:$HOME/bin/linux
else
	PATH=$PATH:$tools/bin:/usr/rdl/linuxx86/bin
fi
	;;
SunOS-*-i86*)
	tools=/tools/solarisx86_64
	java_arch=amd64
	PATH=/usr/dt/bin:$PATH
	PATH=$PATH:$tools/gmake-3.79.1/bin
if [ -n "$cambridge" ]; then
	PATH=$PATH:$tools/bin:/usr/rdl/solarisx86/bin:$HOME/git/solarisx86_64/bin:$HOME/bin/sunos64
else
	PATH=$PATH:$tools/bin:/usr/rdl/solarisx86/bin
fi
	;;
SunOS-*-sun*)
	tools=/tools/solaris
	java_arch=sparc
	PATH=/usr/dt/bin:$PATH
	PATH=$PATH:$tools/gmake-3.79.1/bin
if [ -n "$cambridge" ]; then
	PATH=$PATH:$tools/bin:/usr/rdl/solaris/bin:$HOME/git/solaris/bin:$HOME/bin/sparc
else
	PATH=$PATH:$tools/bin:/usr/rdl/solaris/bin
fi
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH${LD_LIBRARY_PATH:+:}/usr/local/lib
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/ssl/lib
	if [ "$TERM" = "xterm-color" ]; then
		TERM=xterm
	fi
	alias xemacs=/tools/solaris/bin/xemacs
	export JAVA_HOME=
	unset JAVA_HOME
	;;
FreeBSD-[1234]*)
	# Apama software currently not supported on FreeBSD 4.x or older
	MACHINE=linuxx86
	PATH=/usr/local/cvs/bin:$PATH
	;;
FreeBSD-[567]*)
	# Pretend to be Linux until we have something better, but use
	# real FreeBSD Java
	tools=/tools/linuxx86
	java_arch=i386
	MACHINE=linuxx86
	PATH=/usr/local/cvs/bin:$PATH
	JAVA_HOME=/usr/local/diablo-jdk1.5.0
	;;
esac

# Common setup for all supported platforms
case $platform in
Linux-*-x86_64 | Linux-*-i686 | SunOS-* | FreeBSD-[567]*)
	java_ld_library_path=${JAVA_HOME:=$tools/java/$java_version}/jre/lib/$java_arch
	PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$PYTHON_HOME/bin:$SVN_HOME/bin:$buildtime_java/pysys/$pysys_version/bin:$PATH
	PATH=$PATH:$APAMA_SRC/bin_$buildname
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH${LD_LIBRARY_PATH:+:}$APAMA_SRC/lib_$buildname
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${buildtime}/python/${python_version}/lib
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$tao_ld_library_path
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$icu_ld_library_path
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$psepro_ld_library_path
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$java_ld_library_path
	ulimit -c unlimited
	;;
esac

if [ -n "$cambridge" ]; then
	# load git completion and PS1 stuff
	if [ -f $HOME/git/completion.bash ]; then
		. $HOME/git/completion.bash
	fi
fi
	

PATH="$HOME/bin:$PATH"
BASH_PROFILE="`date`"

# Clean up shell environment a bit
unset APAMA_LIBTYPE APAMA_BUILDTYPE APAMA_SUBMAKE
unset apama_lib buildname libname ipath buildtime buildtime_java runtime runtime_java tools
unset tao_version icu_version libxml2_version psepro_version ant_version java_version
unset tao_ld_library_path icu_ld_library_path libxml2_ld_library_path psepro_ld_library_path java_ld_library_path java_arch
unset cambridge

# Export any envars we might have changed
export PATH LD_LIBRARY_PATH JAVA_HOME ANT_HOME
export ENV BASH_ENV BASH_PROFILE MACHINE
export CVSROOT PAGER VISUAL EDITOR TERM LESS
export APAMA_SRC

