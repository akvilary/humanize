## File size formatting for humanize.
##
## Provides `naturalSize` for human-readable file sizes and `parseSize`
## for parsing size strings back to bytes. No locale dependency — decimal
## separator is always "." and units are international.

import std/[strutils, math]

const
  Byte* = 1'i64
  KiloByte* = 1_000'i64
  MegaByte* = 1_000_000'i64
  GigaByte* = 1_000_000_000'i64
  TeraByte* = 1_000_000_000_000'i64
  PetaByte* = 1_000_000_000_000_000'i64
  ExaByte* = 1_000_000_000_000_000_000'i64

  KibiByte* = 1_024'i64
  MebiByte* = 1_048_576'i64
  GibiByte* = 1_073_741_824'i64
  TebiByte* = 1_099_511_627_776'i64
  PebiByte* = 1_125_899_906_842_624'i64
  ExbiByte* = 1_152_921_504_606_846_976'i64

const
  siSuffixes = ["Bytes", "KB", "MB", "GB", "TB", "PB", "EB"]
  binarySuffixes = ["Bytes", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"]
  gnuSuffixes = ["", "K", "M", "G", "T", "P", "E"]

func formatValue(value: float64, format: string): string =
  ## Minimal printf-style formatter supporting "%.Nf".
  var precision = 1
  if format.len > 0 and format[0] == '%':
    let dotIdx = format.find('.')
    let fIdx = format.find('f')
    if dotIdx >= 0 and fIdx > dotIdx:
      precision = parseInt(format[dotIdx + 1 ..< fIdx])
  formatFloat(value, ffDecimal, precision)

func naturalSize*(
  bytes: int64,
  binary: bool = false,
  gnu: bool = false,
  format: string = "%.1f",
): string =
  ## Format a byte count as a human-readable file size.
  ##
  ## .. code-block:: nim
  ##   naturalSize(1_000_000)                # "1.0 MB"
  ##   naturalSize(1_000_000, binary = true) # "976.6 KiB"
  ##   naturalSize(1_000_000, gnu = true)    # "976.6K"
  ##   naturalSize(1)                        # "1 Byte"
  let base: float64 = if binary or gnu: 1024.0 else: 1000.0
  let suffixes = if gnu: gnuSuffixes
                 elif binary: binarySuffixes
                 else: siSuffixes
  let neg = bytes < 0
  var value = abs(bytes).float64
  var idx = 0
  while value >= base and idx < suffixes.high:
    value /= base
    inc idx
  let prefix = if neg: "-" else: ""
  if idx == 0 and not gnu:
    # Bytes — no decimal
    let n = abs(bytes)
    if n == 1:
      prefix & "1 Byte"
    else:
      prefix & $n & " Bytes"
  elif gnu:
    if idx == 0:
      prefix & formatValue(value, format)
    else:
      prefix & formatValue(value, format) & suffixes[idx]
  else:
    prefix & formatValue(value, format) & " " & suffixes[idx]

func naturalSize*(
  bytes: float64,
  binary: bool = false,
  gnu: bool = false,
  format: string = "%.1f",
): string =
  ## Float overload of `naturalSize`.
  let base: float64 = if binary or gnu: 1024.0 else: 1000.0
  let suffixes = if gnu: gnuSuffixes
                 elif binary: binarySuffixes
                 else: siSuffixes
  let neg = bytes < 0.0
  var value = abs(bytes)
  var idx = 0
  while value >= base and idx < suffixes.high:
    value /= base
    inc idx
  let prefix = if neg: "-" else: ""
  if idx == 0 and not gnu:
    let n = int64(abs(bytes))
    if n == 1:
      prefix & "1 Byte"
    else:
      prefix & formatValue(value, format) & " Bytes"
  elif gnu:
    if idx == 0:
      prefix & formatValue(value, format)
    else:
      prefix & formatValue(value, format) & suffixes[idx]
  else:
    prefix & formatValue(value, format) & " " & suffixes[idx]

type
  SuffixInfo = object
    suffix: string
    multiplier: int64

const suffixTable = [
  # Binary suffixes (unambiguous)
  SuffixInfo(suffix: "kib", multiplier: KibiByte),
  SuffixInfo(suffix: "mib", multiplier: MebiByte),
  SuffixInfo(suffix: "gib", multiplier: GibiByte),
  SuffixInfo(suffix: "tib", multiplier: TebiByte),
  SuffixInfo(suffix: "pib", multiplier: PebiByte),
  SuffixInfo(suffix: "eib", multiplier: ExbiByte),
  # SI suffixes
  SuffixInfo(suffix: "kb", multiplier: KiloByte),
  SuffixInfo(suffix: "mb", multiplier: MegaByte),
  SuffixInfo(suffix: "gb", multiplier: GigaByte),
  SuffixInfo(suffix: "tb", multiplier: TeraByte),
  SuffixInfo(suffix: "pb", multiplier: PetaByte),
  SuffixInfo(suffix: "eb", multiplier: ExaByte),
  # Word suffixes
  SuffixInfo(suffix: "kilobyte", multiplier: KiloByte),
  SuffixInfo(suffix: "kilobytes", multiplier: KiloByte),
  SuffixInfo(suffix: "megabyte", multiplier: MegaByte),
  SuffixInfo(suffix: "megabytes", multiplier: MegaByte),
  SuffixInfo(suffix: "gigabyte", multiplier: GigaByte),
  SuffixInfo(suffix: "gigabytes", multiplier: GigaByte),
  SuffixInfo(suffix: "terabyte", multiplier: TeraByte),
  SuffixInfo(suffix: "terabytes", multiplier: TeraByte),
  SuffixInfo(suffix: "petabyte", multiplier: PetaByte),
  SuffixInfo(suffix: "petabytes", multiplier: PetaByte),
  SuffixInfo(suffix: "exabyte", multiplier: ExaByte),
  SuffixInfo(suffix: "exabytes", multiplier: ExaByte),
  SuffixInfo(suffix: "kibibyte", multiplier: KibiByte),
  SuffixInfo(suffix: "kibibytes", multiplier: KibiByte),
  SuffixInfo(suffix: "mebibyte", multiplier: MebiByte),
  SuffixInfo(suffix: "mebibytes", multiplier: MebiByte),
  SuffixInfo(suffix: "gibibyte", multiplier: GibiByte),
  SuffixInfo(suffix: "gibibytes", multiplier: GibiByte),
  SuffixInfo(suffix: "tebibyte", multiplier: TebiByte),
  SuffixInfo(suffix: "tebibytes", multiplier: TebiByte),
  SuffixInfo(suffix: "pebibyte", multiplier: PebiByte),
  SuffixInfo(suffix: "pebibytes", multiplier: PebiByte),
  SuffixInfo(suffix: "exbibyte", multiplier: ExbiByte),
  SuffixInfo(suffix: "exbibytes", multiplier: ExbiByte),
  # Byte
  SuffixInfo(suffix: "byte", multiplier: Byte),
  SuffixInfo(suffix: "bytes", multiplier: Byte),
  SuffixInfo(suffix: "b", multiplier: Byte),
]

const gnuSuffixTable = [
  SuffixInfo(suffix: "k", multiplier: KibiByte),
  SuffixInfo(suffix: "m", multiplier: MebiByte),
  SuffixInfo(suffix: "g", multiplier: GibiByte),
  SuffixInfo(suffix: "t", multiplier: TebiByte),
  SuffixInfo(suffix: "p", multiplier: PebiByte),
  SuffixInfo(suffix: "e", multiplier: ExbiByte),
]

const gnuSuffixTableSI = [
  SuffixInfo(suffix: "k", multiplier: KiloByte),
  SuffixInfo(suffix: "m", multiplier: MegaByte),
  SuffixInfo(suffix: "g", multiplier: GigaByte),
  SuffixInfo(suffix: "t", multiplier: TeraByte),
  SuffixInfo(suffix: "p", multiplier: PetaByte),
  SuffixInfo(suffix: "e", multiplier: ExaByte),
]

proc parseSize*(
  text: string,
  binary: bool = false,
): int64 =
  ## Parse a human-readable file size string to bytes.
  ##
  ## .. code-block:: nim
  ##   parseSize("1 MB")            # 1_000_000
  ##   parseSize("1 MiB")           # 1_048_576
  ##   parseSize("1M", binary=true) # 1_048_576
  ##   parseSize("1.5 GB")          # 1_500_000_000
  ##
  ## Raises `ValueError` on unparseable input.
  let stripped = text.strip()
  if stripped.len == 0:
    raise newException(ValueError, "empty size string")
  # Split into numeric and suffix parts
  var numEnd = 0
  var hasDecimal = false
  if numEnd < stripped.len and stripped[numEnd] == '-':
    inc numEnd
  while numEnd < stripped.len:
    if stripped[numEnd] in {'0'..'9'}:
      inc numEnd
    elif stripped[numEnd] == '.' and not hasDecimal:
      hasDecimal = true
      inc numEnd
    else:
      break
  if numEnd == 0:
    raise newException(ValueError, "no numeric value in: " & text)
  let numStr = stripped[0 ..< numEnd]
  let suffix = stripped[numEnd .. ^1].strip().toLowerAscii()
  let numVal = parseFloat(numStr)
  if suffix.len == 0:
    return int64(numVal)
  # Try exact suffix table first
  for entry in suffixTable:
    if suffix == entry.suffix:
      return int64(numVal * float64(entry.multiplier))
  # Try single-letter GNU suffixes
  if suffix.len == 1:
    let table = if binary: gnuSuffixTable else: gnuSuffixTableSI
    for entry in table:
      if suffix == entry.suffix:
        return int64(numVal * float64(entry.multiplier))
  raise newException(ValueError, "unknown size suffix: " & suffix)
