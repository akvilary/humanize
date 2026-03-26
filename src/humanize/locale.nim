## Locale types and English default locale for humanize.
##
## This module defines the core types used throughout the library:
## `PluralRule`, `OrdinalRule`, `Gender`, `Plurals`, `TimeUnits`,
## `NumberWord`, and `Locale`. It also provides `pluralize` for
## selecting the correct plural form and the built-in English locale.

type
  PluralRule* = enum
    ## Rule for selecting the plural form of a word.
    prGermanic    ## en, de, it, es: 1 -> one, else -> many
    prFrench      ## fr: 0-1 -> one, else -> many
    prSlavic      ## ru: complex rule with 11-14 exceptions
    prArabic      ## ar: 1->one, 2->few, 3-10->few, 11-99->many, 100+->few
    prInvariant   ## zh: always -> many

  OrdinalRule* = enum
    ## Rule for generating ordinal suffixes.
    orEnglish     ## 1st, 2nd, 3rd, 4th...
    orFrench      ## 1er/1re, 2e, 3e...
    orGerman      ## 1., 2., 3....
    orSpanish     ## 1.o/1.a, 2.o/2.a...
    orItalian     ## 1°/1ª, 2°/2ª...
    orRussian     ## 1-й, 2-й, 3-й...
    orChinese     ## 第1, 第2, 第3...
    orArabic      ## plain number (no suffix convention)

  Gender* = enum
    ## Grammatical gender for ordinals in gendered languages.
    gMasculine
    gFeminine

  Plurals* = object
    ## Three plural forms covering all shipped languages.
    one*: string   ## Singular form (count == 1)
    few*: string   ## Paucal form (used by Slavic languages, 2-4)
    many*: string  ## General plural form

  TimeUnits* = object
    ## Localized names for time units.
    years*: Plurals
    months*: Plurals
    weeks*: Plurals
    days*: Plurals
    hours*: Plurals
    minutes*: Plurals
    seconds*: Plurals
    milliseconds*: Plurals
    microseconds*: Plurals

  NumberWord* = object
    ## A large-number word with its threshold value.
    value*: float64
    name*: Plurals

  Locale* = object
    ## Complete locale for humanize formatting.
    ## All fields are value types or enums so Locale can be `const`.
    name*: string
    pluralRule*: PluralRule
    ordinalRule*: OrdinalRule
    timeUnits*: TimeUnits
    agoFmt*: string           ## e.g. "$1 ago" — $1 is replaced with delta
    fromNowFmt*: string       ## e.g. "$1 from now"
    justNow*: string          ## e.g. "just now"
    thousandsSep*: string     ## e.g. ","
    decimalSep*: string       ## e.g. "."
    numberWords*: seq[NumberWord]  ## for intWord: million, billion, etc.
    apWords*: seq[string]     ## AP style words for 1-9
    conjunction*: string      ## e.g. "and" for lists
    serialComma*: bool        ## Oxford comma in lists
    today*: string
    tomorrow*: string
    yesterday*: string

func pluralize*(
  n: int,
  forms: Plurals,
  rule: PluralRule,
): string =
  ## Select the correct plural form for count `n` using `rule`.
  ## Returns one of `forms.one`, `forms.few`, or `forms.many`.
  let absN = abs(n)
  case rule
  of prGermanic:
    if absN == 1: forms.one else: forms.many
  of prFrench:
    if absN in {0, 1}: forms.one else: forms.many
  of prSlavic:
    let mod10 = absN mod 10
    let mod100 = absN mod 100
    if mod10 == 1 and mod100 != 11:
      forms.one
    elif mod10 in {2, 3, 4} and mod100 notin {12, 13, 14}:
      forms.few
    else:
      forms.many
  of prArabic:
    let mod100 = absN mod 100
    if absN == 1:
      forms.one
    elif absN == 2:
      forms.few
    elif mod100 >= 3 and mod100 <= 10:
      forms.few
    else:
      forms.many
  of prInvariant:
    forms.many

const DefaultLocale* = Locale(
  name: "en",
  pluralRule: prGermanic,
  ordinalRule: orEnglish,
  timeUnits: TimeUnits(
    years: Plurals(one: "year", few: "years", many: "years"),
    months: Plurals(one: "month", few: "months", many: "months"),
    weeks: Plurals(one: "week", few: "weeks", many: "weeks"),
    days: Plurals(one: "day", few: "days", many: "days"),
    hours: Plurals(one: "hour", few: "hours", many: "hours"),
    minutes: Plurals(one: "minute", few: "minutes", many: "minutes"),
    seconds: Plurals(one: "second", few: "seconds", many: "seconds"),
    milliseconds: Plurals(
      one: "millisecond", few: "milliseconds", many: "milliseconds",
    ),
    microseconds: Plurals(
      one: "microsecond", few: "microseconds", many: "microseconds",
    ),
  ),
  agoFmt: "$1 ago",
  fromNowFmt: "$1 from now",
  justNow: "just now",
  thousandsSep: ",",
  decimalSep: ".",
  numberWords: @[
    NumberWord(
      value: 1e6,
      name: Plurals(one: "million", few: "million", many: "million"),
    ),
    NumberWord(
      value: 1e9,
      name: Plurals(one: "billion", few: "billion", many: "billion"),
    ),
    NumberWord(
      value: 1e12,
      name: Plurals(one: "trillion", few: "trillion", many: "trillion"),
    ),
    NumberWord(
      value: 1e15,
      name: Plurals(
        one: "quadrillion", few: "quadrillion", many: "quadrillion",
      ),
    ),
    NumberWord(
      value: 1e18,
      name: Plurals(
        one: "quintillion", few: "quintillion", many: "quintillion",
      ),
    ),
    NumberWord(
      value: 1e21,
      name: Plurals(one: "sextillion", few: "sextillion", many: "sextillion"),
    ),
    NumberWord(
      value: 1e24,
      name: Plurals(
        one: "septillion", few: "septillion", many: "septillion",
      ),
    ),
    NumberWord(
      value: 1e27,
      name: Plurals(one: "octillion", few: "octillion", many: "octillion"),
    ),
    NumberWord(
      value: 1e30,
      name: Plurals(one: "nonillion", few: "nonillion", many: "nonillion"),
    ),
    NumberWord(
      value: 1e33,
      name: Plurals(one: "decillion", few: "decillion", many: "decillion"),
    ),
  ],
  apWords: @["one", "two", "three", "four", "five", "six", "seven", "eight",
             "nine"],
  conjunction: "and",
  serialComma: false,
  today: "today",
  tomorrow: "tomorrow",
  yesterday: "yesterday",
)
