# Package
version       = "0.2.0"
author        = "akvilary"
description   = "Human-readable formatting of numbers, file sizes, times, durations, and lists"
license       = "MIT"
srcDir        = "src"

# Dependencies
requires "nim >= 2.0.0"

task test, "Run test suite":
  exec "nim c -r --path:src tests/test_locale.nim"
  exec "nim c -r --path:src tests/test_filesize.nim"
  exec "nim c -r --path:src tests/test_number.nim"
  exec "nim c -r --path:src tests/test_list.nim"
  exec "nim c -r --path:src tests/test_time.nim"
  exec "nim c -r --path:src tests/test_duration.nim"
