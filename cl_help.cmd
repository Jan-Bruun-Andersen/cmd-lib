:cl_help path-to-script [label-name]

:: = DESCRIPTION
:: =   Emits a multi-line help-description for a CMD-script using information
:: =   embedded in the script itself. The information consists of two parts:
:: =
:: =     1) A label (default :main) followed by a usage-like summary.
:: =     2) A set of comment lines (actually, dummy labels) using the special
:: =        format ':: = help-text 
:: =
:: =   The label and help-text should follow this pattern:
:: =
:: =       :main /? | options and parameters
:: =
:: =       :: = DESCRIPTION:
:: =       :: =   Blah blah blah..
:: =       :: =   And this !VARIABLE! gets expanded as well.
::
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
:: =   | if "%~1" == "/?" call cl_help "%~f0" & goto :EOF  |
:: =   | for /L %%N in (1,1,%~1) do echo %%I               |
:: =   '---------------------------------------------------'
:: =
:: =   Invoking the script with
:: =
:: =     C:> count /?
:: =
:: =   will produce the help-text
:: =
:: =   ,---------------------------------------------------.
:: =   | NAME                                              |
:: =   |   count                                           |
:: =   |                                                   |
:: =   | SYNOPSIS                                          |
:: =   |   count /? | number                               |
:: =   |                                                   |
:: =   | This is a small script to count from 1 - n.       |
:: =   '---------------------------------------------------'
:: =
:: = SEE ALSO
:: =   cl_usage
:: =
:: = AUTHOR
:: =   Jan Bruun Andersen
:: =
:: = VERSION
:: =   2015-12-01

    if "%~2" == "" call %0 %1 main & goto :EOF

    set "_=%~dp1;%PATH%"

    echo. NAME
    echo.   %~n1
    echo.
    echo. SYNOPSIS

    for /F "tokens=1,*" %%I in ('findstr /R "^:%~2" "%~$_:1"')   do echo.   %~n1 %%J
    echo.

    setlocal enabledelayedexpansion
    for /F "delims=" %%I in ('findstr /R /C:"^:: =" "%~$_:1"') do (
	set "I=%%I"
	echo.!I:~4!
    )
    endlocal
goto :EOF

rem vim: set filetype=dosbatch tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab:
rem vim: set foldmethod=indent
