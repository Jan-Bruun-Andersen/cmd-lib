:cl_stripexts path .ext [.ext...]

:: = DESCRIPTION
:: =   Returns the pathname stripped of the named extensions.
:: =
:: = PARAMETERS
:: =   path  pathname to strip
:: =   .ext  extensions to be removed from pathname.
:: =
:: = GLOBAL VARIABLES
:: =   _stripexts = the stripped pathname.
:: =
:: = SEE ALSO
:: =   cl_basename
:: =   The built-in CALL command and the %~n1 parameter substitution syntax.
:: =
:: = AUTHOR
:: =   Jan Bruun Andersen
:: =
:: = VERSION
:: =   2015-12-01

    time >NUL: /t
    set "_stripexts="

    if "%~1" == "" echo>&2 Error in function 'cmd_lib.lib:%0'. Parameter 1 ^(path^) is null & goto error_exit
    if "%~2" == "" echo>&2 Error in function 'cmd_lib.lib:%0'. Parameter 1 ^(.ext^) is null & goto error_exit
:strip
    if "%~1" == "" echo>&2 Error in function 'cmd_lib.lib:%0'. Parameter 1 ^(path^) is null & goto error_exit
    if "%~2" == "" goto :EOF

    if "%~x1" == "%~2" (set "_stripexts=%~dpn1") else (set "_stripexts=%~1")
    shift
    call :strip "%_stripexts%" %2 %3 %4 %5 %6 %7 %8 %9
:no_error
    time >NUL: /t
goto :EOF

:error_exit
    verify 2>NUL: other
goto :EOF

rem vim: set filetype=dosbatch tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab:
rem vim: set foldmethod=indent
