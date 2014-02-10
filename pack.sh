#!/bin/sh

python2 ./build.py

mkdir -p /tmp/pack_mosaic/
cp -r docroot/ /tmp/pack_mosaic/mosaic/
cp -r dep/ /tmp/pack_mosaic/mosaic/
sed -i -e "s/\.\/dep/\/dep/" /tmp/pack_mosaic/mosaic/index.html

pushd /tmp/pack_mosaic/ >/dev/null
zip -r mosaic.zip mosaic/ >/dev/null
mv mosaic.zip mosaic/
popd >/dev/null

tar -pczf mosaic.tar.gz -C /tmp/pack_mosaic/ mosaic/

rm -rf /tmp/pack_mosaic/