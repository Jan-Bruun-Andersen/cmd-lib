:cl_unpack_jar [/v] path-to-jar archive [dst-dir]

:: = DESCRIPTION
:: =   Unpacks an archive.
:: =
:: = OPTIONS
:: =   /v          Be verbose.
:: =
:: = PARAMETERS
:: =   path-to-jar  Path to the jar program.
:: =   archive      Name of arhive file.
:: =   dst-dir      Name of directory where the files will be placed.
:: =
:: = EXAMPLE
:: =   ,-----------------------------------------------------.
:: =   | @echo off                                           |
:: =   | call cl_unpack_jar "C:\Java\bin\jar.exe" files.zip  |
:: =   '-----------------------------------------------------'
:: =
:: = SEE ALSO
:: =   cl_pack_jar

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    if "%~1" == "" echo>&2 Error in function '%0'. Parameter 1 ^(path-to-jar^) is null	& goto :error_exit
    if "%~2" == "" echo>&2 Error in function '%0'. Parameter 2 ^(archive) is null	& goto :error_exit

    setlocal
    time >NUL: /t & rem Set ErrorLevel = 0.

    set "v_opt="
    set "dir=."

    if /i "%~1" == "/v" set "v_opt=v" & shift

    if not "%~3" == "" set "dir=%~3"

    rem Options used with jar:
    rem
    rem   x  E(x)tract from archive.
    rem   v  Be (v)erbose.
    rem   f  Name of archive (f)ile to unpack.

    pushd "%dir%"
    "%~1" x%v_opt%f "%~2"
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
