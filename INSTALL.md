Installation is pretty straightforward:

1. `configure`
2. `install`

By default, `configure` will prepare cmd-lib to be installed in

    %UserProfile%\LocalTools\cmd-lib.lib

If you want to install them somewhere else, run `configure` with the `/prefix`
option, e.g.

    configure /prefix "%AppData%\Local\Programs\cmd-lib"

before running `install`.

The installer supports a couple of options:

    /? Show help text.
    /v Be verbose.
    /n Dry-run. Do not install, just show commands.
    
That's it!
