:cl_pack_7z [/v] path-to-7z archive file-glob

:: = DESCRIPTION
:: =   Packs (adds) files an archive.
:: =
:: = OPTIONS
:: =   /v          Be verbose.
:: =
:: = PARAMETERS
:: =   path-to-7z   Path to the 7z program.
:: =   archive      Name of arhive file.
:: =   glob         Name of file(s) to archive.
:: =
:: = EXAMPLE
:: =   ,-----------------------------------------------------.
:: =   | @echo off                                           |
:: =   | call cl_pack_7z "C:\Programs\7z\7z.exe" files.zip * |
:: =   '-----------------------------------------------------'
:: =
:: = SEE ALSO
:: =   cl_unpack_7z

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    setlocal

    set "v_nul=>NUL:"
    set "type="

    if /i "%~1" == "/v" set "v_nul=" & shift

    set "type=%~x2"
    if "%type%" == "" (set type=7z) else (set type=%type:~1%)

    rem Options used with 7z:
    rem
    rem   a         (a)dd files to archive.
    rem   -bb[0-3]  Set output log level.
    rem   -t{type}  Set archive type.

    "%~1" a -bb1 -t%type% "%~2" "%~3" %v_nul%
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
