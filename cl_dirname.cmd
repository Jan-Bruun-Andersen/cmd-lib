:cl_dirname path

:: = DESCRIPTION
:: =   Returns the drive and directory name of a path-name.
:: =
:: = GLOBAL VARIABLES
:: =   _dirname = the drive and directory name.
:: =
:: = SEE ALSO
:: =   The built-in CALL command and the %~d1 and %~p1 parameter substitution syntax.
:: =
:: = AUTHOR
:: =   Jan Bruun Andersen
:: =
:: = VERSION
:: =   2015-12-01

    set "_dirname="

    if "%~1" == "" echo>&2 Error in function 'cmd_lib.lib:%0'. Parameter 1 ^(path^) is null & goto error_exit

    set "_dirname=%~dp1"
:no_error
    time >NUL: /t
goto :EOF

:error_exit
    verify 2>NUL: other
goto :EOF

rem vim: set filetype=dosbatch tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab:
rem vim: set foldmethod=indent
