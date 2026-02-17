# Create Product Set Scale Table

Creates a scale table from a product set definition

## Usage

``` r
ps_scale_table(
  ps_def = c("1x3x5", "5x9x11", "1x7x9", "1x3x11", "3x5x9", "1x5x7", "3x9x11", "1x7x11",
    "5x7x9", "3x5x11", "1x3x7", "7x9x11", "1x5x9", "3x7x9", "5x7x11", "1x9x11", "3x5x7",
    "1x3x9", "1x5x11", "3x7x11"),
  root_divisor
)
```

## Arguments

- ps_def:

  the product set scale definition. This is a character vector of
  products. Each product is a set of any number of integers separated by
  a lower-case "x". For example, the `ps_def` of the 1-3-5-7 Hexany is

  `c("1x3", "1x5", "1x7", "3x5", "3x7", "5x7")`

  The default is the `ps_def` for the 1-3-5-7-9-11 Eikosany.

- root_divisor:

  a divisor that scales one of the products to 1/1. Most published CPS
  scales just use the smallest of the products for this, but Erv Wilson
  used 1x3x11 for the Eikosany, because that maps 1x5x11 to concert
  pitches for A: 55, 110, 220, 440 etc. There is no default value.

## Value

a `data.table` with six columns:

- `note_name`: the given product set definition, re-ordered by the
  degrees of the resulting scale (character)

- `ratio`: the ratio that defines the note, as a number between 1 and 2

- `ratio_frac`: the ratio as a vulgar fraction (character)

- `ratio_cents`: the ratio in cents (hundredths of a semitone)

- `interval_cents`: interval between this note and the previous note

- `degree`: scale degree from zero to (number of notes) - 1

## See also

[`offset_matrix()`](offset_matrix.md)

## Examples

``` r

# the default yields the 1-3-5-7-9-11 Eikosany
print(eikosany <- ps_scale_table(root_divisor = 33))
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

# Kraig Grady's Eikosany as two complementary extended Dekanies
# See _Microtonality and the Tuning Systems of Erv Wilson_, pages 127 - 131
# for the process used to create these scales
print(grady_a <- ps_scale_table(c(
  "1x3x11",
  "1x9",
  "3x9x11",
  "1x7x11",
  "1x3x7",
  "7x9x11",
  "3x7x9",
  "1x9x11",
  "1x3x9",
  "1x7",
  "3x7x11",
  "1x7x9"
), root_divisor = 33))
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
#>  1:    1x3x11 1.000000          1      0.0000             NA      0
#>  2:       1x9 1.090909      12/11    150.6371      150.63706      1
#>  3:    3x9x11 1.125000        9/8    203.9100       53.27294      2
#>  4:    1x7x11 1.166667        7/6    266.8709       62.96090      3
#>  5:     1x3x7 1.272727      14/11    417.5080      150.63706      4
#>  6:    7x9x11 1.312500      21/16    470.7809       53.27294      5
#>  7:     3x7x9 1.431818      63/44    621.4180      150.63706      6
#>  8:    1x9x11 1.500000        3/2    701.9550       80.53704      7
#>  9:     1x3x9 1.636364      18/11    852.5921      150.63706      8
#> 10:       1x7 1.696970      56/33    915.5530       62.96090      9
#> 11:    3x7x11 1.750000        7/4    968.8259       53.27294     10
#> 12:     1x7x9 1.909091      21/11   1119.4630      150.63706     11
#> 13:   1x3x11' 2.000000          2   1200.0000       80.53704     12
print(grady_a_offsets <- offset_matrix(grady_a))
#>           C   C#    D   D#    E    F   F#    G   G#    A    A#     B
#> 1x3x11    0 -100 -200 -300 -400 -500 -600 -700 -800 -900 -1000 -1100
#> 1x9     151   51  -49 -149 -249 -349 -449 -549 -649 -749  -849  -949
#> 3x9x11  204  104    4  -96 -196 -296 -396 -496 -596 -696  -796  -896
#> 1x7x11  267  167   67  -33 -133 -233 -333 -433 -533 -633  -733  -833
#> 1x3x7   418  318  218  118   18  -82 -182 -282 -382 -482  -582  -682
#> 7x9x11  471  371  271  171   71  -29 -129 -229 -329 -429  -529  -629
#> 3x7x9   621  521  421  321  221  121   21  -79 -179 -279  -379  -479
#> 1x9x11  702  602  502  402  302  202  102    2  -98 -198  -298  -398
#> 1x3x9   853  753  653  553  453  353  253  153   53  -47  -147  -247
#> 1x7     916  816  716  616  516  416  316  216  116   16   -84  -184
#> 3x7x11  969  869  769  669  569  469  369  269  169   69   -31  -131
#> 1x7x9  1119 1019  919  819  719  619  519  419  319  219   119    19
print(grady_b <- ps_scale_table(c(
  "3x5x11",
  "1x5x9",
  "3x5x9x11",
  "5x7x11",
  "3x5x7",
  "1x5x11",
  "1x3x5",
  "5x9x11",
  "3x5x9",
  "1x5x7",
  "3x5x7x11",
  "5x7x9"
), root_divisor = 3*5*11))
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
#>  1:    3x5x11 1.000000          1      0.0000             NA      0
#>  2:     1x5x9 1.090909      12/11    150.6371      150.63706      1
#>  3:  3x5x9x11 1.125000        9/8    203.9100       53.27294      2
#>  4:    5x7x11 1.166667        7/6    266.8709       62.96090      3
#>  5:     3x5x7 1.272727      14/11    417.5080      150.63706      4
#>  6:    1x5x11 1.333333        4/3    498.0450       80.53704      5
#>  7:     1x3x5 1.454545      16/11    648.6821      150.63706      6
#>  8:    5x9x11 1.500000        3/2    701.9550       53.27294      7
#>  9:     3x5x9 1.636364      18/11    852.5921      150.63706      8
#> 10:     1x5x7 1.696970      56/33    915.5530       62.96090      9
#> 11:  3x5x7x11 1.750000        7/4    968.8259       53.27294     10
#> 12:     5x7x9 1.909091      21/11   1119.4630      150.63706     11
#> 13:   3x5x11' 2.000000          2   1200.0000       80.53704     12
print(grady_b_offsets <- offset_matrix(grady_b))
#>             C   C#    D   D#    E    F   F#    G   G#    A    A#     B
#> 3x5x11      0 -100 -200 -300 -400 -500 -600 -700 -800 -900 -1000 -1100
#> 1x5x9     151   51  -49 -149 -249 -349 -449 -549 -649 -749  -849  -949
#> 3x5x9x11  204  104    4  -96 -196 -296 -396 -496 -596 -696  -796  -896
#> 5x7x11    267  167   67  -33 -133 -233 -333 -433 -533 -633  -733  -833
#> 3x5x7     418  318  218  118   18  -82 -182 -282 -382 -482  -582  -682
#> 1x5x11    498  398  298  198   98   -2 -102 -202 -302 -402  -502  -602
#> 1x3x5     649  549  449  349  249  149   49  -51 -151 -251  -351  -451
#> 5x9x11    702  602  502  402  302  202  102    2  -98 -198  -298  -398
#> 3x5x9     853  753  653  553  453  353  253  153   53  -47  -147  -247
#> 1x5x7     916  816  716  616  516  416  316  216  116   16   -84  -184
#> 3x5x7x11  969  869  769  669  569  469  369  269  169   69   -31  -131
#> 5x7x9    1119 1019  919  819  719  619  519  419  319  219   119    19
```
