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

Napi::String Greeting(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();

  std::string str = info[0].As<Napi::String>().Utf8Value();
  const char *strValue = str.c_str();
  std::string res(lib_hello(strdup(strValue)));

  return Napi::String::New(env, res);
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
  initialize_ocaml();
  exports.Set(Napi::String::New(env, "greeting"),
              Napi::Function::New(env, Greeting));
  return exports;
}

NODE_API_MODULE(addon, Init)