:read_cfg [/vsub] config-file [req-value ...]

:: = DESCRIPTION
:: =   Reads and defines configuration variables and values.
:: =
:: =   A configuration file is a simple text file, where lines starting
:: =   with a # is treated as a comment. Everything else should be simple
:: =   assignments, e.g.
:: =
:: =     PACKAGE=cmd-lib
:: =
:: =   Each value will be assigned to a variable named cfg_<NAME>.
:: =
:: = OPTIONS
:: =   /vsub  Perform variable substition on the values.
:: =
:: = PARAMETERS
:: =   config-file  Name of configuration file.
:: =   req-value    Name of required configuration value. A missing value will
:: =                result in an error.
:: =
:: = EXAMPLE
:: =   ,---------------------------------------------------.
:: =   | @echo off                                         |
:: =   | call cl_read_cfg "file.dat" VAR                   |
:: =   | echo Value of VAR = "%cfg_VAR%"                   |
:: =   '---------------------------------------------------'
:: =
:: = GLOBAL VARIABLES
:: =   cfg_XXXX = Configuration variable XXXX (from configuration file).

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-09

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
