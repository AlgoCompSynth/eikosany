# Reduce a ratio into a specified period (e.g., an octave)

Reduce a ratio into a specified period (e.g., an octave)

## Usage

``` r
period_reduce(x, period)
```

## Arguments

- x:

  A numeric value or vector of ratios

- period:

  The period to wrap the ratio into (default is 2 for an octave). Must
  be greater than 0.

## Value

The reduced ratios, all within the range \[1, period)
