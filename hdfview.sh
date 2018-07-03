#!/bin/bash

# Set up default variable values if not supplied by the user.
# This script file is used to execute the hdfview utility
# ... hdfview.root property is for the install location
# ...... default location is system property user.dir
# ... hdfview.workdir property is for the working location to find files
# ...... default location is system property user.home
#


export JAVABIN=/home/michele/Downloads/HDFView-3.0-centos7/HDFView-3.0.0-Linux/HDFView/3.0.0/jre/bin
export INSTALLDIR=/home/michele/Downloads/HDFView-3.0-centos7/HDFView-3.0.0-Linux/HDFView/3.0.0

$JAVABIN/java $JAVAOPTS -Xmx1024M -Djava.library.path="$INSTALLDIR/lib" -Dhdfview.root="$INSTALLDIR" -jar "$INSTALLDIR/lib/HDFView.jar" $*

# alternate invocation when using modules
#$JAVABIN/java $JAVAOPTS -Xmx1024M -Djava.library.path="$INSTALLDIR/lib:$INSTALLDIR/lib/ext" -Dhdfview.root="$INSTALLDIR" -cp "$INSTALLDIR/lib/jarhdf-3.99.0.jar:$INSTALLDIR/lib/jarhdf5-3.99.0.jar:$INSTALLDIR/lib/slf4j-nop-1.7.5.jar:$INSTALLDIR/lib/HDFView.jar" hdf.view.HDFView $*
