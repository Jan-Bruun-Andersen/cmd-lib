:cl_init path

:: = DESCRIPTION
:: =   Initialised cmd-lib.
:: =
:: = PARAMETERS
:: =   path  full path off calling script.
:: =
:: = GLOBAL VARIABLES
:: =   cl_init   = Indicates if cmd-lib have already been initialized.
:: =               Set to true by cl_init.
:: =   PROG_FULL = Full path to calling script. Set by cl_init.
:: =   PROG_NAME = Name of calling script.      Set by cl_init.
:: =   PROG_DIR  = Directory of calling script. Set by cl_init.
:: =
:: = EXAMPLE
:: =   ,---------------------------------------------------.
:: =   | @echo off                                         |
:: =   | call cl_init "%~f0"                               |
:: =   | echo My full path is: "%PROG_FULL%                |
:: =   | echo My name is:      "%PROG_NAME%                |
:: =   | echo My directory is: "%PROG_DIR%                 |
:: =   '---------------------------------------------------'

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    if "%cl_init%" == "true" goto :no_error

    set "PROG_FULL=%~f1"
    set "PROG_NAME=%~n1"
    set "PROG_DIR=%~dp1"

    set "cl_init=true"
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
