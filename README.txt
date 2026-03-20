init:
	gpg --full-generate-key
	gog -k

	gpg --export -a > frisky-gh-repo.asc
	gpg --export > frisky-gh-repo.gpg

for update:
	dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
	apt-ftparchive -c apt-ftparchive.conf release . > Release
	rm -f Release.gpg InRelease
	gpg -abs -o Release.gpg Release
	gpg --clearsign -o InRelease Release

