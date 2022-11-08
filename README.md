
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="inst/images/lterpalettefinder_hex.png" align="right" width="15%"/>

# `lterpalettefinder` - Extract Color Palettes from Photos and Pick Official LTER Palettes

<!-- badges: start -->

[![R-CMD-check](https://github.com/lter/lterpalettefinder/workflows/R-CMD-check/badge.svg)](https://github.com/lter/lterpalettefinder/actions)
![GitHub last
commit](https://img.shields.io/github/last-commit/lter/lterpalettefinder)
![GitHub
issues](https://img.shields.io/github/issues-raw/lter/lterpalettefinder)
![GitHub pull
requests](https://img.shields.io/github/issues-pr/lter/lterpalettefinder)

<!-- badges: end -->

The goal of `lterpalettefinder` is to provide high quality color
palettes derived from photos at LTER sites. This allows users to create
beautiful graphics that have close visual ties to photos from the places
where data were collected. This package also allows users to generate
their own palettes from any photo (PNG, JPEG, TIFF, or HEIC) if the
current palettes in the function do not meet their needs.

## Installation

You can install the development version of `lterpalettefinder` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("lter/lterpalettefinder")
```

## Functions

This package currently includes the following functions:

### Use an Existing Palette

-   **`palette_find`** returns “official” palette(s) that we have
    already created that meet criteria you specify

### Create Your Own Palette

-   **`palette_extract`** extracts 25 colors’ hexadecimal codes from a
    picture of your choosing (PNG, JPEG, TIFF, and HEIC formats are
    currently supported)

-   **`palette_sort`** sorts output of `palette_extract` by hue and
    saturation to approximate how human eyes group colors

-   **`palette_subsample`** randomly picks a user-specified number of
    hexadecimal codes from a vector of such codes

### Demonstrate a Palette

-   **`palette_demo`** creates an exploratory **base R** graph from a
    vector of hexadecimal codes (like that returned by either
    `palette_extract`, `..._sort`, or `..._subsample`) and provides an
    option to export that plot if desired

-   **`palette_ggdemo`** creates an exploratory **`ggplot2`** graph from
    a vector of hexadecimal codes (like that returned by either
    `palette_extract`, `..._sort`, or `..._subsample`)

Note that the vector of hexadecimal codes provided by `palette_find`
when *only one* official palette meets criteria set by user will also be
accepted by either `palette_demo` or `...ggdemo`

## Palette Examples

These palette examples were generated from photos at LTER sites.

#### [Santa Barbara Coastal LTER](https://sbclter.msi.ucsb.edu/) + `palette_demo`

<img src="update-palette-options/official photos/SBC-kelp forest.jpeg" alt="Photo credit: SBC LTER" />

![](man/figures/README-sbc-extract-1.png)<!-- -->

#### [North Temperate Lakes LTER](https://lter.limnology.wisc.edu/) + `palette_ggdemo`

<img src="update-palette-options/official photos/NTL-lakes.jpeg" alt="Photo credit: Carl Bowser" />

![](man/figures/README-ntl-extract-1.png)<!-- -->

#### [Kellogg Biological Station LTER](https://lter.kbs.msu.edu/) + `palette_demo`

<img src="update-palette-options/official photos/KBS-burn.jpeg" alt="Photo credit: G.P. Robertson" />

![](man/figures/README-kbs-extract-1.png)<!-- -->

#### [Arctic LTER](https://arc-lter.ecosystems.mbl.edu/) + `palette_ggdemo`

<img src="update-palette-options/official photos/ARC-sunrise.jpeg" alt="Photo credit: Lindsay VanFossen" />

![](man/figures/README-arc-extract-1.png)<!-- -->
