:cl_date_time

:: = DESCRIPTION
:: =   Returns the local date and time in two variables: %LDATE% and %LTIME%.
:: =   Unlike the format of the built-in variables %DATE% and %TIME% which
:: =   varies depending on the regional settings and language, %LDATE% and
:: =   %LTIME% always have a fixed format. This makes it easy to pick out the
:: =   sub-flields when creating reports, file-names, etc.
:: =
:: = GLOBAL VARIABLES
:: =   LDATE  Local date as yyyymmdd. Set by cl_date_time.
:: =   LTIME  Local time as HHMMSS.   Set by cl_date_time.
:: =
:: = SEE ALSO
:: =   The built-in variables %DATE% and %TIME%.

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-08

rem The idea for getting the local date and time using WMIC was inspired by an
rem answer at
rem
rem   http://stackoverflow.com/questions/203090/how-to-get-current-datetime-on-windows-command-line-in-a-suitable-format-for-us
rem
rem An alternative (albeit slower) to WMIC is to use PowerShell:
rem
rem   powershell get-date -format "{yyyyMMdd HHmmss}"

    setlocal
    time >NUL: /t & rem Set ErrorLevel = 0.

    set "LDATE="
    set "LTIME="

    for /F %%T in (
	'wmic os get LocalDateTime /VALUE ^| findstr /b LocalDateTime='
    ) do set %%T

    endlocal & set LDATE=%LocalDateTime:~0,8% & set LTIME=%LocalDateTime:~8,6%
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
