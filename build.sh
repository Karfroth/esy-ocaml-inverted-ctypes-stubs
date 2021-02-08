#! /bin/sh

set -e

esy install
esy dune build gen
esy dune exec gen/Gen.exe ./mylib
esy build
# mkdir -p js/include
# cp _esy/default/build/install/default/lib/mylib/mylib.o js/include/mylib.o
# cp _esy/default/build/install/default/lib/mylib/mylib.h js/include/mylib.h
# cp _esy/default/build/install/default/lib/mylib/mylibx.h js/include/mylibx.h

# cd js
# yarn install
# yarn build
# yarn re:build
# node src/res/test.bs.js