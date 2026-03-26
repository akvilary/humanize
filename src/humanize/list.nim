## List formatting for humanize.
##
## Provides `naturalList` for joining items in a human-readable way.

import ./locale

func naturalList*(
  items: openArray[string],
  locale: Locale = DefaultLocale,
): string =
  ## Join a list of strings in a human-readable way.
  ##
  ## .. code-block:: nim
  ##   naturalList(["a", "b", "c"])  # "a, b and c"
  ##   naturalList(["a", "b"])       # "a and b"
  ##   naturalList(["a"])            # "a"
  ##   naturalList([])               # ""
  case items.len
  of 0:
    ""
  of 1:
    items[0]
  of 2:
    items[0] & " " & locale.conjunction & " " & items[1]
  else:
    var s = ""
    for i in 0 ..< items.len - 1:
      if i > 0:
        s.add(", ")
      s.add(items[i])
    if locale.serialComma:
      s.add(",")
    s.add(" " & locale.conjunction & " ")
    s.add(items[^1])
    s
