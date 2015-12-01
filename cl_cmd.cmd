:cl_cmd [/nokeep] [/ding] [/pause] command [arguments...]

:: = DESCRIPTION
:: =   Runs a command with a pristine enviroment.
:: =
:: = OPTIONS:
:: =   /keep        Do not terminate after running the command.
:: =   /ding	    Emit a CTRL-G after the command has run but before the window is closed.
:: =   /pause	    Emit a CTRL-G after the command has run but before the window is closed.
:: =
:: = PARAMETERS
:: =   command      The command to run.
:: =   arguments... An optional list of arguments.
:: =
:: = GLOBAL VARIABLES
:: =   verbosity    Verbosity level (1..3). 
:: =   ComSpec      Name or path of the command processor. Current ComSpec=!ComSpec!.
:: =
:: = AUTHOR
:: =   Jan Bruun Andersen
:: =
:: = VERSION
:: =   2015-12-01

    setlocal
    time >NUL: /t

    set "cl_cmd_wtitle="
    set "cl_cmd_opts=/C"
    set "cl_cmd_post="

:getopts
    if /i "%~1" == "/keep"	set "cl_cmd_opts=%cl_cmd_opts:/C=%"		& shift & goto getopts
    if /i "%~1" == "/ding"	set "cl_cmd_post=%cl_cmd_post% ^& echo>&2 "   & shift & goto getopts
    if /i "%~1" == "/pause"	set "cl_cmd_post=%cl_cmd_post% ^& pause"	& shift & goto getopts

    set "cl_cmd_wtitle=%~1 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9"

    if 0%verbosity% geq 2 (echo Title:       %cl_cmd_wtitle%)
    if 0%verbosity% geq 1 (echo Directory:   %CD%)
    if 0%verbosity% geq 1 (echo Command:     %ComSpec% %cl_cmd_opts%)
    if 0%verbosity% geq 1 (echo.             %1 %2 %3 %4 %5 %6 %7 %8 %9 %cl_cmd_post%)

    (
    start "%cl_cmd_wtitle%" /i /wait ^
	"%ComSpec%" %cl_cmd_opts% %1 %2 %3 %4 %5 %6 %7 %8 %9 %cl_cmd_post%
    ) || echo Warning: command failed, errorlevel = %ERRORLEVEL%.

    endlocal
goto :EOF

:no_error
    time >NUL: /t
goto :EOF

:error_exit
    verify 2>NUL: other
goto :EOF

rem vim: set filetype=dosbatch tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab:
rem vim: set foldmethod=indent
