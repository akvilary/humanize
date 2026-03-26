# humanize

Nim library for human-readable formatting of numbers, file sizes, times,
durations, and lists. Inspired by Python humanize and Go go-humanize.

## Project info

- Language: Nim >= 2.0.0
- License: MIT
- Author: akvilary
- Status: initial development (v0.1.0)
- Dependencies: only Nim stdlib (times, strutils, math)

## Architecture

```
src/
  humanize.nim              # Facade: import + export all public modules
  humanize/
    locale.nim              # Locale type, Plurals, pluralize, defaultLocale (en)
    filesize.nim            # naturalSize, parseSize, byte constants
    time.nim                # naturalTime, naturalDelta, naturalDay, naturalDate
    duration.nim            # preciseDelta
    number.nim              # ordinal, intComma, intWord, apNumber
    list.nim                # naturalList
    locales/
      de.nim, es.nim, fr.nim, it.nim, ru.nim, zh.nim

tests/
  test_locale.nim, test_filesize.nim, test_time.nim,
  test_duration.nim, test_number.nim, test_list.nim
```

## Build & test

```bash
nimble test
```

## API design

- All functions take an explicit `locale` parameter (default: English)
- No global state, no thread-local activation
- Locales are imported explicitly: `import humanize/locales/ru`
- Locale is always the last parameter (for convenient defaulting)
- `PluralRule` and `OrdinalRule` are enums, not procs — Locale can be `const`
- File sizes always use "." decimal separator (international units)

## Core types

```nim
PluralRule = enum
  prGermanic    # en, de, it, es: 1->one, else->many
  prFrench      # fr: 0-1->one, else->many
  prSlavic      # ru: 1->one, 2-4->few, else->many (11-14 exceptions)
  prInvariant   # zh: always->many

OrdinalRule = enum
  orEnglish, orFrench, orGerman, orSpanish, orItalian, orRussian, orChinese

Plurals = object
  one, few, many: string  # 3 forms for all languages

Locale = object  # all enums, no procs — can be const
  name, pluralRule, ordinalRule, timeUnits, agoFmt, fromNowFmt, justNow,
  thousandsSep, decimalSep, numberWords, intWordLabels,
  conjunction, serialComma, today, tomorrow, yesterday
```

## Code style

- Idiomatic Nim: camelCase procs, PascalCase types
- Doc-comments (##) on every exported symbol
- No external dependencies
- 2-space indentation
- Line length: soft limit 100 characters
- Multi-line proc signatures: each parameter on its own line, 2-space indent
- Never use empty collection literals as default parameter values — use default(T)
- Prefer `openArray[T]` for function params, `seq[T]` for stored types
- Use `{.noSideEffect.}` on pure functions where appropriate

## Design decisions log

1. **Plurals**: Simple 3 forms (one, few, many) for all languages. No variant objects.
2. **Locale parameter**: Explicit on every function, not global state.
3. **Filesize**: No locale param — decimal sep always ".", units are international.
4. **Hybrid localization**: Default `en` in locale.nim, others via `import humanize/locales/xx`.
5. **Enums over procs**: PluralRule and OrdinalRule are enums so Locale can be `const`.
6. **Best practices from Python humanize**: flat API, graceful degradation, format strings, suppress param in preciseDelta, rounding promotion in intWord, gendered ordinals.
7. **Best practices from Go go-humanize**: byte constants, parseSize, three size systems (binary/SI/GNU), magnitude thresholds for time.

## Locales to ship

en (built-in default), de, es, fr, it, ru, zh
