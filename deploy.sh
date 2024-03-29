#!/bin/sh

set -o errexit

echo "########## One-shot deployment"
rm deploy.php

echo "########## Check"
(cd .. && sha256sum -c site.tar.gz.sha256)

echo "########## Unpacking"
mkdir -p ../www2
if ! test -f ../site.tar.gz; then
    echo "ERROR: Unable to find site.tar.gz. Aborting."
    exit 1
fi
tar -xvzf ../site.tar.gz -C ../www2 --strip-components=1
test -f ../www2/sitemap.xml

echo "########## Backing up professional-powershell"
rsync --verbose --recursive ./professional-powershell ../www2

echo "########## Syncing"
rsync --verbose --recursive --delete-after ../www2/ ../www/

echo "########## Cleaning up"
rm -rfv ../www2/* ../www2/.htaccess
rmdir ../www2
rm ../site.tar.gz ../site.tar.gz.sha256