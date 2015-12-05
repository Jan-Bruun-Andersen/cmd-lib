:cl_unpack_7z [/v] path-to-7z archive [dst-dir]

:: = DESCRIPTION
:: =   Unpacks an archive into a directory.
:: =
:: = OPTIONS
:: =   /v          Be verbose.
:: =
:: = PARAMETERS
:: =   path-to-7z   Path to the 7z archive program.
:: =   archive      Name of arhive file.
:: =   dst-dir      Name of directory where the files will be placed.
:: =
:: = EXAMPLE
:: =   ,-----------------------------------------------------.
:: =   | @echo off                                           |
:: =   | call cl_unpack_7z "C:\Programs\7z\7z.exe" files.zip |
:: =   '-----------------------------------------------------'
:: =
:: = SEE ALSO
:: =   cl_pack_7z

:: @author Jan Bruun Andersen
:: @version @(#) Version: 2015-12-05

    if "%~1" == "" echo>&2 Error in function '%0'. Parameter 1 ^(path-to-7z^) is null	& goto :error_exit
    if "%~2" == "" echo>&2 Error in function '%0'. Parameter 2 ^(archive) is null	& goto :error_exit

    setlocal
    time >NUL: /t & rem Set ErrorLevel = 0.

    set "v_nul=>NUL:"
    set "dir=."

    if /i "%~1" == "/v" set "v_nul=" & shift

    if not "%~3" == "" set "dir=%~3"

    rem Options used with 7z:
    rem
    rem   x         E(x)tract files with full paths.
    rem   -bb[0-3]  Set output log level.
    rem   -y        Assume (y)es on all queries (allows overwriting existing files).
    rem   -o{dir}   Set (o)utput directory.

    "%~1" x -bb1 -y -o"%dir%" "%~2" %v_nul%
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
