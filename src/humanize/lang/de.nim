## German locale for humanize.

import ../locale

const LangDe* = Locale(
  name: "de",
  pluralRule: prGermanic,
  ordinalRule: orGerman,
  timeUnits: TimeUnits(
    years: Plurals(one: "Jahr", few: "Jahre", many: "Jahre"),
    months: Plurals(one: "Monat", few: "Monate", many: "Monate"),
    weeks: Plurals(one: "Woche", few: "Wochen", many: "Wochen"),
    days: Plurals(one: "Tag", few: "Tage", many: "Tage"),
    hours: Plurals(one: "Stunde", few: "Stunden", many: "Stunden"),
    minutes: Plurals(one: "Minute", few: "Minuten", many: "Minuten"),
    seconds: Plurals(one: "Sekunde", few: "Sekunden", many: "Sekunden"),
    milliseconds: Plurals(
      one: "Millisekunde", few: "Millisekunden", many: "Millisekunden",
    ),
    microseconds: Plurals(
      one: "Mikrosekunde", few: "Mikrosekunden", many: "Mikrosekunden",
    ),
  ),
  agoFmt: "vor $1",
  fromNowFmt: "in $1",
  justNow: "gerade eben",
  thousandsSep: ".",
  decimalSep: ",",
  numberWords: @[
    NumberWord(
      value: 1e6,
      name: Plurals(one: "Million", few: "Millionen", many: "Millionen"),
    ),
    NumberWord(
      value: 1e9,
      name: Plurals(one: "Milliarde", few: "Milliarden", many: "Milliarden"),
    ),
    NumberWord(
      value: 1e12,
      name: Plurals(one: "Billion", few: "Billionen", many: "Billionen"),
    ),
    NumberWord(
      value: 1e15,
      name: Plurals(
        one: "Billiarde", few: "Billiarden", many: "Billiarden",
      ),
    ),
    NumberWord(
      value: 1e18,
      name: Plurals(one: "Trillion", few: "Trillionen", many: "Trillionen"),
    ),
  ],
  apWords: @["eins", "zwei", "drei", "vier", "f\xC3\xBCnf", "sechs",
             "sieben", "acht", "neun"],
  conjunction: "und",
  serialComma: false,
  today: "heute",
  tomorrow: "morgen",
  yesterday: "gestern",
)
