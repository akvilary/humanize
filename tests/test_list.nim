import std/unittest
import humanize/list
import humanize/locale
import humanize/lang/de

suite "naturalList":
  test "empty list":
    check naturalList(newSeq[string]()) == ""

  test "single item":
    check naturalList(["a"]) == "a"

  test "two items":
    check naturalList(["a", "b"]) == "a and b"

  test "three items":
    check naturalList(["a", "b", "c"]) == "a, b and c"

  test "four items":
    check naturalList(["a", "b", "c", "d"]) == "a, b, c and d"

  test "serial comma":
    let locale = Locale(
      name: "en-ox",
      pluralRule: prGermanic,
      ordinalRule: orEnglish,
      conjunction: "and",
      serialComma: true,
    )
    check naturalList(["a", "b", "c"], locale) == "a, b, and c"

  test "German locale":
    check naturalList(["a", "b", "c"], LangDe) == "a, b und c"
    check naturalList(["a", "b"], LangDe) == "a und b"
