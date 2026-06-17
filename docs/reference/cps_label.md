# Generate labels for a combination product set (CPS)

Generate labels for a combination product set (CPS)

## Usage

``` r
cps_label(harmonics = c(1, 3, 5, 7, 9, 11), choose = 3)
```

## Arguments

- harmonics:

  A vector of harmonic factors to use - defaults to the first six odd
  numbers

- choose:

  The number of harmonics to choose for each combination - defaults to 3

## Value

A character vector of harmonically-labeled notes (e.g., "1x3x5")
