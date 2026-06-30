# Create Combination Product Set Scale Table

Creates a scale table from a combination product set definition

## Usage

``` r
cps_scale_table(harmonics = c(1, 3, 5, 7, 9, 11), choose = 3, root_divisor)
```

## Arguments

- harmonics:

  a vector of the harmonics to use - defaults to the first six odd
  numbers, the harmonics that define the 1-3-5-7-9-11 Eikosany.

- choose:

  the number of harmonics to choose for each combination - defaults to
  3, the number of harmonics for each combination in the Eikosany.

- root_divisor:

  a divisor that scales one of the products to 1/1. Most published CPS
  scales just use the smallest of the products for this, but Erv Wilson
  used 1x3x11 for the Eikosany, because that maps 1x5x11 to concert
  pitches for A: 55, 110, 220, 440 etc. There is no default value.

## Value

a `data.table` with six columns:

- `note_name`: the product of harmonics that defines the note
  (character)

- `ratio`: the ratio that defines the note, as a number \>= 1 and \< 2

- `ratio_frac`: the ratio as a vulgar fraction (character)

- `ratio_cents`: the ratio in cents (hundredths of a semitone)

- `interval_cents`: interval between this note and the previous note

- `degree`: scale degree from zero to (number of notes) - 1

## Examples

