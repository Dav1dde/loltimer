#!/bin/sh

NAME=loltimer
python2 ./build.py

mkdir -p /tmp/pack_$NAME/
cp -r docroot/ /tmp/pack_$NAME/$NAME/
#cp -r dep/ /tmp/pack_$NAME/$NAME/
sed -i -e "s/\.\/dep/\/dep/" /tmp/pack_$NAME/$NAME/index.html

pushd /tmp/pack_$NAME/ >/dev/null
zip -r $NAME.zip $NAME/ >/dev/null
mv $NAME.zip $NAME/
popd >/dev/null

tar -pczf $NAME.tar.gz -C /tmp/pack_$NAME/ $NAME/

rm -rf /tmp/pack_$NAME/