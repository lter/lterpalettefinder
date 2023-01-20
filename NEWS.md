# lterpalettefinder Version 1.1.0

Changes to `lterpalettefinder` from version 1.0.0 (the preceding version)

- Fixed issue where `palette_extract` failed for images with fewer than 25 colors
- Tweaked `palette_extract` handling of exclusion of very dark colors to avoid accidental removal of colors with very low values in two RGB bands but high value in the third
- Fixed problem where `base::as.character` drops leading 0 of two-digit hexadecimals (`hexmode` objects) for both `palette_extract` and `palette_sort`
- LTER acronym (Long Term Ecological Research) defined in README and `palette_find` function documentation
- This version currently has no ERRORS, WARNINGS, or NOTES from `devtools::check()`

# lterpalettefinder Version 1.0.0

This is the first fully-functioning version of the package. It currently has no ERRORS, WARNINGS, or NOTES from `devtools::check()`
