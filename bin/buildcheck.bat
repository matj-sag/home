set USER=%1
set BRANCH=%2

d:
cd \
mkdir %USER%
cd %USER%
mkdir checkbranch
cd checkbranch
if not exist apama-lib2 mklink /J apama-lib2 d:\apama-libs\apama-lib2
if exist .svn del /s /q .svn
if exist apama-src del /s /q apama-src
svn co -N http://svn.apama.com/dev/branches/%BRANCH% .
svn info

svn -q up apama-src
cd apama-src
ms_build.bat all
