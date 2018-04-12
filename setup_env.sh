# Set these environment variables according to the 
# release you want to make
export major=17
export minor=11
export sub=5
export rel=1
export local_rel=2
export lsb_release=14.04
export lsb_codename=trusty
export version=${major}.${minor}.${sub}-${rel}fhcrc${local_rel}~ubuntu${lsb_release}

export DEBFULLNAME='Michael Gutteridge'
export DEBMAIL='mrg@fredhutch.org'
