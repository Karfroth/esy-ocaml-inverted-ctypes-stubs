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

Napi::Number Fibonacci(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();

  int n = info[0].As<Napi::Number>().Int32Value();
  double res = lib_fib(n) * 1.0;

  return Napi::Number::New(env, res);
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
  initialize_ocaml();
  exports.Set(Napi::String::New(env, "greeting"),
              Napi::Function::New(env, Greeting));
  exports.Set(Napi::String::New(env, "fibonacci"),
              Napi::Function::New(env, Fibonacci));
  return exports;
}

NODE_API_MODULE(addon, Init)