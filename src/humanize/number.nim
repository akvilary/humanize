## Number formatting for humanize.
##
## Provides `ordinal`, `intComma`, `intWord`, and `apNumber` for
## human-readable number formatting with locale support.

import std/[strutils, math]
import ./locale

func ordinal*(
  n: int,
  gender: Gender = gMasculine,
  locale: Locale = DefaultLocale,
): string =
  ## Convert an integer to its ordinal string representation.
  ##
  ## .. code-block:: nim
  ##   ordinal(1)  # "1st"
  ##   ordinal(2)  # "2nd"
  ##   ordinal(3)  # "3rd"
  ##   ordinal(11) # "11th"
  let s = $n
  case locale.ordinalRule
  of orEnglish:
    let absN = abs(n)
    let mod100 = absN mod 100
    let mod10 = absN mod 10
    if mod100 in {11, 12, 13}:
      s & "th"
    elif mod10 == 1:
      s & "st"
    elif mod10 == 2:
      s & "nd"
    elif mod10 == 3:
      s & "rd"
    else:
      s & "th"
  of orFrench:
    if abs(n) == 1:
      if gender == gFeminine: s & "re" else: s & "er"
    else:
      s & "e"
  of orGerman:
    s & "."
  of orSpanish:
    if gender == gFeminine: s & ".\xC2\xAA" else: s & ".\xC2\xBA"  # .ª / .º
  of orItalian:
    if gender == gFeminine: s & "\xC2\xAA" else: s & "\xC2\xBA"  # ª / º
  of orRussian:
    s & "-\xD0\xB9"  # -й
  of orChinese:
    "\xE7\xAC\xAC" & s  # 第
  of orArabic:
    s

func intComma*(
  n: int,
  locale: Locale = DefaultLocale,
): string =
  ## Format an integer with thousands separators.
  ##
  ## .. code-block:: nim
  ##   intComma(1000)    # "1,000"
  ##   intComma(1000000) # "1,000,000"
  let neg = n < 0
  let digits = $abs(n)
  let sep = locale.thousandsSep
  var s = ""
  for i in 0 ..< digits.len:
    if i > 0 and (digits.len - i) mod 3 == 0:
      s.add(sep)
    s.add(digits[i])
  if neg: "-" & s else: s

func intComma*(
  n: float64,
  ndigits: int = 2,
  locale: Locale = DefaultLocale,
): string =
  ## Format a float with thousands separators and decimal places.
  ##
  ## .. code-block:: nim
  ##   intComma(1234567.89) # "1,234,567.89"
  let neg = n < 0.0
  let absN = abs(n)
  let intPart = int(absN)
  let fracPart = absN - float64(intPart)
  var s = intComma(intPart, locale)
  if ndigits > 0:
    let frac = formatFloat(fracPart, ffDecimal, ndigits)
    # frac looks like "0.XX" — take everything after "0."
    s.add(locale.decimalSep)
    s.add(frac[2 .. ^1])
  if neg: "-" & s else: s

func intWord*(
  n: int64,
  locale: Locale = DefaultLocale,
): string =
  ## Convert a large integer to a human-readable word form.
  ##
  ## .. code-block:: nim
  ##   intWord(1_000_000)     # "1.0 million"
  ##   intWord(1_200_000)     # "1.2 million"
  ##   intWord(1_000_000_000) # "1.0 billion"
  let absN = abs(n).float64
  if absN < 1_000_000.0:
    return intComma(n.int, locale)
  # Find the largest matching word
  var bestIdx = -1
  for i in 0 ..< locale.numberWords.len:
    if absN >= locale.numberWords[i].value:
      bestIdx = i
  if bestIdx < 0:
    return intComma(n.int, locale)
  let word = locale.numberWords[bestIdx]
  let value = absN / word.value
  let intValue = int(value)
  let label = pluralize(intValue, word.name, locale.pluralRule)
  let formatted = formatFloat(value, ffDecimal, 1)
  let s = formatted & " " & label
  if n < 0: "-" & s else: s

func intWord*(
  n: float64,
  locale: Locale = DefaultLocale,
): string =
  ## Float overload of `intWord`.
  let absN = abs(n)
  if absN < 1_000_000.0:
    return intComma(int(n), locale)
  var bestIdx = -1
  for i in 0 ..< locale.numberWords.len:
    if absN >= locale.numberWords[i].value:
      bestIdx = i
  if bestIdx < 0:
    return intComma(int(n), locale)
  let word = locale.numberWords[bestIdx]
  let value = absN / word.value
  let intValue = int(value)
  let label = pluralize(intValue, word.name, locale.pluralRule)
  let formatted = formatFloat(value, ffDecimal, 1)
  let s = formatted & " " & label
  if n < 0.0: "-" & s else: s

func apNumber*(
  n: int,
  locale: Locale = DefaultLocale,
): string =
  ## For numbers 1-9, return the Associated Press style name.
  ## For other values, return the number as a string.
  ##
  ## .. code-block:: nim
  ##   apNumber(1)  # "one"
  ##   apNumber(10) # "10"
  if n >= 1 and n <= 9 and locale.apWords.len >= 9:
    locale.apWords[n - 1]
  else:
    $n
