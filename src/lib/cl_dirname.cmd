:cl_dirname path

:: = DESCRIPTION
:: =   Returns the drive and directory name of a path-name.
:: =
:: = PARAMETERS
:: =   path  pathname to extract the directory-name from.
:: =
:: = GLOBAL VARIABLES
:: =   _dirname = the drive and directory name.
:: =
:: = EXAMPLE
:: =   ,---------------------------------------------------.
:: =   | @echo off                                         |
:: =   | echo Full path is: "%~f0"                         |
:: =   | call cl_dirname "%~f0"                            |
:: =   | echo Directory is "%_dirname%".                   |
:: =   '---------------------------------------------------'
:: =
:: = SEE ALSO
:: =   The built-in CALL command and the %~d1 and %~p1 parameter substitution syntax.

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    time >NUL: /t & rem Set ErrorLevel = 0.
    set "_dirname="

    if "%~1" == "" echo>&2 Error in function 'cmd_lib.lib:%0'. Parameter 1 ^(path^) is null & goto :error_exit

    set "_dirname=%~dp1"
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
