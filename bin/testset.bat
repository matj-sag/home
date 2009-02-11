set USER=%1
set BRANCH=%2

d:
cd \
cd %USER%
cd checkbranch
cd apama-test
cd python_scripts
doReleaseTest.py -t