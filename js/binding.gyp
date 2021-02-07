{
  "targets": [
    {
      "target_name": "native",
      "sources": [
        "src/cpp/native.cpp"
      ],
      "include_dirs": [
        "<!@(node -p \"require('node-addon-api').include\")",
        "./include"

      ],
      "dependencies": [
        "<!(node -p \"require('node-addon-api').gyp\")"
      ],
      "libraries": [
        "<(module_root_dir)/include/mylib.o"
      ],
      "cflags!": [ "-fno-exceptions" ],
      "cflags_cc!": ["-fno-exceptions"],
      "defines": ["NAPI_CPP_EXCEPTIONS"]
    }
  ]
}