# lterpalettefinder Version 1.0.0.9000

Development version of `lterpalettefinder` following version 1.0.0. Changes to the package will be listed here as they are created.

- Fixed issue where `palette_extract` failed for images with fewer than 25 colors
- Tweaked `palette_extract` handling of exclusion of very dark colors to avoid accidental removal of colors with very low values in two RGB bands but high value in the third
- LTER acronym (Long Term Ecological Research) defined in README and `palette_find` function documentation

# lterpalettefinder Version 1.0.0

This is the first fully-functioning version of the package. It currently has no ERRORS, WARNINGS, or NOTES from `devtools::check()`
