REM \author Zachary Wartell <zwartell@uncc.edu>
REM 
REM Run this script from libxml2\UNCC_ZJW
REM
REM This script is an attempt to automate the instructions in libxml2\win32\Readme.txt
REM The compiler settings and directory paths are based my needs for compiling the suite
REM of open source code described here: 
REM
REM     https://cci-git.uncc.edu/UNCC_Graphics_Third_Party_Libraries/AMVR-Third_Party_Libraries.git 

echo off

REM \todo how to make this more flexible, will this generate code the fails on intel64 machines?

REM set MSVS_ARCH=amd64

set MSVS_ARCH=x86_amd64
set MSVS_ARCH=amd64

REM these choices all generate xmllint.exe and other executables that crashed immediately
REM set MSVS_ARCH=amd64
REM set MSVS_ARCH=x86_amd64

pushd GumNTape_Build
set GUMNTAPE_BUILD=%CD%
popd

pushd ..\win32

set TPL_DIR=..\..
set INSTALL_DIR=%TPL_DIR%\install\MSVS_2010\x64\
set INSTALL_BIN_DIR=%INSTALL_DIR%bin
set INSTALL_LIB_DIR=%INSTALL_DIR%lib
set INSTALL_INC_DIR=%INSTALL_DIR%include

REM IF NOT EXIST "%INSTALL_INC_DIR%\iconv" mkdir "%INSTALL_INC_DIR%\iconv"

REM dir %INSTALL_DIR%
REM dir %INSTALL_INC_DIR%\iconv
dir %INSTALL_LIB_DIR%

REM popd
REM exit /b

REM Remarks:
REM I gave up compiling against a libiconv.dll (see below).  And instead only generate a static compiled libiconv and link libxml with that.
REM
REM Note, libxml nmake by default uses /Z7 for debugging.  Will this cause problems if code the links to 
REM the generated library used /Zi or /Zl?
REM 
REM Try:
REM 
REM libiconv_dll
REM libiconv is Debug, x64, /Zi, /MDd to match libxml Debug, x64, /Z7, /MDd,  - xmllint fails!
REM libiconv is Debug, x64, /Z7, /MDd to match libxml Debug, x64, /Z7, /MDd,  - xmllint fails!
REM libiconv is Debug, x64, /Z7, /MTd to match libxml Debug, x64, /Z7, /MTd,  - xmllint fails!
REM libiconv is Debug, win32, /Z7, /MTd to match libxml Debug, win32, /Z7, /MTd,  - libxml fails to compile, linker error
REM 
REM cruntime
REM    see https://msdn.microsoft.com/en-us/library/2kzt1wy3.aspxe=
REM
REM /MDd - generates xmllint.exe that crashes
REM /MD  - generates xmllint.exe that crashes
REM /MTd - ditto
cscript configure.js compiler=msvc cruntime=/MDd debug=yes bindir=%INSTALL_BIN_DIR% libdir=%INSTALL_LIB_DIR% incdir=%INSTALL_INC_DIR% include="%INSTALL_INC_DIR%\iconv" lib=%INSTALL_LIB_DIR% sodir=%INSTALL_BIN_DIR%

REM \todo generalize this line 
REM other architectures?

echo on
call %GUMNTAPE_BUILD%\common\msvs_tools_setup.bat 64 2010

goto exit_popd

echo Make Clean
nmake /f Makefile.msvc clean 
echo Make 
nmake /f Makefile.msvc
echo Make Install
nmake /f Makefile.msvc install

:exit_popd

popd
