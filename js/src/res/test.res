@module("../../build/Release/native") external greeting: string => string = "greeting"
Js.log(greeting("From ReScript & OCaml Native!"))