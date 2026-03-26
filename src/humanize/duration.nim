## Precise duration formatting for humanize.
##
## Provides `preciseDelta` for multi-unit, precise duration strings.

import std/[times, strutils, math]
import ./locale
import ./list

type
  DurationUnit* = enum
    ## Units that can be included in preciseDelta output.
    duYears
    duMonths
    duWeeks
    duDays
    duHours
    duMinutes
    duSeconds
    duMilliseconds
    duMicroseconds

const
  usPerMs = 1_000'i64
  usPerSecond = 1_000_000'i64
  usPerMinute = 60 * usPerSecond
  usPerHour = 60 * usPerMinute
  usPerDay = 24 * usPerHour
  usPerWeek = 7 * usPerDay
  usPerMonth = int64(30.5 * float64(usPerDay))
  usPerYear = int64(365.25 * float64(usPerDay))

func getUnitPlurals(unit: DurationUnit, locale: Locale): Plurals =
  case unit
  of duYears: locale.timeUnits.years
  of duMonths: locale.timeUnits.months
  of duWeeks: locale.timeUnits.weeks
  of duDays: locale.timeUnits.days
  of duHours: locale.timeUnits.hours
  of duMinutes: locale.timeUnits.minutes
  of duSeconds: locale.timeUnits.seconds
  of duMilliseconds: locale.timeUnits.milliseconds
  of duMicroseconds: locale.timeUnits.microseconds

func getUnitMicroseconds(unit: DurationUnit): int64 =
  case unit
  of duYears: usPerYear
  of duMonths: usPerMonth
  of duWeeks: usPerWeek
  of duDays: usPerDay
  of duHours: usPerHour
  of duMinutes: usPerMinute
  of duSeconds: usPerSecond
  of duMilliseconds: usPerMs
  of duMicroseconds: 1'i64

func formatValue(value: float64, format: string): string =
  var precision = 2
  if format.len > 0 and format[0] == '%':
    let dotIdx = format.find('.')
    let fIdx = format.find('f')
    if dotIdx >= 0 and fIdx > dotIdx:
      precision = parseInt(format[dotIdx + 1 ..< fIdx])
  formatFloat(value, ffDecimal, precision)

func preciseDelta*(
  duration: Duration,
  minimumUnit: DurationUnit = duSeconds,
  suppress: seq[DurationUnit] = default(seq[DurationUnit]),
  format: string = "%.2f",
  locale: Locale = LangEn,
): string =
  ## Convert a Duration to a precise, multi-unit human-readable string.
  ##
  ## .. code-block:: nim
  ##   preciseDelta(initDuration(seconds = 3633))
  ##   # "1 hour and 33 seconds"
  ##
  ##   preciseDelta(initDuration(days = 400))
  ##   # "1 year, 1 month and 5 days"
  ##
  ## `minimumUnit` controls the smallest unit shown.
  ## `suppress` hides specific units, rolling their value into the next unit.
  ## `format` controls decimal formatting for the smallest displayed unit.
  let totalNs = duration.inNanoseconds
  let totalUs = abs(totalNs) div 1_000
  if totalUs == 0:
    return "0 " & pluralize(0, getUnitPlurals(minimumUnit, locale),
                            locale.pluralRule)
  let units = [
    duYears, duMonths, duWeeks, duDays,
    duHours, duMinutes, duSeconds,
    duMilliseconds, duMicroseconds,
  ]
  var parts: seq[string] = @[]
  var remaining = totalUs
  for i, unit in units:
    # Skip units smaller than minimumUnit (higher ordinal = smaller time unit)
    if ord(unit) > ord(minimumUnit):
      continue
    if unit in suppress:
      continue
    let unitUs = getUnitMicroseconds(unit)
    if unit == minimumUnit:
      # This is the smallest unit — include fractional part
      let value = float64(remaining) / float64(unitUs)
      if value > 0.0:
        # Check if value is a whole number
        let intValue = int(value)
        if abs(value - float64(intValue)) < 0.005:
          parts.add($intValue & " " &
            pluralize(intValue, getUnitPlurals(unit, locale),
                      locale.pluralRule))
        else:
          let formatted = formatValue(value, format)
          parts.add(formatted & " " &
            pluralize(int(value), getUnitPlurals(unit, locale),
                      locale.pluralRule))
      remaining = 0
      break
    else:
      let count = remaining div unitUs
      if count > 0:
        let n = int(count)
        parts.add($n & " " &
          pluralize(n, getUnitPlurals(unit, locale), locale.pluralRule))
        remaining = remaining mod unitUs
  if parts.len == 0:
    return "0 " & pluralize(0, getUnitPlurals(minimumUnit, locale),
                            locale.pluralRule)
  naturalList(parts, locale)

func preciseDelta*(
  seconds: int,
  minimumUnit: DurationUnit = duSeconds,
  suppress: seq[DurationUnit] = default(seq[DurationUnit]),
  format: string = "%.2f",
  locale: Locale = LangEn,
): string =
  ## Convenience overload taking seconds as int.
  preciseDelta(initDuration(seconds = seconds), minimumUnit, suppress,
               format, locale)
