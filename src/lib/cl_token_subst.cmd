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
:: =
:: = BUGS
:: =   An unfortunate short-coming of cl_token_subst is that anything that
:: =   looks like delayed-expansion variables (e.g. !variable!) will also be
:: =   substituted/expanded. A work-around is to replace every ! with ^!.

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-07

    setlocal EnableDelayedExpansion
    time >NUL: /t & rem Set ErrorLevel = 0.

    set "delims=@@"
    set "delim1="
    set "delim2="

    if "%~1" == "/delims" set "delims=%~2" & shift & shift
    set "delim1=%delims:~0,1%"
    set "delim2=%delims:~1,1%"

    if "%~1" == "" echo>&2 Error in function '%0'. Parameter 1 ^(in-file^) is null.	& goto :error_exit
    if "%~2" == "" echo>&2 Error in function '%0'. Parameter 2 ^(out-file^) is null.	& goto :error_exit

    set "in_file=%~f1"  & shift
    set "out_file=%~f1" & shift

    for /L %%I in (1,1,6) do set "token%%I=" & set "value%%I="

    if not "%~1" == "" set "token1=%1" & set "value1=%~2" & shift & shift
    if not "%~1" == "" set "token2=%1" & set "value2=%~2" & shift & shift
    if not "%~1" == "" set "token3=%1" & set "value3=%~2" & shift & shift
    if not "%~1" == "" set "token4=%1" & set "value4=%~2" & shift & shift
    if not "%~1" == "" set "token5=%1" & set "value5=%~2" & shift & shift
    if not "%~1" == "" set "token6=%1" & set "value6=%~2" & shift & shift

    if true == false (
	echo delim1="%delim1%
	echo delim2="%delim2%
	echo.
	if defined token1 echo token1="%token1%", value1="%value1%"
	if defined token2 echo token2="%token2%", value2="%value2%"
	if defined token3 echo token3="%token3%", value3="%value3%"
	if defined token4 echo token4="%token4%", value4="%value4%"
	if defined token5 echo token5="%token5%", value5="%value5%"
	if defined token6 echo token6="%token6%", value6="%value6%"
    )

    if "%out_file%" == "%in_file%" (
	echo Warning - Cowardly refuses to overwrite "%out_file%".
	goto :error_exit
    )

    if exist "%out_file%" del "%out_file%"

    for /F "usebackq delims= tokens=1" %%I in (`findstr /n /r ".*" "%in_file%"`) do (
	set "S=I%%I"
	if defined token1 set "S=!S:%delim1%%token1%%delim2%=%value1%!"
	if defined token2 set "S=!S:%delim1%%token2%%delim2%=%value2%!"
	if defined token3 set "S=!S:%delim1%%token3%%delim2%=%value3%!"
	if defined token4 set "S=!S:%delim1%%token4%%delim2%=%value4%!"
	if defined token5 set "S=!S:%delim1%%token5%%delim2%=%value5%!"
	if defined token6 set "S=!S:%delim1%%token6%%delim2%=%value6%!"
	set "S=!S:*:=!"
	echo.!S!>>"%out_file%"
    )

    if not exist "%out_file%" goto :error_exit
    endlocal
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
