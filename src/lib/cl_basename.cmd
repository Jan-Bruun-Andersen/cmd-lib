:cl_basename path [.ext]

:: = DESCRIPTION
:: =   Returns the basename of a path-name.
:: =
:: = PARAMETERS
:: =   path  pathname to extract the basename from.
:: =   .ext  extension to be removed from basename.
:: =
:: = GLOBAL VARIABLES
:: =   _basename = the basename.
:: =
:: = EXAMPLE
:: =   ,---------------------------------------------------.
:: =   | @echo off                                         |
:: =   | echo Full path is: "%~f0"                         |
:: =   | call cl_basename "%~f0" .cmd                      |
:: =   | echo Basename ^(without .cmd^) is "%_basename%".  |
:: =   '---------------------------------------------------'
:: =
:: = SEE ALSO
:: =   cl_stripexts
:: =   The built-in CALL command and the %~n1 parameter substitution syntax.

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    time >NUL: /t & rem Set ErrorLevel = 0.
    set "_basename="

    if "%~1" == "" echo>&2 Error in function 'cmd_lib.lib:%0'. Parameter 1 ^(path^) is null & goto :error_exit

    set _basename=%~n1%~x1
    if /i "%~2" == "%~x1" set "_basename=%~n1"
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
