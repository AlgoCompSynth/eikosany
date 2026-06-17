# Create a basic ratio table from labels

Create a basic ratio table from labels

## Usage

``` r
ratio_table(label, period = 2, root_divisor)
```

## Arguments

- label:

  A character vector of product labels (e.g., "1x3x5")

- period:

  The period to wrap ratios into (default is 2 for an octave)

- root_divisor:

  The divisor used to scale the smallest product to 1/1

## Value

A `data.table` containing ratio, fractional representation and cents
