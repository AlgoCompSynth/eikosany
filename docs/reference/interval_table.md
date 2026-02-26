# Create Interval Table

Creates an interval table from a scale table

## Usage

``` r
interval_table(scale_table)
```

## Arguments

- scale_table:

  a scale table from `ps_scale_table`, `cps_scale_table`, or
  `et_scale_table`

## Value

an interval table. This is a data.table with seven columns

- `from` name of "from" note

- `from_degree` scale degree of "from" note

- `to` name of "to" note

- `to_degree` scale degree of "to" note

- `ratio` interval as a number

- `ratio_frac` interval as a vulgar fraction (character)

- `ratio_cents` interval in cents

## Examples

``` r
# default is the 1-3-5-7-9-11 Eikosany
eikosany <- cps_scale_table(root_divisor = 33)
print(eikosany_interval_table <-interval_table(eikosany))
#> Key: <ratio>
#>      from_name from_degree to_name to_degree    ratio ratio_frac ratio_cents
#>         <char>       <num>  <char>     <num>    <num> <charFrac>       <num>
#>   1:    3x5x11           6   1x3x7         7 1.018182      56/55    31.19425
#>   2:    5x9x11          18   1x7x9        19 1.018182      56/55    31.19425
#>   3:     3x7x9          10  5x7x11        11 1.018519      55/54    31.76665
#>   4:     1x3x9          14  1x5x11        15 1.018519      55/54    31.76665
#>   5:    1x3x11           0   3x5x9         1 1.022727      45/44    38.90577
#>  ---                                                                        
#> 206:    1x3x11           0  5x9x11        18 1.875000       15/8  1088.26871
#> 207:     1x5x7           2 1x3x11'        20 1.885714      66/35  1098.13332
#> 208:    1x3x11           0   1x7x9        19 1.909091      21/11  1119.46296
#> 209:     3x5x9           1 1x3x11'        20 1.955556      88/45  1161.09423
#> 210:    1x3x11           0 1x3x11'        20 2.000000          2  1200.00000
```
