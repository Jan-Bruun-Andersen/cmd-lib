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
:: =
:: = AUTHOR
:: =   Jan Bruun Andersen
:: =
:: = VERSION
:: =   2015-12-02

    time >NUL: /t

    if "%~1" == "" call %0 2 & goto :EOF

rem Print out optional message.
    if not "%~2" == "" echo %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9

rem Each ping is repeated %1 times with a 1 second delay.
    ping -w 1000 -n "%~1" 127.0.0.1 > NUL:

:no_error
    time >NUL: /t
goto :EOF

:error_exit
    verify 2>NUL: other
goto :EOF

rem vim: set filetype=dosbatch tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab:
rem vim: set foldmethod=indent
