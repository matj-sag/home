set USER=%1
set BRANCH=%2

d:
cd \
cd %USER%
cd checkbranch
svn up apama-test
cd apama-test
ms_build_all_tools.bat