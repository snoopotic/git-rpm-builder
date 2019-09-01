#!/bin/bash
# script run inside the container

ls -al rpmbuild/SOURCES/

spectool -g -R rpmbuild/SPECS/git.spec || exit 1

rpmbuild -ba rpmbuild/SPECS/git.spec || exit 1

./rpmsign.expect rpmbuild/RPMS/*/*.rpm || exit 1

[[ -d /data ]] || exit 0

sudo rm -rfv /data/output
sudo cp -av rpmbuild/RPMS /data/output

