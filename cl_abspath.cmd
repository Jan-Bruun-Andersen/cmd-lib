:cl_abspath path

:: = DESCRIPTION
:: =   Returns the absolute path of a (relative) path-name.
:: =
:: = GLOBAL VARIABLES
:: =   _abspath = the absolute path.
:: =
:: = SEE ALSO
:: =   The built-in CALL command and the %~f1 parameter substitution syntax.
:: =
:: = AUTHOR
:: =   Jan Bruun Andersen
:: =
:: = VERSION
:: =   2015-12-01

    set "_abspath="

    if "%~1" == "" echo>&2 Error in function 'cmd_lib.lib:%0'. Parameter 1 ^(path^) is null & goto error_exit

    set "_abspath=%~f1
:no_error
    time >NUL: /t
goto :EOF

:error_exit
    verify 2>NUL: other
goto :EOF

rem vim: set filetype=dosbatch tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab:
rem vim: set foldmethod=indent
