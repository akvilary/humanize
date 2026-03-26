## Spanish locale for humanize.

import ../locale

const LocaleEs* = Locale(
  name: "es",
  pluralRule: prGermanic,
  ordinalRule: orSpanish,
  timeUnits: TimeUnits(
    years: Plurals(one: "a\xC3\xB1o", few: "a\xC3\xB1os", many: "a\xC3\xB1os"),
    months: Plurals(one: "mes", few: "meses", many: "meses"),
    weeks: Plurals(one: "semana", few: "semanas", many: "semanas"),
    days: Plurals(one: "d\xC3\xADa", few: "d\xC3\xADas", many: "d\xC3\xADas"),
    hours: Plurals(one: "hora", few: "horas", many: "horas"),
    minutes: Plurals(one: "minuto", few: "minutos", many: "minutos"),
    seconds: Plurals(one: "segundo", few: "segundos", many: "segundos"),
    milliseconds: Plurals(
      one: "milisegundo", few: "milisegundos", many: "milisegundos",
    ),
    microseconds: Plurals(
      one: "microsegundo", few: "microsegundos", many: "microsegundos",
    ),
  ),
  agoFmt: "hace $1",
  fromNowFmt: "en $1",
  justNow: "ahora mismo",
  thousandsSep: ".",
  decimalSep: ",",
  numberWords: @[
    NumberWord(
      value: 1e6,
      name: Plurals(
        one: "mill\xC3\xB3n", few: "millones", many: "millones",
      ),
    ),
    NumberWord(
      value: 1e12,
      name: Plurals(
        one: "bill\xC3\xB3n", few: "billones", many: "billones",
      ),
    ),
    NumberWord(
      value: 1e18,
      name: Plurals(
        one: "trill\xC3\xB3n", few: "trillones", many: "trillones",
      ),
    ),
  ],
  apWords: @["uno", "dos", "tres", "cuatro", "cinco", "seis", "siete",
             "ocho", "nueve"],
  conjunction: "y",
  serialComma: false,
  today: "hoy",
  tomorrow: "ma\xC3\xB1ana",
  yesterday: "ayer",
)
