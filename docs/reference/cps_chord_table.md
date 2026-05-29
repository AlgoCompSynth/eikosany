# Create CPS Chord Table

Creates a chord table for a combination product set scale based on an
*even* number of harmonic factors.

## Usage

``` r
cps_chord_table(scale_table)
```

## Arguments

- scale_table:

  a CPS scale table based on an *even* number of harmonic factors. It
  will abort via

  `stop("number of harmonic factors must be even!")`

  if it receives one with an odd number.

## Value

a data.table with four columns:

- `chord`: the chord expressed as colon-separated harmonics. A
  subharmonic chord is prefixed with a "~".

- `degrees`: the chord expressed as colon-separated scale degrees

- `chord_index`: the row number of the chord in the combination output

- `is_subharm`: zero if it's harmonic, one if it's subharmonic.

The resulting data.table is sorted into harmonic-subharmonic pairs using
`data.table::setkey.`

## Details

The algorithm used only works for a combination product set built from
an *even* number of harmonic factors, so it aborts if it receives one
with an odd number.

In the following, the symbol `n)m` is Erv Wilson's notation for the
number of combinations of `m` items taken `n` at a time. `n_harmonics`
is the number of harmonic factors, the resulting chords will have
`choose <- n_harmonics / 2 + 1` notes. There will be
`choose)n_harmonics` "harmonic" chords and `choose)n_harmonics`
"sub-harmonic" chords.

## Examples

``` r

# compute the tetrads of the 1-3-5-7-9-11 Eikosany
eikosany <- cps_scale_table(root_divisor = 33)
print(eikosany_chords <- cps_chord_table(eikosany))
#> Key: <chord_index, is_subharm>
#>            chord    degrees chord_index is_subharm
#>           <char>     <char>       <int>      <num>
#>  1:      1:3:5:7  3:8:12:18           1          0
#>  2:  /1:/3:/5:/7  2:7:13:17           1          1
#>  3:      1:3:5:9  4:8:11:16           2          0
#>  4:  /1:/3:/5:/9  1:9:14:17           2          1
#>  5:     1:3:5:11  5:8:10:19           3          0
#>  6: /1:/3:/5:/11  0:6:15:17           3          1
#>  7:      1:3:7:9 6:11:15:18           4          0
#>  8:  /1:/3:/7:/9 7:10:14:19           4          1
#>  9:     1:3:7:11   1:5:9:18           5          0
#> 10: /1:/3:/7:/11   0:4:7:16           5          1
#> 11:     1:3:9:11  2:5:11:13           6          0
#> 12: /1:/3:/9:/11  0:3:12:14           6          1
#> 13:      1:5:7:9   0:3:6:16           7          0
#> 14:  /1:/5:/7:/9   2:5:9:19           7          1
#> 15:     1:5:7:11  1:3:10:14           8          0
#> 16: /1:/5:/7:/11  2:4:11:15           8          1
#> 17:     1:5:9:11 7:10:13:16           9          0
#> 18: /1:/5:/9:/11 9:12:15:18           9          1
#> 19:     1:7:9:11  1:6:13:17          10          0
#> 20: /1:/7:/9:/11  4:8:12:19          10          1
#> 21:      3:5:7:9  0:4:12:15          11          0
#> 22:  /3:/5:/7:/9  1:5:10:13          11          1
#> 23:     3:5:7:11 9:12:14:19          12          0
#> 24: /3:/5:/7:/11 6:11:13:16          12          1
#> 25:     3:5:9:11   2:4:7:19          13          0
#> 26: /3:/5:/9:/11   1:3:6:18          13          1
#> 27:     3:7:9:11  2:9:15:17          14          0
#> 28: /3:/7:/9:/11  3:8:10:16          14          1
#> 29:     5:7:9:11  0:7:14:17          15          0
#> 30: /5:/7:/9:/11  5:8:11:18          15          1
#>            chord    degrees chord_index is_subharm
#>           <char>     <char>       <int>      <num>

# compute the pentads of the 1-3-5-7-9-11-13-15 Hebdomekontany
hebdomekontany <- cps_scale_table(
  harmonics = c(1, 3, 5, 7, 9, 11, 13, 15),
  choose = 4,
  root_divisor = 3 * 5 * 7
)
print(hebdomekontany_chords <- cps_chord_table(hebdomekontany))
#> Key: <chord_index, is_subharm>
#>                  chord        degrees chord_index is_subharm
#>                 <char>         <char>       <int>      <num>
#>   1:         1:3:5:7:9 11:24:37:47:65           1          0
#>   2:    /1:/3:/5:/7:/9  0:13:26:42:60           1          1
#>   3:        1:3:5:7:11  5:28:37:45:61           2          0
#>   4:   /1:/3:/5:/7:/11   0:9:32:46:62           2          1
#>   5:        1:3:5:7:13 10:29:37:44:57           3          0
#>  ---                                                        
#> 108: /5:/7:/11:/13:/15  1:11:40:47:55          54          1
#> 109:      5:9:11:13:15   0:9:27:41:60          55          0
#> 110: /5:/9:/11:/13:/15 10:28:37:47:66          55          1
#> 111:      7:9:11:13:15   0:7:26:46:63          56          0
#> 112: /7:/9:/11:/13:/15 11:30:37:44:61          56          1
```
