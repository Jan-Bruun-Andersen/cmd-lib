@echo off

:main /? | path

:: = DESCRIPTION
:: =   Prints the drive and directory name of a path-name.
:: =
:: = PARAMETERS
:: =   path  pathname to extract the drive and directory name from.
:: =
:: = SEE ALSO
:: =   The built-in CALL command and the %~d1 and %~p1 parameter substitution syntax.

    setlocal

    if "%~1" == "/?"call %~p0\cmd-lib.lib\cl_help  %~f0 & goto error_exit
    if "%~1" == ""  call %~p0\cmd-lib.lib\cl_usage %~f0 & goto error_exit

    call %~p0\cmd-lib.lib\cl_%0 %*
    if defined _dirname (echo.%_dirname%)
:no_error
    time >NUL: /t
goto :EOF

:error_exit
    verify 2>NUL: other
goto :EOF

rem vim: set filetype=dosbatch tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab:
rem vim: set foldmethod=indent
