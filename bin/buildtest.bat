set USER=%1
set BRANCH=%2

d:
cd \
cd %USER%
cd checkbranch
if exist apama-test del /s /q apama-test
if exist apama-samples del /s /q apama-samples
svn -q up apama-test
svn -q up apama-samples
cd apama-test
ms_build_all_tools.bat
