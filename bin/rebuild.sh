#!/bin/bash --

echo '**** Rebuilding Apama Lib ****'
HOSTNAME=`/bin/hostname`
echo $HOSTNAME
echo '****  ****'

case $APAMA_MACHTYPE in
	amd64-rhel4*)
		export AP_LIB=svn://svn.apama.com/cam/rhel4-amd64/apama-lib
		;;
	ia32-rhel4*)
		export AP_LIB=svn://svn.apama.com/cam/rhel4-ia32/apama-lib
		;;
	sparc-sun*)
		export AP_LIB=svn://svn.apama.com/cam/solaris-sparc/apama-lib
		;;
	amd64-sun*)
		export AP_LIB=svn://svn.apama.com/cam/solaris-amd64/apama-lib
		;;
	*)
		export AP_LIB=svn://svn.apama.com/apama-lib
		;;
esac
 
(

if [ "$HOSTNAME" = "badboy.apama.com" ]; then
	PATH="/tools/linuxx86/python-2.4.1/bin:/usr/bin:/tools/linuxx86/subversion-1.4.3/bin:/tools/linuxx86/gmake-3.79.1/bin:$PATH"
else
	. ~/.makepath.sh
fi
set -e
set -x

cd /var/tmp
mkdir -p mjj29
cd mjj29
[ -d apama-lib ] && mv apama-lib{,.old}
svn co $AP_LIB
[ -d 0.9.8b ] && mv 0.9.8b{,.old}
svn co svn://svn.apama.com/apama-lib-src/openssl/0.9.8b
cd 0.9.8b
export APAMA_LIB=/var/tmp/mjj29/apama-lib
./buildApama.sh
cd /var/tmp/mjj29
[ -d apama-src ] && mv apama-src{,.old}
svn co svn://svn.apama.com/branches/int/4.0.0.0/apama-src
cd apama-src
patch -p0 < /users/ukcam/majohnso/openssl.diff
gmake -j2
) &> /users/ukcam/majohnso/logs/$HOSTNAME.apama-lib-rebuild.log
