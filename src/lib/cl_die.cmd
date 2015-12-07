:cl_die [error-level [error-message...]]

:: = DESCRIPTION
:: =   Emits an optional error message, then sets ErrorLevel and exit-status.

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    if not "%~2" == "" echo>&2 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9
    call :errlevel %~1

    goto :exit
goto :EOF

:errlevel error-level
    exit /b %~1
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
