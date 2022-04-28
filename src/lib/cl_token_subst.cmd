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

    setlocal DisableDelayedExpansion
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

    if not exist "%in_file%" (
	echo>&2 ERROR - Input file "%in_file%" for %0 does not exist!
	goto :error_exit
    )

    if "%out_file%" == "%in_file%" (
	echo>&2 ERROR - %0 cowardly refuses to overwrite the input-file "%in_file%".
	goto :error_exit
    )

    if exist "%out_file%" del "%out_file%"

    rem OBS: We are NOT doing a 'call' since we are not interested in creating a
    rem      new parameter list. We have already parsed the original parameter
    rem      list for /delims, input and output file specifications. %1 and %2
    rem      are now poised to be used as the first set of token/value pairs.

    goto :do_gsar
goto :EOF

rem ------------------------------------------------------------------------
rem Perform token substititions using gsar (General Search and Replace) if
rem possible. Fallback is to use the slower 'do_fstr' method.
rem
rem First initialise the output file, then loop through the list of tokens
rem and do the required substitutions.
rem
rem OBS: gsar uses ':' to indicate a CTRL-char. Escaping is done by doubling
rem      up and changing ':' to '::'. Hence the %s2::=::% stuff.
rem ------------------------------------------------------------------------
:do_gsar
    rem Can gsar display the GNU General Public License?
    gsar -G >NUL: 2>&1 || goto :do_fstr

    setlocal

    type "%in_file%" > "%out_file%"

    :gsar
	if "%~1" == "" goto :EOF
	set "token=%~1" & shift /1
	set "value=%~1" & shift /1
	gsar -o -s"@%token::=::%@" -r"%value::=::%" "%out_file%" >NUL: || goto :error_exit
    goto :gsar

    endlocal
goto :exit

rem ----------------------------------------------------------------------------
rem Perform token substititions using findstr.
rem
rem findstr is used to prefix each line with a line-number. This is necessary
rem since the for-loop will ignore and skip empty lines. With a line number all
rem lines will be processed by the loop.
rem
rem First initialise the output file, then loop through the list of tokens
rem rotating the input file, and do the required substitutions.
rem ----------------------------------------------------------------------------
:do_fstr
    setlocal
    
    type "%in_file%" > "%out_file%"

    :fstr2
	if "%~1" == "" goto :EOF
	set "token=%~1" & shift /1
	set "value=%~1" & shift /1

	move "%out_file%" "%out_file%.tmp" >NUL:

	for /F "usebackq delims= tokens=1" %%I in (`findstr /n /r ".*" "%out_file%.tmp"`) do (
	    set "S=%%I"

	    rem Do the substition.
	    call set "S=%%S:%delim1%%token%%delim2%=%value%%%"

	    call :qecho
	) >> "%out_file%"
    goto :fstr2

    endlocal
goto :exit

rem ----------------------------------------------------------------------------
rem Perform token substititions using delayed expansion & findstr.
rem
rem First initialise the output file, then loop through the list of tokens
rem rotating the input file, and do the required substitutions.
rem
rem findstr is used to prefix each line with a line-number. This is necessary
rem since the for-loop will ignore and skip empty lines. With a line number all
rem lines will be processed by the loop.
rem
rem BUG: Using delayed expansion causes any ! charaters in the input lines
rem      to be treated as signaling a variable substition.
rem      Currently the workaround is to escape any ! in the input using ^!.
rem ----------------------------------------------------------------------------
:do_dxfstr
    setlocal EnableDelayedExpansion

    type "%in_file%" > "%out_file%"

    :dxfstr
	if "%~1" == "" goto :EOF
	set "token=%~1" & shift /1
	set "value=%~1" & shift /1

	move "%out_file%" "%out_file%.tmp" >NUL:

	for /F "usebackq delims= tokens=1" %%I in (`findstr /n /r ".*" "%out_file%.tmp"`) do (
	    set "S=%%I"

	    rem Do the substition.
	    set "S=!S:%delim1%%token%%delim2%=%value%!"

	    rem Remove the prefixed '<line-no>:'.
	    set "S=!S:*:=!"

	    echo.!S!>>"%out_file%"
	)
    goto :dxfstr

    del "%out_file%.tmp"

    endlocal
goto :exit

rem ----------------------------------------------------------------------------
rem Do a "quoted" echo.
rem
rem Certain characters and combinations of characters takes precedence over
rem the arguments to echo. These includes '&', '|', '<', '>' and the magic
rem words 'ON' and 'OFF'.
rem ----------------------------------------------------------------------------
:qecho
    setlocal

    rem Quote magic characters.
    set "S=%S:&=^&%"
    set "S=%S:|=^|%"
    set "S=%S:<=^<%"
    set "S=%S:>=^>%"

    rem Quote echo on/ECHO ON
    set "S=%S:echo on=echo ^o^n%"
    set "S=%S:ECHO ON=ECHO ^O^N%"

    rem Quote echo off/ECHO OFF
    set "S=%S:echo off=echo ^o^f^f%"
    set "S=%S:ECHO OFF=ECHO ^O^F^F%"

    rem Remove the prefixed '<line-no>:'.
    set "S=%S:*:=%"

    echo.%S%

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