``` r

# the defaults yield the 1-3-5-7-9-11 Eikosany.

# Erv Wilson's design
print(eikosany <- cps_scale_table(root_divisor = 33))
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
#>  1:    1x3x11 1.000000          1     0.00000             NA      0
#>  2:     3x5x9 1.022727      45/44    38.90577       38.90577      1
#>  3:     1x5x7 1.060606      35/33   101.86668       62.96090      2
#>  4:    3x9x11 1.125000        9/8   203.91000      102.04332      3
#>  5:    1x7x11 1.166667        7/6   266.87091       62.96090      4
#>  6:     5x7x9 1.193182     105/88   305.77668       38.90577      5
#>  7:    3x5x11 1.250000        5/4   386.31371       80.53704      6
#>  8:     1x3x7 1.272727      14/11   417.50796       31.19425      7
#>  9:    7x9x11 1.312500      21/16   470.78091       53.27294      8
#> 10:     1x5x9 1.363636      15/11   536.95077       66.16987      9
#> 11:     3x7x9 1.431818      63/44   621.41797       84.46719     10
#> 12:    5x7x11 1.458333      35/24   653.18462       31.76665     11
#> 13:    1x9x11 1.500000        3/2   701.95500       48.77038     12
#> 14:     3x5x7 1.590909      35/22   803.82168      101.86668     13
#> 15:     1x3x9 1.636364      18/11   852.59206       48.77038     14
#> 16:    1x5x11 1.666667        5/3   884.35871       31.76665     15
#> 17:    3x7x11 1.750000        7/4   968.82591       84.46719     16
#> 18:     1x3x5 1.818182      20/11  1034.99577       66.16987     17
#> 19:    5x9x11 1.875000       15/8  1088.26871       53.27294     18
#> 20:     1x7x9 1.909091      21/11  1119.46296       31.19425     19
#> 21:   1x3x11' 2.000000          2  1200.00000       80.53704     20
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>

# The usual public Eikosany
print(eikosany <- cps_scale_table(root_divisor = 15))
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
#>  1:     1x3x5 1.000000          1     0.00000             NA      0
#>  2:    5x9x11 1.031250      33/32    53.27294       53.27294      1
#>  3:     1x7x9 1.050000      21/20    84.46719       31.19425      2
#>  4:    1x3x11 1.100000      11/10   165.00423       80.53704      3
#>  5:     3x5x9 1.125000        9/8   203.91000       38.90577      4
#>  6:     1x5x7 1.166667        7/6   266.87091       62.96090      5
#>  7:    3x9x11 1.237500      99/80   368.91423      102.04332      6
#>  8:    1x7x11 1.283333      77/60   431.87513       62.96090      7
#>  9:     5x7x9 1.312500      21/16   470.78091       38.90577      8
#> 10:    3x5x11 1.375000       11/8   551.31794       80.53704      9
#> 11:     1x3x7 1.400000        7/5   582.51219       31.19425     10
#> 12:    7x9x11 1.443750    231/160   635.78514       53.27294     11
#> 13:     1x5x9 1.500000        3/2   701.95500       66.16987     12
#> 14:     3x7x9 1.575000      63/40   786.42219       84.46719     13
#> 15:    5x7x11 1.604167      77/48   818.18885       31.76665     14
#> 16:    1x9x11 1.650000      33/20   866.95923       48.77038     15
#> 17:     3x5x7 1.750000        7/4   968.82591      101.86668     16
#> 18:     1x3x9 1.800000        9/5  1017.59629       48.77038     17
#> 19:    1x5x11 1.833333       11/6  1049.36294       31.76665     18
#> 20:    3x7x11 1.925000      77/40  1133.83013       84.46719     19
#> 21:    1x3x5' 2.000000          2  1200.00000       66.16987     20
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>

# the 1-3-5-7 Hexany
hexany_harmonics <- c(1, 3, 5, 7)
hexany_choose <- 2
print(hexany <-
  cps_scale_table(hexany_harmonics, hexany_choose, 3)
)
#>    note_name    ratio ratio_frac ratio_cents interval_cents degree
#>       <char>    <num> <charFrac>       <num>          <num>  <num>
#> 1:       1x3 1.000000          1      0.0000             NA      0
#> 2:       1x7 1.166667        7/6    266.8709      266.87091      1
#> 3:       3x5 1.250000        5/4    386.3137      119.44281      2
#> 4:       5x7 1.458333      35/24    653.1846      266.87091      3
#> 5:       1x5 1.666667        5/3    884.3587      231.17409      4
#> 6:       3x7 1.750000        7/4    968.8259       84.46719      5
#> 7:      1x3' 2.000000          2   1200.0000      231.17409      6

# the 1-7-9-11-13 2)5 Dekany

dekany_harmonics <- c(1, 7, 9, 11, 13)
dekany_choose <- 2
print(dekany <-
  cps_scale_table(dekany_harmonics, dekany_choose, 7)
)
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
#>  1:       1x7 1.000000          1     0.00000             NA      0
#>  2:      9x13 1.044643    117/112    75.61176       75.61176      1
#>  3:       7x9 1.125000        9/8   203.91000      128.29824      2
#>  4:     11x13 1.276786    143/112   423.01970      219.10970      3
#>  5:       1x9 1.285714        9/7   435.08410       12.06440      4
#>  6:      7x11 1.375000       11/8   551.31794      116.23385      5
#>  7:      1x11 1.571429       11/7   782.49204      231.17409      6
#>  8:      7x13 1.625000       13/8   840.52766       58.03563      7
#>  9:      9x11 1.767857      99/56   986.40204      145.87438      8
#> 10:      1x13 1.857143       13/7  1071.70176       85.29972      9
#> 11:      1x7' 2.000000          2  1200.00000      128.29824     10

# We might want to print out sheet music for a conventional keyboard
# player, since the synthesizer is mapping MIDI note numbers to pitches.
# We assume at least a 37-key synthesizer with middle C on the left,
# so the largest CPS scale we can play is a 35-note "35-any", made from
# seven harmonics taken three at a time.
harmonics_35 <- c(1, 3, 5, 7, 9, 11, 13)
choose_35 <- 3
print(any_35 <-
  cps_scale_table(harmonics_35, choose_35, root_divisor = 15)
)
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
#>  1:     1x3x5 1.000000          1     0.00000             NA      0
#>  2:    5x9x11 1.031250      33/32    53.27294       53.27294      1
#>  3:   7x11x13 1.042708   1001/960    72.40280       19.12985      2
#>  4:     1x7x9 1.050000      21/20    84.46719       12.06440      3
#>  5:    1x5x13 1.083333      13/12   138.57266       54.10547      4
#>  6:    1x3x11 1.100000      11/10   165.00423       26.43157      5
#>  7:     3x5x9 1.125000        9/8   203.91000       38.90577      6
#>  8:    3x7x13 1.137500      91/80   223.03985       19.12985      7
#>  9:     1x5x7 1.166667        7/6   266.87091       43.83105      8
#> 10:   1x11x13 1.191667    143/120   303.57689       36.70598      9
#> 11:    5x9x13 1.218750      39/32   342.48266       38.90577     10
#> 12:    3x9x11 1.237500      99/80   368.91423       26.43157     11
#> 13:    1x7x11 1.283333      77/60   431.87513       62.96090     12
#> 14:    1x3x13 1.300000      13/10   454.21395       22.33881     13
#> 15:     5x7x9 1.312500      21/16   470.78091       16.56696     14
#> 16:   9x11x13 1.340625    429/320   507.48689       36.70598     15
#> 17:    3x5x11 1.375000       11/8   551.31794       43.83105     16
#> 18:     1x3x7 1.400000        7/5   582.51219       31.19425     17
#> 19:    7x9x11 1.443750    231/160   635.78514       53.27294     18
#> 20:    3x9x13 1.462500     117/80   658.12395       22.33881     19
#> 21:   5x11x13 1.489583     143/96   689.89060       31.76665     20
#> 22:     1x5x9 1.500000        3/2   701.95500       12.06440     21
#> 23:    1x7x13 1.516667      91/60   721.08485       19.12985     22
#> 24:     3x7x9 1.575000      63/40   786.42219       65.33734     23
#> 25:    5x7x11 1.604167      77/48   818.18885       31.76665     24
#> 26:    3x5x13 1.625000       13/8   840.52766       22.33881     25
#> 27:    1x9x11 1.650000      33/20   866.95923       26.43157     26
#> 28:    7x9x13 1.706250    273/160   924.99486       58.03563     27
#> 29:     3x5x7 1.750000        7/4   968.82591       43.83105     28
#> 30:   3x11x13 1.787500     143/80  1005.53189       36.70598     29
#> 31:     1x3x9 1.800000        9/5  1017.59629       12.06440     30
#> 32:    1x5x11 1.833333       11/6  1049.36294       31.76665     31
#> 33:    5x7x13 1.895833      91/48  1107.39857       58.03563     32
#> 34:    3x7x11 1.925000      77/40  1133.83013       26.43157     33
#> 35:    1x9x13 1.950000      39/20  1156.16895       22.33881     34
#> 36:    1x3x5' 2.000000          2  1200.00000       43.83105     35
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
```
