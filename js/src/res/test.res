@module("../../build/Release/native") external greeting: string => string = "greeting"
@module("../../build/Release/native") external fibonacci: int => int = "fibonacci"

Js.log(greeting("From ReScript & OCaml Native!"))
Js.log2("fibonacci(10)", fibonacci(10))