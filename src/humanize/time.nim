## Time formatting for humanize.
##
## Provides `naturalDelta`, `naturalTime`, `naturalDay`, and `naturalDate`
## for human-readable time and date formatting.

import std/[times, strutils, math]
import ./locale

const
  secondsPerMinute = 60
  secondsPerHour = 3600
  secondsPerDay = 86400
  daysPerMonth = 30.5
  daysPerYear = 365.25
  secondsPerMonth = int(daysPerMonth * float(secondsPerDay))
  secondsPerYear = int(daysPerYear * float(secondsPerDay))

func naturalDelta*(
  duration: Duration,
  months: bool = true,
  locale: Locale = DefaultLocale,
): string =
  ## Express a Duration as a human-readable delta (unsigned).
  ##
  ## .. code-block:: nim
  ##   naturalDelta(initDuration(seconds = 45))  # "45 seconds"
  ##   naturalDelta(initDuration(seconds = 120)) # "2 minutes"
  ##   naturalDelta(initDuration(days = 400))    # "1 year, 1 month"
  let totalSeconds = abs(duration.inSeconds).int
  if totalSeconds == 0:
    return "0 " & pluralize(0, locale.timeUnits.seconds, locale.pluralRule)
  if totalSeconds < secondsPerMinute:
    let n = totalSeconds
    return $n & " " & pluralize(n, locale.timeUnits.seconds, locale.pluralRule)
  if totalSeconds < secondsPerHour:
    let n = totalSeconds div secondsPerMinute
    return $n & " " & pluralize(n, locale.timeUnits.minutes, locale.pluralRule)
  if totalSeconds < secondsPerDay:
    let n = totalSeconds div secondsPerHour
    return $n & " " & pluralize(n, locale.timeUnits.hours, locale.pluralRule)
  if not months:
    if totalSeconds < secondsPerYear:
      let n = totalSeconds div secondsPerDay
      return $n & " " & pluralize(n, locale.timeUnits.days, locale.pluralRule)
    else:
      let years = totalSeconds div secondsPerYear
      let remainDays = (totalSeconds mod secondsPerYear) div secondsPerDay
      var s = $years & " " &
        pluralize(years, locale.timeUnits.years, locale.pluralRule)
      if remainDays > 0:
        s.add(", " & $remainDays & " " &
          pluralize(remainDays, locale.timeUnits.days, locale.pluralRule))
      return s
  # months=true
  if totalSeconds < secondsPerMonth:
    let n = totalSeconds div secondsPerDay
    return $n & " " & pluralize(n, locale.timeUnits.days, locale.pluralRule)
  if totalSeconds < secondsPerYear:
    let n = int(float(totalSeconds) / float(secondsPerMonth))
    return $n & " " & pluralize(n, locale.timeUnits.months, locale.pluralRule)
  let years = int(float(totalSeconds) / float(secondsPerYear))
  let remainSeconds = totalSeconds - int(float(years) * float(secondsPerYear))
  let remainMonths = int(float(remainSeconds) / float(secondsPerMonth))
  var s = $years & " " &
    pluralize(years, locale.timeUnits.years, locale.pluralRule)
  if remainMonths > 0:
    s.add(", " & $remainMonths & " " &
      pluralize(remainMonths, locale.timeUnits.months, locale.pluralRule))
  s

func naturalDelta*(
  seconds: int,
  months: bool = true,
  locale: Locale = DefaultLocale,
): string =
  ## Convenience overload taking seconds as int.
  naturalDelta(initDuration(seconds = seconds), months, locale)

proc naturalTime*(
  dt: DateTime,
  now: DateTime = now(),
  months: bool = true,
  locale: Locale = DefaultLocale,
): string =
  ## Express a DateTime relative to `now` as human-readable text.
  ##
  ## .. code-block:: nim
  ##   naturalTime(pastDt)   # "2 hours ago"
  ##   naturalTime(futureDt) # "3 days from now"
  let totalSeconds = abs((dt - now).inSeconds).int
  if totalSeconds < 2:
    return locale.justNow
  let delta = naturalDelta(
    initDuration(seconds = totalSeconds), months, locale,
  )
  if dt < now:
    locale.agoFmt % [delta]
  else:
    locale.fromNowFmt % [delta]

proc naturalTime*(
  t: Time,
  now: Time = getTime(),
  months: bool = true,
  locale: Locale = DefaultLocale,
): string =
  ## Time overload of `naturalTime`.
  naturalTime(t.local, now.local, months, locale)

proc naturalDay*(
  dt: DateTime,
  now: DateTime = now(),
  locale: Locale = DefaultLocale,
): string =
  ## Return "today", "tomorrow", "yesterday", or a formatted date string.
  ##
  ## .. code-block:: nim
  ##   naturalDay(today)     # "today"
  ##   naturalDay(yesterday) # "yesterday"
  let dtDay = dt.monthday
  let dtMonth = dt.month
  let dtYear = dt.year
  let nowDay = now.monthday
  let nowMonth = now.month
  let nowYear = now.year
  let daysDiff = int((
    dateTime(dtYear, dtMonth, MonthdayRange(dtDay), 0, 0, 0, 0, utc()) -
    dateTime(nowYear, nowMonth, MonthdayRange(nowDay), 0, 0, 0, 0, utc())
  ).inDays)
  if daysDiff == 0:
    locale.today
  elif daysDiff == -1:
    locale.yesterday
  elif daysDiff == 1:
    locale.tomorrow
  else:
    dt.format("MMM dd")

proc naturalDate*(
  dt: DateTime,
  now: DateTime = now(),
  locale: Locale = DefaultLocale,
): string =
  ## Like `naturalDay` but includes the year for dates not in the current year.
  ##
  ## .. code-block:: nim
  ##   naturalDate(sameYearDt) # "Mar 25"
  ##   naturalDate(diffYearDt) # "Mar 25, 2024"
  let dtDay = dt.monthday
  let dtMonth = dt.month
  let dtYear = dt.year
  let nowDay = now.monthday
  let nowMonth = now.month
  let nowYear = now.year
  let daysDiff = int((
    dateTime(dtYear, dtMonth, MonthdayRange(dtDay), 0, 0, 0, 0, utc()) -
    dateTime(nowYear, nowMonth, MonthdayRange(nowDay), 0, 0, 0, 0, utc())
  ).inDays)
  if daysDiff == 0:
    return locale.today
  elif daysDiff == -1:
    return locale.yesterday
  elif daysDiff == 1:
    return locale.tomorrow
  if dt.year != now.year:
    dt.format("MMM dd, yyyy")
  else:
    dt.format("MMM dd")
