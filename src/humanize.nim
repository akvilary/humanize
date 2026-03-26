## humanize - Human-readable formatting for Nim.
##
## Import this module to get access to all humanize functions:
## - Number formatting: `ordinal`, `intComma`, `intWord`, `apNumber`
## - File sizes: `naturalSize`, `parseSize`
## - Time: `naturalTime`, `naturalDelta`, `naturalDay`, `naturalDate`
## - Duration: `preciseDelta`
## - Lists: `naturalList`
##
## For locales other than English, import them explicitly:
##
## .. code-block:: nim
##   import humanize/locales/de

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
