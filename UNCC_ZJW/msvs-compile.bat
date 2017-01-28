echo off
REM \author Zachary Wartell <zwartell@uncc.edu>
REM 
REM Run this script from libxml2\UNCC_ZJW
REM
REM See USAGE:
REM 
REM This script is an attempt to automate the instructions in libxml2\win32\Readme.txt
REM Further, the compiler settings and directory paths are based my needs for compiling the suite
REM of open source code described here: 
REM
REM     https://cci-git.uncc.edu/UNCC_Graphics_Third_Party_Libraries/AMVR-Third_Party_Libraries.git 
REM

REM 
REM USAGE
REM
if "%1"=="/?" (
	echo. 
	echo USAGE:
	echo. 
	echo msvs_compile.bat MSVS_BITS MSVS_VERSION
	echo. 
	echo MSVS_BITS = 32 or 64 
	echo      determines whether compilation result is for 32 or 64 architecture
	echo. 
	echo MSVS_VERSION = 2010 or 2015
	echo      determines what version of MSVS is used to compile boost. 
	echo. 
	exit /b
)

REM \todo how to make this more flexible, will this generate code the fails on intel64 machines?

pushd GumNTape_Build
set GUMNTAPE_BUILD=%CD%
popd

REM setup MSVS compiler tools
call %GUMNTAPE_BUILD%\common\msvs_tools_setup.bat 64 2010

pushd ..\win32

set TPL_DIR=..\..
call "%GUMNTAPE_BUILD%\common\v1\msvs_set_install_paths.bat" %TPL_DIR% 64 2010

REM set DEBUG1=1
if DEFINED DEBUG1 (
    echo INSTALL_DIR %INSTALL_DIR%
    echo INSTALL_BIN_DIR %INSTALL_BIN_DIR%
    echo INSTALL_LIB_DIR %INSTALL_LIB_DIR%
    echo INSTALL_INC_DIR %INSTALL_INC_DIR%
)

REM IF NOT EXIST "%INSTALL_INC_DIR%\iconv" mkdir "%INSTALL_INC_DIR%\iconv"

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
REM

cscript configure.js compiler=msvc cruntime=/MDd debug=yes bindir=%INSTALL_BIN_DIR% libdir=%INSTALL_LIB_DIR% incdir=%INSTALL_INC_DIR% include="%INSTALL_INC_DIR%\iconv" lib=%INSTALL_LIB_DIR% sodir=%INSTALL_BIN_DIR%

REM goto exit_popd

echo Make Clean
nmake /f Makefile.msvc clean 
echo Make 
nmake /f Makefile.msvc
echo Make Install
nmake /f Makefile.msvc install

:exit_popd

popd
