@module("../mylib") external hello: string => string = "hello"

Js.log(hello("From ReScript & OCaml Native!"))