import std/unittest
import humanize/locale
import humanize/locales/de
import humanize/locales/es
import humanize/locales/fr
import humanize/locales/it
import humanize/locales/ru
import humanize/locales/zh

suite "pluralize":
  let forms = Plurals(one: "cat", few: "cats", many: "cats")

  test "prGermanic: 1 -> one":
    check pluralize(1, forms, prGermanic) == "cat"

  test "prGermanic: 0 -> many":
    check pluralize(0, forms, prGermanic) == "cats"

  test "prGermanic: 5 -> many":
    check pluralize(5, forms, prGermanic) == "cats"

  test "prFrench: 0 -> one":
    check pluralize(0, forms, prFrench) == "cat"

  test "prFrench: 1 -> one":
    check pluralize(1, forms, prFrench) == "cat"

  test "prFrench: 2 -> many":
    check pluralize(2, forms, prFrench) == "cats"

  test "prInvariant: always many":
    check pluralize(0, forms, prInvariant) == "cats"
    check pluralize(1, forms, prInvariant) == "cats"
    check pluralize(5, forms, prInvariant) == "cats"

suite "pluralize - Slavic rule":
  let forms = Plurals(one: "год", few: "года", many: "лет")

  test "1 -> one":
    check pluralize(1, forms, prSlavic) == "год"

  test "2 -> few":
    check pluralize(2, forms, prSlavic) == "года"

  test "3 -> few":
    check pluralize(3, forms, prSlavic) == "года"

  test "4 -> few":
    check pluralize(4, forms, prSlavic) == "года"

  test "5 -> many":
    check pluralize(5, forms, prSlavic) == "лет"

  test "11 -> many (exception)":
    check pluralize(11, forms, prSlavic) == "лет"

  test "12 -> many (exception)":
    check pluralize(12, forms, prSlavic) == "лет"

  test "13 -> many (exception)":
    check pluralize(13, forms, prSlavic) == "лет"

  test "14 -> many (exception)":
    check pluralize(14, forms, prSlavic) == "лет"

  test "21 -> one":
    check pluralize(21, forms, prSlavic) == "год"

  test "22 -> few":
    check pluralize(22, forms, prSlavic) == "года"

  test "25 -> many":
    check pluralize(25, forms, prSlavic) == "лет"

  test "111 -> many":
    check pluralize(111, forms, prSlavic) == "лет"

  test "negative -1 -> one":
    check pluralize(-1, forms, prSlavic) == "год"

  test "negative -21 -> one":
    check pluralize(-21, forms, prSlavic) == "год"

suite "DefaultLocale":
  test "name is en":
    check DefaultLocale.name == "en"

  test "pluralRule is Germanic":
    check DefaultLocale.pluralRule == prGermanic

  test "ordinalRule is English":
    check DefaultLocale.ordinalRule == orEnglish

  test "has number words":
    check DefaultLocale.numberWords.len >= 10

  test "has AP words":
    check DefaultLocale.apWords.len == 9

suite "locale definitions":
  test "German locale":
    check LocaleDe.name == "de"
    check LocaleDe.pluralRule == prGermanic
    check LocaleDe.ordinalRule == orGerman

  test "Spanish locale":
    check LocaleEs.name == "es"
    check LocaleEs.pluralRule == prGermanic
    check LocaleEs.ordinalRule == orSpanish

  test "French locale":
    check LocaleFr.name == "fr"
    check LocaleFr.pluralRule == prFrench
    check LocaleFr.ordinalRule == orFrench

  test "Italian locale":
    check LocaleIt.name == "it"
    check LocaleIt.pluralRule == prGermanic
    check LocaleIt.ordinalRule == orItalian

  test "Russian locale":
    check LocaleRu.name == "ru"
    check LocaleRu.pluralRule == prSlavic
    check LocaleRu.ordinalRule == orRussian

  test "Chinese locale":
    check LocaleZh.name == "zh"
    check LocaleZh.pluralRule == prInvariant
    check LocaleZh.ordinalRule == orChinese
