# Slurm Packaging - Customised for FHCRC

These are the files necessary to create a package for Ubuntu.  Note that the
master branch is empty: all of the files are on branches that are named
according to the version of the package to be built.

 $(major).$(minor).$(sub)_$(rel)fhcrc$(local_rel)_$(distribution)

This should roughly match the version indicated in the changelog.  For
example, if the version in the changelog is:

    slurm-llnl (16.05.11-1fhcrc1) trusty; urgency=medium

then use a tag name `16.05.11_1fhcrc1_trusty`

