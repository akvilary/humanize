import std/[unittest, times, strutils]
import humanize/time
import humanize/lang/de

suite "naturalDelta":
  test "zero":
    check naturalDelta(initDuration(seconds = 0)) == "0 seconds"

  test "seconds":
    check naturalDelta(initDuration(seconds = 1)) == "1 second"
    check naturalDelta(initDuration(seconds = 30)) == "30 seconds"
    check naturalDelta(initDuration(seconds = 59)) == "59 seconds"

  test "minutes":
    check naturalDelta(initDuration(seconds = 60)) == "1 minute"
    check naturalDelta(initDuration(seconds = 120)) == "2 minutes"
    check naturalDelta(initDuration(seconds = 3599)) == "59 minutes"

  test "hours":
    check naturalDelta(initDuration(seconds = 3600)) == "1 hour"
    check naturalDelta(initDuration(seconds = 7200)) == "2 hours"
    check naturalDelta(initDuration(hours = 23)) == "23 hours"

  test "days":
    check naturalDelta(initDuration(days = 1)) == "1 day"
    check naturalDelta(initDuration(days = 15)) == "15 days"
    check naturalDelta(initDuration(days = 29)) == "29 days"

  test "months":
    check naturalDelta(initDuration(days = 31)) == "1 month"
    check naturalDelta(initDuration(days = 61)) == "2 months"
    check naturalDelta(initDuration(days = 300)) == "9 months"

  test "years":
    check naturalDelta(initDuration(days = 366)) == "1 year"
    check naturalDelta(initDuration(days = 731)) == "2 years"

  test "years with months":
    let d = naturalDelta(initDuration(days = 400))
    check "1 year" in d

  test "months=false":
    let d = naturalDelta(initDuration(days = 400), months = false)
    check "1 year" in d
    check "day" in d

  test "int overload":
    check naturalDelta(60) == "1 minute"
    check naturalDelta(3600) == "1 hour"

  test "German locale":
    check naturalDelta(initDuration(seconds = 30), locale = LangDe) ==
      "30 Sekunden"

suite "naturalTime":
  let base = dateTime(2025, mJan, 15, 12, 0, 0, 0, utc())

  test "just now":
    check naturalTime(base, base) == "just now"

  test "past":
    let past = base - initDuration(hours = 2)
    check naturalTime(past, base) == "2 hours ago"

  test "future":
    let future = base + initDuration(days = 3)
    check naturalTime(future, base) == "3 days from now"

  test "seconds ago":
    let past = base - initDuration(seconds = 30)
    check naturalTime(past, base) == "30 seconds ago"

  test "German locale":
    let past = base - initDuration(hours = 2)
    check naturalTime(past, base, locale = LangDe) == "vor 2 Stunden"

suite "naturalDay":
  let base = dateTime(2025, mJan, 15, 12, 0, 0, 0, utc())

  test "today":
    check naturalDay(base, base) == "today"

  test "yesterday":
    let yesterday = base - initDuration(days = 1)
    check naturalDay(yesterday, base) == "yesterday"

  test "tomorrow":
    let tomorrow = base + initDuration(days = 1)
    check naturalDay(tomorrow, base) == "tomorrow"

  test "other date":
    let other = dateTime(2025, mMar, 25, 12, 0, 0, 0, utc())
    let result = naturalDay(other, base)
    check "Mar" in result
    check "25" in result

suite "naturalDate":
  let base = dateTime(2025, mJan, 15, 12, 0, 0, 0, utc())

  test "today":
    check naturalDate(base, base) == "today"

  test "same year":
    let other = dateTime(2025, mMar, 25, 12, 0, 0, 0, utc())
    let result = naturalDate(other, base)
    check "Mar" in result
    check "25" in result
    check "2025" notin result

  test "different year":
    let other = dateTime(2024, mMar, 25, 12, 0, 0, 0, utc())
    let result = naturalDate(other, base)
    check "Mar" in result
    check "25" in result
    check "2024" in result
