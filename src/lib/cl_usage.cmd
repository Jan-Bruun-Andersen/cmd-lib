:cl_usage path-to-script [label-name]

:: = DESCRIPTION
:: =   Emits a single-line usage-description for a CMD using information
:: =   embedded in the script itself. The information is taken from
:: =   the label-name (default :main) specified in the call to cl_usage.
:: =
:: =   The label and usage-text should follow this pattern:
:: =
:: =       :main /? | options and parameters
:: = PARAMETERS
:: =   path-to-script  Path to script.
:: =
:: = EXAMPLE
:: =   Assume a script, count.cmd, with the following content:
:: =
:: =   ,---------------------------------------------------.
:: =   | @echo off                                         |
:: =   | :main /? | number                                 |
:: =   |                                                   |
:: =   | :: = This is a small script to count from 1 - n.  |
:: =   |                                                   |
:: =   | if "%~1" == "/?" call cl_usage "%~f0" & goto :EOF |
:: =   | for /L %%N in (1,1,%~1) do echo %%I               |
:: =   '---------------------------------------------------'
:: =
:: =   Invoking the script with
:: =
:: =     C:> count /?
:: =
:: =   will produce the usage-text
:: =
:: =   ,---------------------------------------------------.
:: =   | Usage: count /? | number                          |
:: =   '---------------------------------------------------'
:: =
:: = SEE ALSO
:: =   cl_help

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    if "%~2" == "" call %0 %1 main & goto :EOF

    for /F "tokens=1,*" %%I in ('findstr /R "^:%~2" "%~1"') do echo Usage: %~n1 %%J
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
