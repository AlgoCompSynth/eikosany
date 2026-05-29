# Create Equal-Tempered Scale Table

Creates a scale table for equal divisions of a specified period.

## Usage

``` r
et_scale_table(
  note_names = c("C", "C#|Db", "D", "D#|Eb", "E", "F", "F#|Gb", "G", "G#|Ab", "A",
    "A#|Bb", "B"),
  period = 2
)
```

## Arguments

- note_names:

  a character vector with the names of the notes in the scale. The
  default is the names of the standard 12 equal divisions of the octave.

- period:

  The period - default is 2, for an octave

## Value

a `data.table` with six columns:

- `note_name`: the note name (character)

- `ratio`: the ratio that defines the note, as a number between 1 and
  `period`

- `ratio_frac`: the ratio as a vulgar fraction (character). The ratios
  for most EDOs are irrational, so this is an approximation.

- `ratio_cents`: the ratio in cents (hundredths of a semitone)

- `interval_cents`: interval between this note and the previous note

- `degree`: scale degree from zero to (number of notes) - 1

## Examples

``` r
print(vanilla <- et_scale_table()) # default is 12EDO, of course
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
#>  1:         C 1.000000          1           0             NA      0
#>  2:     C#|Db 1.059463  1461/1379         100            100      1
#>  3:         D 1.122462  1714/1527         200            100      2
#>  4:     D#|Eb 1.189207  1785/1501         300            100      3
#>  5:         E 1.259921    635/504         400            100      4
#>  6:         F 1.334840  3249/2434         500            100      5
#>  7:     F#|Gb 1.414214   1393/985         600            100      6
#>  8:         G 1.498307  2213/1477         700            100      7
#>  9:     G#|Ab 1.587401   1008/635         800            100      8
#> 10:         A 1.681793  3002/1785         900            100      9
#> 11:     A#|Bb 1.781797   1527/857        1000            100     10
#> 12:         B 1.887749  2943/1559        1100            100     11
#> 13:        C' 2.000000          2        1200            100     12

# 19-EDO
print(edo19 <- et_scale_table(edo19_names))
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
#>  1:         C 1.000000          1     0.00000             NA      0
#>  2:        C# 1.037155    977/942    63.15789       63.15789      1
#>  3:        Db 1.075691    739/687   126.31579       63.15789      2
#>  4:         D 1.115658    627/562   189.47368       63.15789      3
#>  5:        D# 1.157110   1009/872   252.63158       63.15789      4
#>  6:        Eb 1.200103  2333/1944   315.78947       63.15789      5
#>  7:         E 1.244693   1114/895   378.94737       63.15789      6
#>  8:     E#|Fb 1.290939  1553/1203   442.10526       63.15789      7
#>  9:         F 1.338904  1442/1077   505.26316       63.15789      8
#> 10:        F# 1.388651   1297/934   568.42105       63.15789      9
#> 11:        Gb 1.440247  1639/1138   631.57895       63.15789     10
#> 12:         G 1.493759   1077/721   694.73684       63.15789     11
#> 13:        G# 1.549260  2406/1553   757.89474       63.15789     12
#> 14:        Ab 1.606822    895/557   821.05263       63.15789     13
#> 15:         A 1.666524  3893/2336   884.21053       63.15789     14
#> 16:        A# 1.728444  1744/1009   947.36842       63.15789     15
#> 17:        Bb 1.792664   1124/627  1010.52632       63.15789     16
#> 18:         B 1.859271   1123/604  1073.68421       63.15789     17
#> 19:     B#|Cb 1.928352   1884/977  1136.84211       63.15789     18
#> 20:        C' 2.000000          2  1200.00000       63.15789     19
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
# 31-EDO
print(edo31 <- et_scale_table(edo31_names))
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
#>  1:         C 1.000000          1     0.00000             NA      0
#>  2:       C/# 1.022611  1402/1371    38.70968       38.70968      1
#>  3:        C# 1.045734  1189/1137    77.41935       38.70968      2
#>  4:        Db 1.069380  1156/1081   116.12903       38.70968      3
#>  5:       D/b 1.093560    900/823   154.83871       38.70968      4
#>  6:         D 1.118287  1645/1471   193.54839       38.70968      5
#>  7:       D/# 1.143573    685/599   232.25806       38.70968      6
#>  8:        D# 1.169431    987/844   270.96774       38.70968      7
#>  9:        Eb 1.195873  3999/3344   309.67742       38.70968      8
#> 10:       E/b 1.222914    982/803   348.38710       38.70968      9
#> 11:         E 1.250566  2211/1768   387.09677       38.70968     10
#> 12:        Fb 1.278843  3403/2661   425.80645       38.70968     11
#> 13:        E# 1.307759  1500/1147   464.51613       38.70968     12
#> 14:         F 1.337329    781/584   503.22581       38.70968     13
#> 15:       F/# 1.367568    253/185   541.93548       38.70968     14
#> 16:        F# 1.398491  1853/1325   580.64516       38.70968     15
#> 17:        Gb 1.430113  2783/1946   619.35484       38.70968     16
#> 18:       G/b 1.462450    370/253   658.06452       38.70968     17
#> 19:         G 1.495518   1168/781   696.77419       38.70968     18
#> 20:       G/# 1.529334   1147/750   735.48387       38.70968     19
#> 21:        G# 1.563914  2557/1635   774.19355       38.70968     20
#> 22:        Ab 1.599276  3536/2211   812.90323       38.70968     21
#> 23:       A/b 1.635438    803/491   851.61290       38.70968     22
#> 24:         A 1.672418  6785/4057   890.32258       38.70968     23
#> 25:       A/# 1.710234   1387/811   929.03226       38.70968     24
#> 26:        A# 1.748905   1198/685   967.74194       38.70968     25
#> 27:        Bb 1.788450  2942/1645  1006.45161       38.70968     26
#> 28:       B/b 1.828889    823/450  1045.16129       38.70968     27
#> 29:         B 1.870243   1081/578  1083.87097       38.70968     28
#> 30:        Cb 1.912532   1465/766  1122.58065       38.70968     29
#> 31:        B# 1.955777   1371/701  1161.29032       38.70968     30
#> 32:        C' 2.000000          2  1200.00000       38.70968     31
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>

# equal-tempered Bohlen-Pierce
print(bohlen_pierce_et <- et_scale_table(bohlen_pierce_et_names, period = 3))
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
#>  1:         C 1.000000          1      0.0000             NA      0
#>  2:     C#|Db 1.088182  1197/1100    146.3042       146.3042      1
#>  3:         D 1.184141    881/744    292.6085       146.3042      2
#>  4:         E 1.288561  1746/1355    438.9127       146.3042      3
#>  5:         F 1.402189   1025/731    585.2169       146.3042      4
#>  6:     F#|Gb 1.525837  3691/2419    731.5212       146.3042      5
#>  7:         G 1.660389  2645/1593    877.8254       146.3042      6
#>  8:         H 1.806806   1646/911   1024.1296       146.3042      7
#>  9:     H#|Jb 1.966134  2090/1063   1170.4338       146.3042      8
#> 10:         J 2.139512   2101/982   1316.7381       146.3042      9
#> 11:         A 2.328179   1355/582   1463.0423       146.3042     10
#> 12:     A#|Bb 2.533483   1135/448   1609.3465       146.3042     11
#> 13:         B 2.756891  6101/2213   1755.6508       146.3042     12
#> 14:        C' 3.000000          3   1901.9550       146.3042     13
```
