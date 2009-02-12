set USER=%1
set BRANCH=%2

d:
cd \
cd %USER%
cd checkbranch
if exist apama-test icacls apama-test /grant "Everyone:F" /t /q
if exist apama-test del /f /s /q apama-test
if exist apama-samples icacls apama-samples /grant "Everyone:F" /t /q
if exist apama-samples del /f /s /q apama-samples
svn -q up apama-test
svn -q up apama-samples
cd apama-test
ms_build_all_tools.bat
