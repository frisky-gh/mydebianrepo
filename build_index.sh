#!/bin/sh

dpkg-scanpackages . /dev/null > Packages
gzip -9fk Packages
apt-ftparchive -c apt-ftparchive.conf release . > Release
rm -f Release.gpg InRelease
gpg -abs -o Release.gpg Release
gpg --clearsign -o InRelease Release

