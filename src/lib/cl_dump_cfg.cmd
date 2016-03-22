:cl_dump_cfg [/cs1 column1-size] [/fullname]

:: = DESCRIPTION
:: =   Displays configuration values (variables with prefix 'cfg_') in two
:: =   columns:
:: =
:: =   name = "value"
:: =
:: = OPTIONS
:: =   /cs1       Max size of column 1 (variable-names).
:: =   /fullname  Show the full name of the variable (including cfg_).

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-10

    setlocal EnableDelayedExpansion
    time >NUL: /t & rem Set ErrorLevel = 0.

    set "csize=14"
    set "vprefix="
    set "rpad="

:getopts
    if /i "%~1" == "/cs1"      set "csize=%~2"	    & shift /1 & shift /1   & goto :getopts
    if /i "%~1" == "/fullname" set "vprefix=cfg_"   & shift /1		    & goto :getopts

    set "char1=%~1"
    set "char1=%char1:~0,1%"
    if "%char1%" == "/" (
	echo Unknown option - %1.
	echo.
	call cl_usage "%~f0"
	goto :error_exit
    )

    for /L %%L in (1,1,%csize%) do set "rpad=!rpad! "

    for /F "usebackq delims== tokens=1,*" %%V in (`set cfg_`) do (
	set "V=%%V!rpad!"
	if not defined vprefix set "V=!V:*cfg_=!"
	echo !V:~0,%csize%! = "%%W"
    )
    endlocal
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
