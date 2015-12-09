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
:: @version @(#) Version: 2015-12-07

    setlocal
    time >NUL: /t & rem Set ErrorLevel = 0.

    set "delims=@@"
    set "delim1="
    set "delim2="

    if /i "%~1" == "/delims" set "delims=%~2" & shift /1 & shift /1
    set "delim1=%delims:~0,1%"
    set "delim2=%delims:~1,1%"

    if "%~1" == "" echo>&2 Error in function '%0'. Parameter 1 ^(in-file^) is null.	& goto :error_exit
    if "%~2" == "" echo>&2 Error in function '%0'. Parameter 2 ^(out-file^) is null.	& goto :error_exit

    set "in_file=%~1"  & shift /1
    set "out_file=%~1" & shift /1

    if "%out_file%" == "%in_file%" (
	echo Warning - %0 cowardly refuses to overwrite the input-file "%in_file%".
	goto :error_exit
    )

    rem Set tokens and values. Since we do not know how many token assignments
    rem we have to process, we pass the original parameter list to ztokens.
    rem ztokens is then responsible for ignoring any options, input and output
    rem parameters, and only parse the token assignments.

    call :ctokens
    call :ztokens %*

    if false == true (
	echo delim1="%delim1%
	echo delim2="%delim2%
	for /L %%I in (1,1,100) do if defined token_%%I (
	    call echo DEBUG token_%%I = '%%token_%%I%%', value_%%I = '%%value_%%I%%'
	)
	echo.
    )

    if exist "%out_file%" del "%out_file%"

    rem The for-loop ignores and skips empty lines. 'findstr' can be used to add
    rem a '<line-number>:' to every line of input, ensuring that we get a chance
    rem to process it.

    for /F "usebackq delims= tokens=1" %%I in (`findstr /n /r ".*" "%in_file%"`) do (
	set "str=%%I"
	call :subst
    )

    if not exist "%out_file%" goto :error_exit
    endlocal
    goto :exit
goto :EOF

rem ----------------------------------------------------------------------------
rem Clears tokens and values.
rem ----------------------------------------------------------------------------
:ctokens
    for /F %%V in ('set token_ 2^>NUL:') do set %%V=
    for /F %%V in ('set value_ 2^>NUL:') do set %%V=
goto :EOF

rem ----------------------------------------------------------------------------
rem Sets tokens and values.
rem ----------------------------------------------------------------------------
:ztokens [/delims XY] in-file out-file [token-assignment...]
    rem Ignore /delims option and value.
    if /i "%~1" == "/delims" shift & shift

    rem Ignore in-file and out-file.
    shift & shift

    rem Parse remaining arguments as token assignments.
    set n=1
:z1 while
    if "%~1" == "" goto :z2
	set "token_%n%=%~1" & shift
	set "value_%n%=%~1" & shift
	set /a n+=1
    goto :z1
:z2
    endlocal
goto :EOF

rem ----------------------------------------------------------------------------
rem Performs token substititions.
rem ----------------------------------------------------------------------------
:subst
    setlocal
    rem Remove '<line-number>:' from input string.
    set "str=%str:*:=%"

    rem Start substituting tokens and values.
    set n=1
:s1 while
    if not defined token_%n% goto :s2
	call set "s1=%delim1%%%token_%n%%%%delim2%"
	call set "s2=%%value_%n%%%"
	call set "str=%%str:%s1%=%s2%%%"
	echo.%str%>>"%out_file%"
	set /a n+=1
    goto :s1
:s2
    endlocal
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
