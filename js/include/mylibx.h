#include <napi.h>
#include <string.h>

extern "C" {
    #include "mylib.h"
    #include <caml/callback.h>
}

void initialize_ocaml();