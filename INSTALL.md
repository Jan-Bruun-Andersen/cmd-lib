Installation is pretty straightforward. Just run `install.cmd` with the name of
the directory where you want the cmd-lib utilites installed.

Personally, I put all my scripts and stuff in %UserProfile%\LocalTools. I also
like to keep the cmd-lib scripts in their own little directory called `cmd-lib.lib`,
so I use a command like this to install it all:

    C:> install "%UserProfile%\LocalTools\cmd-lib.lib"

The installer supports a couple of options:

    /? Show help text.
    /v Be verbose.
    /n Dry-run. Do not install, just show commands.
    
That's it!
