#!/bin/bash

clear
cd blind-bash-rpg/
find usr/ -type f -exec md5sum {} \; > DEBIAN/md5sums
cd ..
dpkg-deb -b ./blind-bash-rpg/ ./Packages
