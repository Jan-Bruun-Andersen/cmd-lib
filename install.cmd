@   echo off

:main /? | [/v] [/n] dest-dir

:: = DESCRIPTION
:: =   !PROG_NAME! - installs cmd-lib.
:: =
:: = PARAMETERS
:: =   dest-dir
:: =     Name of directory to install cmd-lib in.
:: =
:: = OPTIONS
:: =   /v  Be verbose. Repeat for extra verbosity.
:: =
:: =   /n  Dry-run. Do not install, just show commands,

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    verify 2>NUL: other
    setlocal EnableExtensions
    if ErrorLevel 1 (
	echo Error - Unable to enable extensions.
	goto :EOF
    )

    for %%F in (cl_init.cmd) do if "" == "%%~$PATH:F" PATH %~dp0\src;%PATH%
    call cl_init "%~f0" "%~1" || (echo Failed to initialise cmd-lib. & goto :exit)
    if /i "%~1" == "/trace" shift & prompt $G$G & echo on

:defaults
    set "show_help=false"
    set "verbosity=0"
    set "dry_run=false"
    set "dst_dir="
    set "DRY_CMD=ECHO"

:getopts
    if /i "%~1" == "/?"		set "show_help=true"	& shift		& goto :getopts

    if /i "%~1" == "/v"		set /a "verbosity+=1"	& shift		& goto :getopts
    if /i "%~1" == "/n"		set "dry_run=true"	& shift		& goto :getopts

    set "char1=%~1"
    set "char1=%char1:~0,1%"
    if "%char1%" == "/" (
	echo Unknown option - %1.
	echo.
	call cl_usage "%PROG_FULL%"
	goto :error_exit
    )

    if "%show_help%" == "true" call cl_help "%PROG_FULL%" & goto :EOF

    set "dst_dir=%~1" & shift

    if not "%~1" == "" (
	echo Extra argument - %1.
	echo.
    	call cl_usage "%PROG_FULL%"
	goto :error_exit
    )

    if not defined dst_dir (
	echo Missing argument - dest-dir is empty.
	echo.
    	call cl_usage "%PROG_FULL%"
	goto :error_exit
    )

    if 0%verbosity% geq 1 (
	echo dest-dir     = %dst_dir%
	echo dry-run      = %dry_run%
	echo.
    )

    rem .----------------------------------------------------------------------
    rem | This is where the real fun begins!
    rem '----------------------------------------------------------------------

    if not exist "%dst_dir%" %DRY_CMD% mkdir "%dst_dir%" || goto :exit

    for %%F in (src/*,cmd) do (
	%DRY_CMD% copy "%%F" "%dst_dir%"
    )

    goto :exit
goto :EOF

rem .--------------------------------------------------------------------------
rem | Displays a selection of variables belonging to this script.
rem | Very handy when debugging.
rem '--------------------------------------------------------------------------
:dump_variables
    echo =======
    echo cwd            = "%CD%"
    echo tmp_dir        = "%tmp_dir%"

    echo show_help      = "%show_help%"
    echo verbosity      = "%verbosity%"
    echo dry_run        = "%dry_run%"
    echo dst_dir        = "%dst_dir%"

    if defined tmp_dir if exist "%tmp_dir%\" (
	echo.
	dir %tmp_dir%
    )

    echo =======
goto :EOF

rem ----------------------------------------------------------------------------
rem Sets ErrorLevel and exit-status. Without a proper exit-status tests like
rem 'command && echo Success || echo Failure' will not work,
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
