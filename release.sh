#!/bin/bash
set -e

# Check version number.
version=$1
if semver $version > /dev/null; then
	echo "Releasing version: $version"
else
	echo "Version '$version' is not a valid semantic version" >&2
	exit 1
fi

# Set versions in NPM and Bower.
npm version $version
bower version $version

# Build.
grunt

# Commit version.
hg ci -m "Release version $version"
exit
# Push to central repo.
hg push
hg push github

# Release to NPM.
npm publish
