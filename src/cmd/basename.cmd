@echo off

:main /? | path [.ext]

:: = DESCRIPTION
:: =   Prints the basename of a path-name.
:: =
:: = PARAMETERS
:: =   path  pathname to extract the basename from.
:: =   .ext  extension to be removed from basename.
:: =
:: = SEE ALSO
:: =   The built-in CALL command and the %~n1 parameter substitution syntax.

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    verify 2>NUL: other
    setlocal EnableExtensions
    if ErrorLevel 1 (
	echo Error - Unable to enable extensions.
	goto :EOF
    )

    for %%F in (cl_init.cmd) do if "" == "%%~$PATH:F" PATH %~dp0\cmd-lib.lib;%PATH%
    call cl_init "%~f0" "%~1" || (echo Failed to initialise cmd-lib. & goto :exit)

    if "%~1" == "/?"call cl_help  %~f0 & goto :error_exit
    if "%~1" == ""  call cl_usage %~f0 & goto :error_exit

    call cl_%0 %*
    if defined _basename (echo %_basename%)
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
