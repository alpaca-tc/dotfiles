#!/bin/sh

rubysrcdir=$HOME/src/ruby
setuprb=$HOME/share/setup.rb
license=$HOME/share/LGPL
destdir=$HOME/var/i.loveruby.net/archive/refe
wcdir=$HOME/c

# work in clean dir to avoid CVS/Entry is written.
#
rm -rf tmp
mkdir tmp
cd tmp

# plain package
#
cvs -Q export -r`echo V$version | tr . -` -d refe-$version refe || exit 1
find refe-$version -name '.cvsignore' -exec rm {} \;
cp `which exectest` refe-$version/test.rb
chmod 644 refe-$version/test.rb
cp $setuprb refe-$version
cp $license refe-$version/COPYING
tar c refe-$version | gzip > $destdir/refe-$version.tar.gz

# with document database
#
REFE_DATA_DIR=`pwd`/refe-$version/data/refe
export REFE_DATA_DIR
mkrefe_rubyrefm ../src/man-rd-ja/*.rd
mkrefe_extrefm ../src/extrefm.rd
[ -d $wcdir/tmail ] && mkrefe_refrd --lang=ja $wcdir/tmail/doc/*.rrd.m
tar c refe-$version | gzip > $destdir/refe-$version-withdoc.tar.gz

# with source database
#
mkrefe_rubysrc $rubysrcdir
mkrefe_mfrelation $rubysrcdir
tar c refe-$version | gzip > $destdir/refe-$version-withdocsrc.tar.gz

# clean up
#
cd ..
rm -rf tmp
