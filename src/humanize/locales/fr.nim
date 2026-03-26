## French locale for humanize.

import ../locale

const LocaleFr* = Locale(
  name: "fr",
  pluralRule: prFrench,
  ordinalRule: orFrench,
  timeUnits: TimeUnits(
    years: Plurals(one: "an", few: "ans", many: "ans"),
    months: Plurals(one: "mois", few: "mois", many: "mois"),
    weeks: Plurals(one: "semaine", few: "semaines", many: "semaines"),
    days: Plurals(one: "jour", few: "jours", many: "jours"),
    hours: Plurals(one: "heure", few: "heures", many: "heures"),
    minutes: Plurals(one: "minute", few: "minutes", many: "minutes"),
    seconds: Plurals(one: "seconde", few: "secondes", many: "secondes"),
    milliseconds: Plurals(
      one: "milliseconde", few: "millisecondes", many: "millisecondes",
    ),
    microseconds: Plurals(
      one: "microseconde", few: "microsecondes", many: "microsecondes",
    ),
  ),
  agoFmt: "il y a $1",
  fromNowFmt: "dans $1",
  justNow: "\xC3\xA0 l'instant",
  thousandsSep: "\xE2\x80\xAF",  # narrow no-break space U+202F
  decimalSep: ",",
  numberWords: @[
    NumberWord(
      value: 1e6,
      name: Plurals(one: "million", few: "millions", many: "millions"),
    ),
    NumberWord(
      value: 1e9,
      name: Plurals(one: "milliard", few: "milliards", many: "milliards"),
    ),
    NumberWord(
      value: 1e12,
      name: Plurals(one: "billion", few: "billions", many: "billions"),
    ),
    NumberWord(
      value: 1e15,
      name: Plurals(one: "billiard", few: "billiards", many: "billiards"),
    ),
    NumberWord(
      value: 1e18,
      name: Plurals(one: "trillion", few: "trillions", many: "trillions"),
    ),
  ],
  apWords: @["un", "deux", "trois", "quatre", "cinq", "six", "sept", "huit",
             "neuf"],
  conjunction: "et",
  serialComma: false,
  today: "aujourd'hui",
  tomorrow: "demain",
  yesterday: "hier",
)
