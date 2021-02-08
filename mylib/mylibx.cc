#include "mylibx.h"

using namespace Napi;

void initialize_ocaml() {
  std::string argv = "";
  char *strValue = strdup(argv.c_str());
  caml_startup(&strValue);
}