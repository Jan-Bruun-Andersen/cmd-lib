:cl_token_subst [/delims XY] in-file out-file [token-assignment...]

:: = DESCRIPTION
:: =   cl_token_subst - performs token substitution on a file.
:: =
:: = OPTIONS
:: =   /delims           Token delimiters. Default is @@.
:: =
:: = PARAMETERS
:: =   in-file           Input file
:: =   out-file          Output file (existing file will be deleted)
:: =   token-assignment  A token assignment in the form NAME=value.
:: =
:: = EXAMPLE
:: =   Assuming an in-file (in.txt) with the following content (token name is
:: =   DATE, delimiters are @@):
:: =
:: =   ,-----------------------------------------------------.
:: =   | Today's date is @DATE@.                             |
:: =   '-----------------------------------------------------'
:: =
:: =   then cl_token_subst can be used to create an out-file
:: =   with todays date:
:: =
:: =   ,-----------------------------------------------------.
:: =   | @echo off                                           |
:: =   | call cl_token_subst "in.txt" "out.txt" DATE=%DATE%  |
:: =   '-----------------------------------------------------'

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-10

    setlocal
    time >NUL: /t & rem Set ErrorLevel = 0.

    set "delims=@@"	    & rem Default token delimiters.
    set "delim1="
    set "delim2="

    if /i "%~1" == "/delims" set "delims=%~2" & shift /1 & shift /1
    set "delim1=%delims:~0,1%"
    set "delim2=%delims:~1,1%"

    if "%~1" == "" echo>&2 Error in function '%0'. Parameter 1 ^(in-file^) is null.	& goto :error_exit
    if "%~2" == "" echo>&2 Error in function '%0'. Parameter 2 ^(out-file^) is null.	& goto :error_exit

    set "in_file=%~1"  & shift /1
    set "out_file=%~1" & shift /1

    if true == false (
	echo delim1   = "%delim1%"
	echo delim2   = "%delim2%"
	echo.
	echo in_file  = "%in_file%"
	echo out_file = "%out_file%"
	echo.
    )

    if "%out_file%" == "%in_file%" (
	echo>&2 ERROR - %0 cowardly refuses to overwrite the input-file "%in_file%".
	goto :error_exit
    )

    if  exist   "gsar.exe"                               goto :do_gsar
    for %%F in ("gsar.exe") do if not "" == "%%~$PATH:F" goto :do_gsar

    echo>&2 ERROR - %0 is unable to locate the required tool for token substition.
    echo>&2.        Please make sure "gsar.exe" is on the search PATH.
    goto :error_exit

:do_gsar
    rem ------------------------------------------------------------------------
    rem Perform token substititions using gsar (General Search and Replace).
    rem
    rem First initialise the output file, then loop through the list of tokens
    rem and do the required substitutions.
    rem
    rem OBS: gsar uses ':' to indicate a CTRL-char. Escaping is done by doubling
    rem      up and changing ':' to '::'. Hence the %s2::=::% stuff.
    rem ------------------------------------------------------------------------

    type "%in_file%" > "%out_file%"

    :gsar
	if "%~1" == "" goto :EOF
	set "s1=%~1" & shift /1
	set "s2=%~1" & shift /1
	gsar -o -s"@%s1::=::%@" -r"%s2::=::%" "%out_file%" >NUL: || goto :error_exit
    goto :gsar
goto :exit

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
