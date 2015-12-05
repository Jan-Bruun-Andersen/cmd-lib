:cl_pack_jar [/v] path-to-jar archive file-glob

:: = DESCRIPTION
:: =   Packs (adds) files an archive.
:: =
:: = OPTIONS
:: =   /v          Be verbose.
:: =
:: = PARAMETERS
:: =   path-to-jar  Path to the jar program.
:: =   archive      Name of arhive file.
:: =   glob         Name of file(s) to archive.
:: =
:: = EXAMPLE
:: =   ,-----------------------------------------------------.
:: =   | @echo off                                           |
:: =   | call cl_pack_jar "C:\Java\bin\jar.exe" files.zip *  |
:: =   '-----------------------------------------------------'
:: =
:: = SEE ALSO
:: =   cl_unpack_jar

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    setlocal

    set "v_opt="
    if /i "%~1" == "/v" set "v_opt=v" & shift

    rem Options used with jar:
    rem
    rem   c  (c)reate archive.
    rem   M  Do not create a (M)anifesst file.
    rem   v  Be (v)erbose.
    rem   f  Name of archive (f)ile to create..

    "%~1" cM%v_opt%f "%~2" "%~3"
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
