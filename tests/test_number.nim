import std/unittest
import humanize/number
import humanize/locale
import humanize/locales/de
import humanize/locales/fr

suite "ordinal":
  test "English basics":
    check ordinal(1) == "1st"
    check ordinal(2) == "2nd"
    check ordinal(3) == "3rd"
    check ordinal(4) == "4th"
    check ordinal(9) == "9th"
    check ordinal(10) == "10th"

  test "English teens":
    check ordinal(11) == "11th"
    check ordinal(12) == "12th"
    check ordinal(13) == "13th"

  test "English twenties":
    check ordinal(21) == "21st"
    check ordinal(22) == "22nd"
    check ordinal(23) == "23rd"
    check ordinal(24) == "24th"

  test "English large":
    check ordinal(100) == "100th"
    check ordinal(101) == "101st"
    check ordinal(111) == "111th"
    check ordinal(112) == "112th"
    check ordinal(113) == "113th"

  test "English negative":
    check ordinal(-1) == "-1st"
    check ordinal(-11) == "-11th"

  test "French masculine":
    check ordinal(1, gMasculine, LocaleFr) == "1er"
    check ordinal(2, gMasculine, LocaleFr) == "2e"
    check ordinal(10, gMasculine, LocaleFr) == "10e"

  test "French feminine":
    check ordinal(1, gFeminine, LocaleFr) == "1re"
    check ordinal(2, gFeminine, LocaleFr) == "2e"

  test "German":
    check ordinal(1, locale = LocaleDe) == "1."
    check ordinal(42, locale = LocaleDe) == "42."

suite "intComma":
  test "small numbers":
    check intComma(100) == "100"
    check intComma(999) == "999"

  test "thousands":
    check intComma(1000) == "1,000"
    check intComma(10000) == "10,000"
    check intComma(100000) == "100,000"

  test "large":
    check intComma(1000000) == "1,000,000"
    check intComma(1234567890) == "1,234,567,890"

  test "negative":
    check intComma(-1234) == "-1,234"
    check intComma(-1000000) == "-1,000,000"

  test "zero":
    check intComma(0) == "0"

  test "float":
    check intComma(1234567.89, 2) == "1,234,567.89"
    check intComma(1000.0, 2) == "1,000.00"

  test "German locale":
    check intComma(1000, LocaleDe) == "1.000"
    check intComma(1000000, LocaleDe) == "1.000.000"

suite "intWord":
  test "below million":
    check intWord(999_999'i64) == "999,999"
    check intWord(100'i64) == "100"

  test "millions":
    check intWord(1_000_000'i64) == "1.0 million"
    check intWord(1_200_000'i64) == "1.2 million"
    check intWord(5_000_000'i64) == "5.0 million"

  test "billions":
    check intWord(1_000_000_000'i64) == "1.0 billion"
    check intWord(2_500_000_000'i64) == "2.5 billion"

  test "trillions":
    check intWord(1_000_000_000_000'i64) == "1.0 trillion"

  test "negative":
    check intWord(-1_000_000'i64) == "-1.0 million"

suite "apNumber":
  test "1-9 returns words":
    check apNumber(1) == "one"
    check apNumber(2) == "two"
    check apNumber(5) == "five"
    check apNumber(9) == "nine"

  test "0 returns digit":
    check apNumber(0) == "0"

  test "10+ returns digits":
    check apNumber(10) == "10"
    check apNumber(100) == "100"

  test "negative returns digits":
    check apNumber(-1) == "-1"
