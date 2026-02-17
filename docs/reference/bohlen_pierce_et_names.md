# Note names for equal-tempered Bohlen-Pierce scale

For scale tables created using function `et_scale_table`, the user must
specify note names. As a convenience, the `eikosany` package includes
data sets for `12EDO`, `19EDO`, `31EDO`, and the equal-tempered
Bohlen-Pierce scale.

## Usage

``` r
bohlen_pierce_et_names
```

## Format

### `bohlen_pierce_et_names`

A character vector with 13 elements

## Source

<https://en.wikipedia.org/wiki/Bohlen%E2%80%93Pierce_scale#Intervals_and_scale_diagrams>

## Details

Even in 2023, code often breaks when given characters outside the 7-bit
international standard. So we don't even have flats, let alone
half-flats, half-sharps, naturals, or any of the other symbols alternate
tuning theorists have proposed.

So for scales created with equal divisions of the octave, we use a "/b"
for a half-flat, "b" for a flat, "bb" for a double-flat, /#" for a
half-sharp, "#" for a sharp. and "##" for a double-sharp. Thanks in
advance for your understanding.
