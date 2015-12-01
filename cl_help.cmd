:cl_help path-to-script [label]

:: = DESCRIPTION
:: =   Emits a multi-line help-description for this script using information
:: =   embedded in the :main label and a set of comment lines (actually, a dummy
:: =   label).
:: =
:: =   The :mail label and help-text should follow this pattern:
:: =
:: =       :main /? | options and parameters
:: =
:: =       :: = DESCRIPTION:
:: =       :: =   Blah blah blah..
:: =       :: =   And this !VARIABLE! gets expanded as well.
:: =
:: = PARAMETERS
:: =   paht-to-script  Path to script.
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
