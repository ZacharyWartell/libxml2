REM
REM libxml2\win32\Readme.txt

echo off

pushd ..\win32

set TPL_DIR=.
set INSTALL_DIR=%TPL_DIR%\install\v100-x64\
set INSTALL_BIN_DIR=%INSTALL_DIR%bin
set INSTALL_LIB_DIR=%INSTALL_DIR%lib
set INSTALL_INC_DIR=%INSTALL_DIR%include

REM IF NOT EXIST "%INSTALL_INC_DIR%\iconv" mkdir "%INSTALL_INC_DIR%\iconv"

cscript configure.js compiler=msvc cruntime=/MDd debug=no bindir=%INSTALL_BIN_DIR% libdir=%INSTALL_LIB_DIR% include=%INSTALL_INC_DIR% lib=%INSTALL_LIB_DIR% sodir=%INSTALL_BIN_DIR%

REM "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" amd64
cmd /C "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" amd64 & nmake /f Makefile.msvc

popd
