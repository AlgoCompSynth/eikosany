# Map a matrix of notes to their scale degrees

Map a matrix of notes to their scale degrees

## Usage

``` r
matrix2degree(note_matrix, scale_table)
```

## Arguments

- note_matrix:

  A matrix where rows are combinations of harmonic factors

- scale_table:

  A scale table from `ps_scale_table`, `cps_scale_table`, or
  `et_scale_table`

## Value

A data.table containing the degree for each note in the matrix
