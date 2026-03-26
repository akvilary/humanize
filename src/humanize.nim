## humanize - Human-readable formatting for Nim.
##
## Import this module to get access to all humanize functions:
## - Number formatting: `ordinal`, `numComma`, `numWord`, `apNumber`
## - File sizes: `naturalSize`, `parseSize`
## - Time: `naturalTime`, `naturalDelta`, `naturalDay`, `naturalDate`
## - Duration: `preciseDelta`
## - Lists: `naturalList`
##
## Use the `Lang` enum for locale selection:
##
## .. code-block:: nim
##   import humanize
##   echo numComma(1000, lDe)  # "1.000"

import humanize/locale
import humanize/filesize
import humanize/time
import humanize/duration
import humanize/number
import humanize/list

export locale
export filesize
export time
export duration
export number
export list
