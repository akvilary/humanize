## Chinese locale for humanize.

import ../locale

const LocaleZh* = Locale(
  name: "zh",
  pluralRule: prInvariant,
  ordinalRule: orChinese,
  timeUnits: TimeUnits(
    years: Plurals(one: "\xE5\xB9\xB4", few: "\xE5\xB9\xB4", many: "\xE5\xB9\xB4"),        # 年
    months: Plurals(one: "\xE4\xB8\xAA\xE6\x9C\x88", few: "\xE4\xB8\xAA\xE6\x9C\x88", many: "\xE4\xB8\xAA\xE6\x9C\x88"),  # 个月
    weeks: Plurals(one: "\xE5\x91\xA8", few: "\xE5\x91\xA8", many: "\xE5\x91\xA8"),          # 周
    days: Plurals(one: "\xE5\xA4\xA9", few: "\xE5\xA4\xA9", many: "\xE5\xA4\xA9"),           # 天
    hours: Plurals(
      one: "\xE5\xB0\x8F\xE6\x97\xB6", few: "\xE5\xB0\x8F\xE6\x97\xB6", many: "\xE5\xB0\x8F\xE6\x97\xB6",   # 小时
    ),
    minutes: Plurals(
      one: "\xE5\x88\x86\xE9\x92\x9F", few: "\xE5\x88\x86\xE9\x92\x9F", many: "\xE5\x88\x86\xE9\x92\x9F",   # 分钟
    ),
    seconds: Plurals(one: "\xE7\xA7\x92", few: "\xE7\xA7\x92", many: "\xE7\xA7\x92"),        # 秒
    milliseconds: Plurals(
      one: "\xE6\xAF\xAB\xE7\xA7\x92", few: "\xE6\xAF\xAB\xE7\xA7\x92", many: "\xE6\xAF\xAB\xE7\xA7\x92",   # 毫秒
    ),
    microseconds: Plurals(
      one: "\xE5\xBE\xAE\xE7\xA7\x92", few: "\xE5\xBE\xAE\xE7\xA7\x92", many: "\xE5\xBE\xAE\xE7\xA7\x92",   # 微秒
    ),
  ),
  agoFmt: "$1\xE5\x89\x8D",          # 前
  fromNowFmt: "$1\xE5\x90\x8E",      # 后
  justNow: "\xE5\x88\x9A\xE5\x88\x9A",  # 刚刚
  thousandsSep: ",",
  decimalSep: ".",
  numberWords: @[
    NumberWord(
      value: 1e4,
      name: Plurals(one: "\xE4\xB8\x87", few: "\xE4\xB8\x87", many: "\xE4\xB8\x87"),  # 万
    ),
    NumberWord(
      value: 1e8,
      name: Plurals(one: "\xE4\xBA\xBF", few: "\xE4\xBA\xBF", many: "\xE4\xBA\xBF"),  # 亿
    ),
    NumberWord(
      value: 1e12,
      name: Plurals(
        one: "\xE4\xB8\x87\xE4\xBA\xBF",  # 万亿
        few: "\xE4\xB8\x87\xE4\xBA\xBF",
        many: "\xE4\xB8\x87\xE4\xBA\xBF",
      ),
    ),
  ],
  apWords: @[
    "\xE4\xB8\x80",   # 一
    "\xE4\xBA\x8C",   # 二
    "\xE4\xB8\x89",   # 三
    "\xE5\x9B\x9B",   # 四
    "\xE4\xBA\x94",   # 五
    "\xE5\x85\xAD",   # 六
    "\xE4\xB8\x83",   # 七
    "\xE5\x85\xAB",   # 八
    "\xE4\xB9\x9D",   # 九
  ],
  conjunction: "\xE5\x92\x8C",  # 和
  serialComma: false,
  today: "\xE4\xBB\x8A\xE5\xA4\xA9",     # 今天
  tomorrow: "\xE6\x98\x8E\xE5\xA4\xA9",   # 明天
  yesterday: "\xE6\x98\xA8\xE5\xA4\xA9",  # 昨天
)
