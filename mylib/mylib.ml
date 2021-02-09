open Ctypes
open Foreign

(* Type Definitions *)
type napi_env = unit ptr
let napi_env: napi_env typ = ptr void
type napi_value = unit ptr
let napi_value: napi_value typ = ptr void
type napi_callback_info = unit ptr
let napi_callback_info: napi_callback_info typ = ptr void
type napi_callback
let napi_callback = funptr (napi_env @-> napi_callback_info @-> returning napi_value)

let napi_status = uint64_t

(* functions *)
let napi_get_version =
  foreign "napi_get_version" (napi_env @-> ptr uint32_t @-> returning napi_status)

let napi_create_string_utf8 = 
  foreign "napi_create_string_utf8" (napi_env @-> string @-> int @-> ptr(napi_value) @-> returning napi_status)
let napi_get_value_string_utf8 = 
  foreign "napi_get_value_string_utf8" (napi_env @-> napi_value @-> ptr_opt(char) @-> size_t @-> ptr(size_t) @-> returning napi_status)
let napi_get_cb_info =
  foreign "napi_get_cb_info" (napi_env @-> napi_callback_info @-> ptr(size_t) @-> ptr(napi_value) @-> ptr_opt(napi_value) @-> ptr_opt(ptr(void)) @-> returning napi_status)
let napi_create_function =
  foreign "napi_create_function" (napi_env @-> ptr(char) @-> size_t @-> napi_callback @-> ptr(void) @-> ptr(napi_value) @-> returning napi_status)
let napi_set_named_property =
  foreign "napi_set_named_property" (napi_env @-> napi_value @-> ptr char @-> napi_value @-> returning napi_status)
let napi_get_version =
  foreign "napi_get_version" (napi_env @-> ptr uint32_t @-> returning napi_status)

(* Helpers *)
  let toNAPIStr (env: napi_env) str =
  let strValue = allocate_n napi_value ~count: 1 in
  let resStatus = napi_create_string_utf8 env str (String.length str) strValue in
  strValue

let fromNAPIStr env napiStr =
  let strSizePtr = allocate size_t (Unsigned.Size_t.of_int 0)
  and strSizeReadPtr = allocate size_t (Unsigned.Size_t.of_int 0) in
  let resStatus = napi_get_value_string_utf8 env napiStr None (Unsigned.Size_t.of_int 0) strSizePtr in
  let newStrSize = Unsigned.Size_t.add (!@strSizePtr) Unsigned.Size_t.one in
  let strLength = Unsigned.Size_t.to_int newStrSize in
  let buf = allocate_n char ~count: (Unsigned.Size_t.to_int newStrSize) in
  let resStatus2 = napi_get_value_string_utf8 env napiStr (Some buf) newStrSize strSizeReadPtr in
  Ctypes.string_from_ptr ~length: strLength buf

let getArgsArr env cbInfo len =
  let sizeTLen = Unsigned.Size_t.of_int len in
  let sizeTLenPtr = allocate size_t sizeTLen
  and args = CArray.make napi_value len in
  let res = napi_get_cb_info env cbInfo sizeTLenPtr (CArray.start args) None None in
  args

let nativeIntToVoidPtr nat t =
  nat |> ptr_of_raw_address |> from_voidp t

(* Ocaml Function *)
let hello env cbInfo =
  let args = getArgsArr env cbInfo 1 in
  let strRaw = CArray.get args 0 in
  let str = fromNAPIStr env strRaw in
  let returnVal = "Hello " ^ str in
  !@(toNAPIStr env returnVal)

(* init NAPI *)
let lib_init envNat exportNat =
  let env = envNat |> ptr_of_raw_address in
  let exports = exportNat |> ptr_of_raw_address in
  let fn = allocate_n napi_value ~count: 1 in
  let fnName = "hello" |> CArray.of_string |> CArray.start in
  let fnNameLength = Unsigned.Size_t.of_int 5 in
  let fnCreateStatus = napi_create_function env fnName fnNameLength hello null fn in
  let napiSetStatus = napi_set_named_property env exports fnName !@fn in
  exportNat

let () =
  Callback.register "lib_init" lib_init