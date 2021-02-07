open Ctypes

module Stubs(I: Cstubs_inverted.INTERNAL) = struct
  let () = I.internal "lib_add" (int @-> int @-> returning(int)) Lib.Util.add
  let () = I.internal "lib_hello" (string @-> returning(string)) Lib.Util.hello
  let () = I.internal "lib_fib" (int @-> returning(int)) Lib.Util.fib
end