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
:: =
:: = AUTHOR
:: =   Jan Bruun Andersen
:: =
:: = VERSION
:: =   2015-12-01

    if "%~2" == "" call %0 %1 main & goto :EOF

    set "_=%~dp1;%PATH%"

    for /F "tokens=1,*" %%I in ('findstr /R "^:%~2" "%~$_:1"') do echo Usage: %~n1 %%J
goto :EOF

rem vim: set filetype=dosbatch tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab:
rem vim: set foldmethod=indent
