import std/[unittest, times, strutils]
import humanize/duration
import humanize/locales/de

suite "preciseDelta":
  test "zero":
    check preciseDelta(initDuration(seconds = 0)) == "0 seconds"

  test "seconds":
    check preciseDelta(initDuration(seconds = 1)) == "1 second"
    check preciseDelta(initDuration(seconds = 30)) == "30 seconds"

  test "minutes and seconds":
    check preciseDelta(initDuration(seconds = 90)) == "1 minute and 30 seconds"

  test "hours and seconds":
    let result = preciseDelta(initDuration(seconds = 3633))
    check "1 hour" in result
    check "33 second" in result

  test "days":
    let result = preciseDelta(initDuration(days = 1, seconds = 30))
    check "1 day" in result
    check "30 second" in result

  test "years and months":
    let result = preciseDelta(initDuration(days = 400))
    check "1 year" in result

  test "int overload":
    check preciseDelta(90) == "1 minute and 30 seconds"

  test "minimumUnit minutes":
    let result = preciseDelta(
      initDuration(seconds = 3633),
      minimumUnit = duMinutes,
    )
    check "1 hour" in result
    check "minute" in result
    check "second" notin result

  test "suppress weeks":
    let result = preciseDelta(
      initDuration(days = 10),
      suppress = @[duWeeks],
    )
    check "week" notin result
    check "10 days" in result

  test "German locale":
    let result = preciseDelta(
      initDuration(seconds = 90),
      locale = LocaleDe,
    )
    check "Minute" in result
    check "Sekunden" in result
