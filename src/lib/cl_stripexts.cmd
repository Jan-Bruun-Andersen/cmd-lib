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
:: = EXAMPLE
:: =   ,---------------------------------------------------.
:: =   | @echo off                                         |
:: =   | echo Archive path is: "archive.7z"                |
:: =   | call cl_stripexts "archive.7z" .zip .7z .gz       |
:: =   | echo Stripped name is "%_stripexts%".             |
:: =   '---------------------------------------------------'
:: =
:: = SEE ALSO
:: =   cl_basename
:: =   The built-in CALL command and the %~n1 parameter substitution syntax.

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    time >NUL: /t & rem Set ErrorLevel = 0.
    set "_stripexts="

    if "%~1" == "" echo>&2 Error in function '%0'. Parameter 1 ^(path^) is null & goto :error_exit
    if "%~2" == "" echo>&2 Error in function '%0'. Parameter 1 ^(.ext^) is null & goto :error_exit
:strip
    if "%~1" == "" echo>&2 Error in function '%0'. Parameter 1 ^(path^) is null & goto :error_exit
    if "%~2" == "" goto :EOF

    if "%~x1" == "%~2" (set "_stripexts=%~dpn1") else (set "_stripexts=%~1")
    shift
    call :strip "%_stripexts%" %2 %3 %4 %5 %6 %7 %8 %9
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
