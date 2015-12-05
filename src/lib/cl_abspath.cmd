:cl_abspath path

:: = DESCRIPTION
:: =   Returns the absolute path of a (relative) path-name.
:: =
:: = PARAMETERS
:: =   path  pathname to get the absolute path from.
:: =
:: = GLOBAL VARIABLES
:: =   _abspath = the absolute path.
:: =
:: = EXAMPLE
:: =   ,---------------------------------------------------.
:: =   | @echo off                                         |
:: =   | echo Local path is: "."                           |
:: =   | call cl_abspath "."                               |
:: =   | echo Absolute path is "%_abspath%".               |
:: =   '---------------------------------------------------'
:: =
:: = SEE ALSO
:: =   The built-in CALL command and the %~f1 parameter substitution syntax.

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    time >NUL: /t & rem Set ErrorLevel = 0.
    set "_abspath="

    if "%~1" == "" echo>&2 Error in function 'cmd_lib.lib:%0'. Parameter 1 ^(path^) is null & goto :error_exit

    set "_abspath=%~f1
    goto :exit
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
