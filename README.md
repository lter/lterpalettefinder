
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="inst/images/lterpalettefinder_hex.png" align = "right" width = "15%" />

# `lterpalettefinder`

<!-- badges: start -->

[![R-CMD-check](https://github.com/lter/lterpalettefinder/workflows/R-CMD-check/badge.svg)](https://github.com/lter/lterpalettefinder/actions)
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

If you are not an R user, you can use [this R Shiny app](https://cosima.nceas.ucsb.edu/lterpalettefinder-shiny/) to explore the core functions of `lterpalettefinder` without needing to "speak" R. The code for the app can be found [here](https://github.com/lter/lterpalettefinder-shiny#readme) if that is of interest!

## Functions

This package currently includes the following functions:

### Use an Existing Palette

-   **`palette_find()`** returns “official” palette(s) that we have
    already created that meet criteria you specify

### Create Your Own Palette

-   **`palette_extract()`** extracts 25 colors’ hexadecimal codes from a
    picture of your choosing (PNG, JPEG, TIFF, and HEIC formats are
    currently supported)

-   **`palette_sort()`** sorts output of `palette_extract()` by hue and
    saturation to approximate how human eyes group colors

-   **`palette_subsample()`** randomly picks a user-specified number of
    hexadecimal codes from a vector of such codes

### Demonstrate a Palette

-   **`palette_demo()`** creates an exploratory **base R** graph from a
    vector of hexadecimal codes (like that returned by either
    `palette_extract()`, `..._sort()`, or `..._subsample()`) and
    provides an option to export that plot if desired

-   **`palette_ggdemo()`** creates an exploratory **`ggplot2`** graph
    from a vector of hexadecimal codes (like that returned by either
    `palette_extract()`, `..._sort()`, or `..._subsample()`)

Note that the vector of hexadecimal codes provided by `palette_find()`
when *only one* official palette meets criteria set by user will also be
accepted by either `palette_demo()` or `...ggdemo()`

## Palette Examples

These palette examples were generated from photos at LTER sites.

#### [Santa Barbara Coastal LTER](https://sbclter.msi.ucsb.edu/)

![Photo credit: SBC
LTER](https://lternet.edu/wp-content/uploads/2022/05/sbc.png)

#### [North Temperate Lakes LTER](https://lter.limnology.wisc.edu/)

![Photo credit: Carl
Bowser](https://lternet.edu/wp-content/uploads/2022/05/ntl.png)

#### [Kellogg Biological Station LTER](https://lter.kbs.msu.edu/)

![Photo credit: G.P. Robertson, Michigan State
University](https://lternet.edu/wp-content/uploads/2022/05/kbs.png)

#### [Jornada Basin LTER](https://lter.jornada.nmsu.edu/)

![Photo credit: Brandon
Bestelmeyer](https://lternet.edu/wp-content/uploads/2022/05/jrn.png)

### [Hubbard Brook LTER](https://hubbardbrook.org/hubbard-brook-long-term-ecological-research-program)

![Photo credit: Lindsey
Rustad](https://lternet.edu/wp-content/uploads/2022/05/hbr.png)
