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
:: =
:: =   cl_help will also scan for two special markers:
:: =
:: =     :: @author
:: =     :: @version
:: =
:: =   and use that information as values for an AUTHOR and VERSION section.
:: =
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
:: =   | :: @author Jan Bruun Andersen                     |
:: =   | :: @version 2015-12-04                            |
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
:: =   |                                                   |
:: =   | AUTHOR                                            |
:: =   |   Jan Bruun Andersen                              |
:: =   |                                                   |
:: =   | VERSION                                           |
:: =   |   2015-12-04                                      |
:: =   '---------------------------------------------------'
:: =
:: = SEE ALSO
:: =   cl_usage

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    setlocal enabledelayedexpansion

    rem If no label-name was specified, default is 'main'.
    if "%~2" == "" call %0 %1 main & goto :EOF

    echo NAME
    echo.  %~n1

    rem Look for the label indicating the start of the script (usually :main) and
    rem use the information embedded as part of the synopsis for calling the
    rem script.

    for /F "tokens=1,*" %%I in ('findstr /R "^:%~2" "%~1"') do (
	set "J=%%J"
	echo.
	echo SYNOPSIS
	echo.  %~n1 !J!
    )

    rem Look for magic ':: =' markers and emit help text.

    echo.
    for /F "delims=" %%I in ('findstr /R /C:"^:: =" "%~1"') do (
	set "I=%%I"
	echo.!I:~5!
    )

    rem Look for magic ':: @author' marker and emit an AUTHOR section.

    for /F "delims=" %%I in ('findstr /R /C:"^:: @author " "%~1"') do (
	set "I=%%I"
	echo.
	echo AUTHOR
	echo. !I:*@Author=!
    )

    rem Look for magic ':: @version' marker and emit an VERSON section.

    for /F "delims=" %%I in ('findstr /R /C:"^:: @version " "%~1"') do (
	set "I=%%I"
	echo.
	echo VERSION
	echo. !I:*@Version=!
    )

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
