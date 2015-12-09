:cl_dump_cfg column1-size

:: = DESCRIPTION
:: =   Displays configuration values (variables with prefix 'cfg_') in two
:: =   columns:
:: =
:: =   variable-name = "variable-value"
:: =
:: = PARAMETERS
:: =   column1-size  Max size of name column.

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-08

    setlocal EnableDelayedExpansion
    time >NUL: /t & rem Set ErrorLevel = 0.

    set csize=%~1
    set "rpad="
    for /L %%L in (1,1,%csize%) do set "rpad=!rpad! "

    for /F "usebackq delims== tokens=1,*" %%V in (`set cfg_`) do (
	set "V=%%V!rpad!"
	echo !V:~4,%csize%! = "%%W"
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
