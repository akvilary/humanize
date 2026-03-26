import std/unittest
import humanize/number
import humanize/locale
import humanize/lang/de
import humanize/lang/fr

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
    check ordinal(1, gMasc, LangFr) == "1er"
    check ordinal(2, gMasc, LangFr) == "2e"
    check ordinal(10, gMasc, LangFr) == "10e"

  test "French feminine":
    check ordinal(1, gFem, LangFr) == "1re"
    check ordinal(2, gFem, LangFr) == "2e"

  test "German":
    check ordinal(1, locale = LangDe) == "1."
    check ordinal(42, locale = LangDe) == "42."

suite "numComma":
  test "small numbers":
    check numComma(100) == "100"
    check numComma(999) == "999"

  test "thousands":
    check numComma(1000) == "1,000"
    check numComma(10000) == "10,000"
    check numComma(100000) == "100,000"

  test "large":
    check numComma(1000000) == "1,000,000"
    check numComma(1234567890) == "1,234,567,890"

  test "negative":
    check numComma(-1234) == "-1,234"
    check numComma(-1000000) == "-1,000,000"

  test "zero":
    check numComma(0) == "0"

  test "float":
    check numComma(1234567.89, 2) == "1,234,567.89"
    check numComma(1000.0, 2) == "1,000.00"

  test "German locale":
    check numComma(1000, LangDe) == "1.000"
    check numComma(1000000, LangDe) == "1.000.000"

suite "numWord":
  test "below million":
    check numWord(999_999'i64) == "999,999"
    check numWord(100'i64) == "100"

  test "millions":
    check numWord(1_000_000'i64) == "1.0 million"
    check numWord(1_200_000'i64) == "1.2 million"
    check numWord(5_000_000'i64) == "5.0 million"

  test "billions":
    check numWord(1_000_000_000'i64) == "1.0 billion"
    check numWord(2_500_000_000'i64) == "2.5 billion"

  test "trillions":
    check numWord(1_000_000_000_000'i64) == "1.0 trillion"

  test "negative":
    check numWord(-1_000_000'i64) == "-1.0 million"

suite "numName":
  test "1-9 returns words":
    check numName(1) == "one"
    check numName(2) == "two"
    check numName(5) == "five"
    check numName(9) == "nine"

  test "0 returns digit":
    check numName(0) == "0"

  test "10+ returns digits":
    check numName(10) == "10"
    check numName(100) == "100"

  test "negative returns digits":
    check numName(-1) == "-1"
