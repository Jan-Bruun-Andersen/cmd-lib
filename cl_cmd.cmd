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
:: = EXAMPLE
:: =   ,---------------------------------------------------.
:: =   | @echo off                                         |
:: =   | call cl_cmd /ding /pause sh -c "./configure"      |
:: =   '---------------------------------------------------'

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    setlocal
    time >NUL: /t & rem Set ErrorLevel = 0.

    set "cl_cmd_wtitle="
    set "cl_cmd_opts=/C"
    set "cl_cmd_post="

:getopts
    if /i "%~1" == "/keep"	set "cl_cmd_opts=%cl_cmd_opts:/C=%"		& shift & goto :getopts
    if /i "%~1" == "/ding"	set "cl_cmd_post=%cl_cmd_post% ^& echo>&2 "   & shift & goto :getopts
    if /i "%~1" == "/pause"	set "cl_cmd_post=%cl_cmd_post% ^& pause"	& shift & goto :getopts

    set "cl_cmd_wtitle=%~1 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9"

    if 0%verbosity% geq 2 (echo Title:       %cl_cmd_wtitle%)
    if 0%verbosity% geq 1 (echo Directory:   %CD%)
    if 0%verbosity% geq 1 (echo Command:     %ComSpec% %cl_cmd_opts%)
    if 0%verbosity% geq 1 (echo.             %1 %2 %3 %4 %5 %6 %7 %8 %9 %cl_cmd_post%)

    (
    start "%cl_cmd_wtitle%" /i /wait ^
	"%ComSpec%" %cl_cmd_opts% %1 %2 %3 %4 %5 %6 %7 %8 %9 %cl_cmd_post%
    )
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
