#include <napi.h>
#include <string.h>

extern "C" {
    #include <mylib.h>
    #include <caml/callback.h>
}

using namespace Napi;

void initialize_ocaml() {
  std::string argv = "";
  char *strValue = strdup(argv.c_str());
  caml_startup(&strValue);
}

Napi::String HelloWorld(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();

  const char *strValue = info[0].As<Napi::String>().Utf8Value().c_str();
  std::string res(lib_hello(strdup(strValue)));

  return Napi::String::New(env, res);
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
  initialize_ocaml();
  exports.Set(Napi::String::New(env, "HelloWorld"),
              Napi::Function::New(env, HelloWorld));
  return exports;
}

NODE_API_MODULE(addon, Init)