set USER=%1
set BRANCH=%2

d:
cd \
mkdir %USER%
cd %USER%
svn co -N http://svn.apama.com/dev/branches/%BRANCH% checkbranch
cd checkbranch
svn info
mklink /J apama-lib2 d:\apama-libs\apama-lib2
svn -q up apama-src
cd apama-src
ms_build.bat all
