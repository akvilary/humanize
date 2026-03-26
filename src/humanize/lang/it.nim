## Italian locale for humanize.

import ../locale

const LangIt* = Locale(
  name: "it",
  pluralRule: prGermanic,
  ordinalRule: orItalian,
  timeUnits: TimeUnits(
    years: Plurals(one: "anno", few: "anni", many: "anni"),
    months: Plurals(one: "mese", few: "mesi", many: "mesi"),
    weeks: Plurals(one: "settimana", few: "settimane", many: "settimane"),
    days: Plurals(one: "giorno", few: "giorni", many: "giorni"),
    hours: Plurals(one: "ora", few: "ore", many: "ore"),
    minutes: Plurals(one: "minuto", few: "minuti", many: "minuti"),
    seconds: Plurals(one: "secondo", few: "secondi", many: "secondi"),
    milliseconds: Plurals(
      one: "millisecondo", few: "millisecondi", many: "millisecondi",
    ),
    microseconds: Plurals(
      one: "microsecondo", few: "microsecondi", many: "microsecondi",
    ),
  ),
  agoFmt: "$1 fa",
  fromNowFmt: "tra $1",
  justNow: "proprio ora",
  thousandsSep: ".",
  decimalSep: ",",
  numberWords: @[
    NumberWord(
      value: 1e6,
      name: Plurals(one: "milione", few: "milioni", many: "milioni"),
    ),
    NumberWord(
      value: 1e9,
      name: Plurals(one: "miliardo", few: "miliardi", many: "miliardi"),
    ),
    NumberWord(
      value: 1e12,
      name: Plurals(one: "bilione", few: "bilioni", many: "bilioni"),
    ),
    NumberWord(
      value: 1e15,
      name: Plurals(one: "biliardo", few: "biliardi", many: "biliardi"),
    ),
    NumberWord(
      value: 1e18,
      name: Plurals(one: "trilione", few: "trilioni", many: "trilioni"),
    ),
  ],
  apWords: @["uno", "due", "tre", "quattro", "cinque", "sei", "sette",
             "otto", "nove"],
  conjunction: "e",
  serialComma: false,
  today: "oggi",
  tomorrow: "domani",
  yesterday: "ieri",
)
