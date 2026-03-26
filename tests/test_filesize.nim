import std/unittest
import humanize/filesize

suite "naturalSize":
  test "bytes":
    check naturalSize(0'i64) == "0 Bytes"
    check naturalSize(1'i64) == "1 Byte"
    check naturalSize(999'i64) == "999 Bytes"

  test "SI units":
    check naturalSize(1000'i64) == "1.0 KB"
    check naturalSize(1_000_000'i64) == "1.0 MB"
    check naturalSize(1_000_000_000'i64) == "1.0 GB"
    check naturalSize(1_000_000_000_000'i64) == "1.0 TB"

  test "binary units":
    check naturalSize(1024'i64, binary = true) == "1.0 KiB"
    check naturalSize(1_048_576'i64, binary = true) == "1.0 MiB"
    check naturalSize(1_073_741_824'i64, binary = true) == "1.0 GiB"

  test "GNU units":
    check naturalSize(1024'i64, gnu = true) == "1.0K"
    check naturalSize(1_048_576'i64, gnu = true) == "1.0M"
    check naturalSize(1_073_741_824'i64, gnu = true) == "1.0G"

  test "negative values":
    check naturalSize(-1000'i64) == "-1.0 KB"
    check naturalSize(-1024'i64, binary = true) == "-1.0 KiB"

  test "float input":
    check naturalSize(1500.0) == "1.5 KB"
    check naturalSize(1_500_000.0) == "1.5 MB"

  test "custom format":
    check naturalSize(1_234_567'i64, format = "%.2f") == "1.23 MB"

suite "parseSize":
  test "plain bytes":
    check parseSize("100") == 100
    check parseSize("0") == 0

  test "bytes with suffix":
    check parseSize("100 bytes") == 100
    check parseSize("1 byte") == 1
    check parseSize("100 B") == 100

  test "SI units":
    check parseSize("1 KB") == 1_000
    check parseSize("1 MB") == 1_000_000
    check parseSize("1 GB") == 1_000_000_000
    check parseSize("1.5 GB") == 1_500_000_000

  test "binary units":
    check parseSize("1 KiB") == 1_024
    check parseSize("1 MiB") == 1_048_576
    check parseSize("1 GiB") == 1_073_741_824

  test "GNU with binary flag":
    check parseSize("1K", binary = true) == 1_024
    check parseSize("1M", binary = true) == 1_048_576

  test "GNU without binary flag":
    check parseSize("1K") == 1_000
    check parseSize("1M") == 1_000_000

  test "case insensitive":
    check parseSize("1 kb") == 1_000
    check parseSize("1 mb") == 1_000_000
    check parseSize("1 kib") == 1_024

  test "invalid raises ValueError":
    expect(ValueError):
      discard parseSize("")
    expect(ValueError):
      discard parseSize("abc")
    expect(ValueError):
      discard parseSize("1 XB")

suite "byte constants":
  test "SI constants":
    check KiloByte == 1_000'i64
    check MegaByte == 1_000_000'i64
    check GigaByte == 1_000_000_000'i64
    check TeraByte == 1_000_000_000_000'i64
    check PetaByte == 1_000_000_000_000_000'i64
    check ExaByte == 1_000_000_000_000_000_000'i64

  test "binary constants":
    check KibiByte == 1_024'i64
    check MebiByte == 1_048_576'i64
    check GibiByte == 1_073_741_824'i64
    check TebiByte == 1_099_511_627_776'i64
    check PebiByte == 1_125_899_906_842_624'i64
    check ExbiByte == 1_152_921_504_606_846_976'i64
