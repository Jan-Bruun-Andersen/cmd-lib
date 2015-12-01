:usage path-to-script [label}

:: = DESCRIPTION
:: =   Emits a single-line usage-description for this script using information
:: =   embedded in the :main label line.
:: =
:: = PARAMETERS
:: =
:: =   path-to-script  Path to script.
:: =
:: = AUTHOR
:: =   Jan Bruun Andersen
:: =
:: = VERSION
:: =   2015-12-01

    if "%~2" == "" call %0 %1 main & goto :EOF

    set "_=%~dp1;%PATH%"

    for /F "tokens=1,*" %%I in ('findstr /R "^:%~2" "%~$_:1"') do echo Usage: %~n1 %%J
goto :EOF

rem vim: set filetype=dosbatch tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab:
rem vim: set foldmethod=indent
