#! /bin/sh

set -e

esy install
esy build
# mkdir -p js/include
rm -f js/mylib.node
cp _esy/default/build/default/mylib/mylib.so js/mylib.node
cd js
yarn install
yarn build
node src/test.bs.js