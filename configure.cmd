@   echo off

:main /? | [/v] [/clean] | [/prefix directory]

:: = DESCRIPTION
:: =   Configures !cfg_PACKAGE!.
:: =
:: = OPTIONS
:: =   /v        Be verbose. Repeat for extra verbosity.
:: =   /clean    Remove files generated by !PROG_NAME!.
:: =   /prefix   Name of directory to install !cfg_PACKAGE! in.
:: =             Default is !prefix!.

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-09

    verify 2>NUL: other
    setlocal EnableExtensions
    if ErrorLevel 1 (
	echo Error - Unable to enable extensions.
	goto :EOF
    )

    if /i "%~1" == "/trace" shift /1 & prompt $G$G & echo on

:defaults
    set "show_help=false"
    set "verbosity=0"
    set "action=configure"

    set "PROG_CFG=%~dpn0.dat"
    call :read_cfg /vsub "%PROG_CFG%" ^
	PACKAGE   ^
	prefix    ^
	templates || goto :error_exit

:getopts
    if /i "%~1" == "/?"		set "show_help=true"	& shift /1		& goto :getopts

    if /i "%~1" == "/v"		set /a "verbosity+=1"	& shift /1		& goto :getopts
    if /i "%~1" == "/clean"	set "action=clean"	& shift /1		& goto :getopts
    if /i "%~1" == "/prefix"	set "cfg_prefix=%~2"	& shift /1 & shift /1	& goto :getopts

    rem cl_init needs to be here, after setting 'cfg_cmdlib'.
    for %%F in (cl_init.cmd) do if "" == "%%~$PATH:F" set "PATH=%cfg_cmdlib%;%PATH%"
    call cl_init "%~dpf0" || (echo Failed to initialise cmd-lib. & goto :exit)

    for %%F in (gsar.exe) do if "" == "%%~$PATH:F" set "PATH=%~dp0\bin;%PATH%"
    gsar -G > NUL: || (echo Failed to locate gsar.exe. & goto :exit)

    set "char1=%~1"
    set "char1=%char1:~0,1%"
    if "%char1%" == "/" (
	echo Unknown option - %1.
	echo.
	call cl_usage "%PROG_FULL%"
	goto :error_exit
    )

    if "%show_help%" == "true" call cl_help "%PROG_FULL%" & goto :EOF

    if not "%~1" == "" (
	echo Extra argument - %1.
	echo.
    	call cl_usage "%PROG_FULL%"
	goto :error_exit
    )

    if not defined cfg_prefix (
	echo /prefix directory not defined.
	echo.
    	call cl_usage "%PROG_FULL%"
	goto :error_exit
    )

    if 0%verbosity% geq 2 (
	echo action      = "%action%"
	call cl_dump_cfg 11
	echo.
    )

    rem .----------------------------------------------------------------------
    rem | This is where the real fun begins!
    rem '----------------------------------------------------------------------

    call :do_%action%

    goto :exit
goto :EOF

:do_configure
    for %%T in (%cfg_templates%) do call :do_subst "%%T"
    xcopy build\install.cmd /y /q >NUL:
goto :EOF

:do_clean
    for %%D in ("build") do if exist "%%~D" (
	if 0%verbosity% geq 1 echo Deleting directory "%%~D".
	rmdir /s /q "%%~D"
    )

    for %%F in ("install.cmd") do if exist "%%~F" (
	if 0%verbosity% geq 1 echo Deleting file "%%~F".
	del "%%~F"
    )
goto :EOF

:do_subst [template-file]
    setlocal EnableDelayedExpansion

    rem Extract the relative directory name from the template file.
    set "dir=%~dp1"
    set "rdir=build\!dir:*%CD%\=!"

    set "out_file=%rdir%%~n1"
    if 0%verbosity% geq 1 echo Creating "%out_file%" from "%~1".
    if not exist "%rdir%" mkdir "%rdir%"
    call cl_token_subst "%~1" "%out_file%" ^
	PACKAGE=%cfg_PACKAGE%  ^
	DST_DIR="%cfg_prefix%" ^
	CMD_LIB="%cfg_cmdlib%"

    endlocal
goto :EOF

rem .--------------------------------------------------------------------------
rem | Reads configuration variables and values.
rem |
rem | A configuration file is a simple text file, where lines starting
rem | with a # is treated as a comment. Everything else should be simple
rem | assignments, e.g.
rem |
rem |   PACKAGE=cmd-lib
rem |
rem | Each value will be assigned to a variable named cfg_<NAME>.
rem |
rem | @option /vsub        Perform variable substition on the values.
rem |
rem | @param  config-file  Name of configuration file.
rem | @param  req-value    Name of required configuration value. A missing value
rem |                      will result in an error.
rem '--------------------------------------------------------------------------
:read_cfg [/vsub] config-file [req-value ...]
    time >NUL: /t & rem Set ErrorLevel = 0.

    rem Park information about the /vsub option into %0 for later.
    if /i "%~1" == "/vsub" shift

    if not exist "%~1" (
	echo>&2 ERROR - Configuration file "%~1" not found.
	goto :error_exit
    )

    rem Read the configuration file and assign values to cfg_XXXX.

    for /F "usebackq eol=# tokens=1,* delims==" %%V in ("%~1") do (set cfg_%%V=%%W)

    for %%V in (%2 %3 %4 %5 %6 %7 %7 %9) do (
	if not defined cfg_%%V (
	    echo>&2 ERROR - Configuration value "%%V" is missing. Check "%~1".
	    goto :error_exit
	)
    )

    if /i not "%~0" == "/vsub" goto :EOF

    rem Re-read the configuration file and use 'call set ...' to do variable
    rem substitution.

    for /F "usebackq eol=# tokens=1,* delims==" %%V in ("%~1") do (call set cfg_%%V=%%W)
goto :EOF

rem .--------------------------------------------------------------------------
rem | Displays a selection of variables belonging to this script.
rem | Very handy when debugging.
rem '--------------------------------------------------------------------------
:dump_variables
    echo =======
    echo cwd            = "%CD%"
    echo tmp_dir        = "%tmp_dir%"
    echo.
    echo show_help      = "%show_help%"
    echo verbosity      = "%verbosity%"
    echo action         = "%action%"

    call cl_dump_cfg 14

    if defined tmp_dir if exist "%tmp_dir%\" (
	echo.
	dir %tmp_dir%
    )

    echo =======
goto :EOF

rem ----------------------------------------------------------------------------
rem Sets ErrorLevel and exit-status. Without a proper exit-status tests like
rem 'command && echo Success || echo Failure' will not work.
rem
rem OBS: NO commands must follow the call to %ComSpec%, not even REM-arks,
rem      or the exit-status will be destroyed. However, null commands like
rem      labels (or ::) is okay.
rem ----------------------------------------------------------------------------
:no_error
    time >NUL: /t	& rem Set ErrorLevel = 0.
    goto :exit
:error_exit
    verify 2>NUL: other	& rem Set ErrorLevel = 1.
:exit
    %ComSpec% /c exit %ErrorLevel%

:: vim: set filetype=dosbatch tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab:
:: vim: set foldmethod=indent
