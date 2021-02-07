#! /bin/sh
esy install &&
esy dune build gen &&
esy dune exec gen/Gen.exe ./mylib &&
esy build &&
g++ \
-I _esy/default/build/install/default/lib/mylib \
-L _esy/default/build/install/default/lib/mylib \
client/asdf.cpp \
_esy/default/build/install/default/lib/mylib/mylib.o \
-Wl,--no-as-needed -ldl -lm &&
LD_LIBRARY_PATH=_esy/default/build/install/default/lib/mylib ./a.out