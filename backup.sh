#!/bin/bash

cd ~/docs/; git pull; cd ..

CDINTO=$(ls -l | cut -d" " -f 12 | grep docs)
cd $CDINTO; cd ..

tar -cvjSf docs.tar.bz2 docs/
gpg --encrypt -r "noopduck" docs.tar.bz2

mkdir ~/onedrive/backup/$(date +%Y-%m-%d)
mv docs.tar.bz2.gpg ~/onedrive/backup/$(date +%Y-%m-%d)/
rm docs.tar.bz2

exit


