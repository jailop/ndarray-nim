version       = "0.1.1"
author        = "Jaime Lopez"
description   = "Nim bindings for ndarray-c library"
license       = "BSD-3-Clause"
srcDir        = "./src"
bin           = @["example"]
requires "nim >= 2.2"

task test, "Run all tests":
  exec "nim c -r tests/test_basic.nim"
  exec "nim c -r tests/test_operations.nim"
  exec "nim c -r tests/test_io.nim"

task docs, "Generate documentation":
  exec "nim doc --project --index:on --outdir:docs ndarray.nim"
  echo "Documentation generated in docs/ directory"
  echo "Open docs/index.html in your browser to view"

task clean, "Clean build artifacts":
  exec "rm -f tests/test_basic tests/test_operations tests/test_io"
  exec "rm -f test_ndarray_io.bin"
  exec "rm -f *.bin"
