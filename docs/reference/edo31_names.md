# Note names for 31EDO

For scale tables created using function `et_scale_table`, the user must
specify note names. As a convenience, the `eikosany` package includes
data sets for `12EDO`, `19EDO`, and `31EDO`.

## Usage

``` r
edo31_names
```

## Format

### `edo31_names`

A character vector with 31 elements

## Source

<https://en.wikipedia.org/wiki/31_equal_temperament#Scale_diagram>

## Details

Even in 2023, code often breaks when given characters outside the 7-bit
international standard. So we don't even have flats, let alone
half-flats, half-sharps, naturals, or any of the other symbols alternate
tuning theorists have proposed.

So for scales created with equal divisions of the octave, we use a "/b"
for a half-flat, "b" for a flat, "bb" for a double-flat, /#" for a
half-sharp, "#" for a sharp. and "##" for a double-sharp. Thanks in
advance for your understanding.
