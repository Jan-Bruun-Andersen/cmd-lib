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
:: =   | echo Basename ^(without .cmd^) is "%_basename%"   |
:: =   '---------------------------------------------------'
:: =
:: = SEE ALSO
:: =   cl_stripexts
:: =   The built-in CALL command and the %~n1 parameter substitution syntax.
:: =
:: = AUTHOR
:: =   Jan Bruun Andersen
:: =
:: = VERSION
:: =   2015-12-02

    time >NUL: /t
    set "_basename="

    if "%~1" == "" echo>&2 Error in function 'cmd_lib.lib:%0'. Parameter 1 ^(path^) is null & goto error_exit

    set _basename=%~n1%~x1
    if /i "%~2" == "%~x1" set "_basename=%~n1"
:no_error
    time >NUL: /t
goto :EOF

:error_exit
    verify 2>NUL: other
goto :EOF

rem vim: set filetype=dosbatch tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab:
rem vim: set foldmethod=indent
