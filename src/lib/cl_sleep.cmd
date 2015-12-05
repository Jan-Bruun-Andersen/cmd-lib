:cl_sleep [seconds [message]]

:: = DESCRIPTION
:: =   Sleeps for X seconds (default is 2 seconds).
:: =   The optional message is printed just before the sleeping starts.
:: =
:: = EXAMPLE
:: =   ,---------------------------------------------------.
:: =   | @echo off                                         |
:: =   | call cl_sleep 10 Sleeping for 10 seconds.         |
:: =   '---------------------------------------------------'

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05


:: @Author Jan Bruun Andersen
:: @(#) Version: 2015-12-04
    if "%~1" == "" call %0 2 & goto :EOF

    rem Print out optional message.
    if not "%~2" == "" echo %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9

    rem Each ping is repeated %1 times with a 1 second delay.
    ping -w 1000 -n "%~1" 127.0.0.1 > NUL:

    goto :no_error
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
