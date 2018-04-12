# Slurm Packaging - Customised for FHCRC

These are the files necessary to create a package for Ubuntu.  Note that the
master branch is empty: all of the files are on branches that are named
according to the Ubuntu distribution codename (i.e. `trusty` or `xenial`)

## setup_env.sh

Edit this file to reflect the version and platform you are building for. Then source this into your environment with `./setup_env.sh` 

## Using the Makefile

The makefile contains steps to build packages.  While `make deb` is intended to do everything from start to finish, currently its necessary to run steps manually as some of the dependencies don't appear to work correctly.

    make tld         # Creates top-level directory based on build version
    make source      # Checks out source
    make packaging   # Checks out packaging (this repo) into build
    make plugins     # Adds Hutch-specific plugins
    make tarball     # Makes the "orig.tar.gz" file
    make deb         # _Finally_ builds the package

### New Release

The makefile has another target used when building a new release. This updates
the changelog with the new version and prompts you to document the new release.

To create this new package release, update the environment with the new version numbers- editing the setup_env.sh script is a good way to go.

Then run `make version`.  This will check out the packaging files to the head
of the branch indicated by `$lsb_codename`, use `debchange` to update the
release (which is where you will edit the changelog to include release
details).  The updates are then checked in, tagged with the appropriate version
tag, and everything pushed upstream.
