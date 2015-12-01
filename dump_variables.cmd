:dump_variables

:: = DESCRIPTION
:: =   Displays a selection of variables.
:: =   Very handy when debugging.
:: =
:: = AUTHOR
:: =   Jan Bruun Andersen
:: =
:: = VERSION
:: =   2015-12-01

    if "%~1" == "" %0 .

    echo =======
    echo cwd            = "%CD%"
    echo tmp_dir        = "%tmp_dir%"

    echo PROG_FULL      = "%PROG_FULL%"
    echo PROG_DIR       = "%PROG_DIR%"
    echo PROG_NAME      = "%PROG_NAME%"
    echo PROG_CFG       = "%PROG_CFG%"

    if defined tmp_dir if exist %tmp_dir%\ (
	echo.
	dir %tmp_dir%
    )

    echo =======
goto :EOF

rem vim: set filetype=dosbatch tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab:
rem vim: set foldmethod=indent
