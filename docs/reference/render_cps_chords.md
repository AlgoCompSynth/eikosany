# Render the Chords of a CPS

Make WAV files for all chords of a given CPS

## Usage

``` r
render_cps_chords(scale_table, home_folder)
```

## Arguments

- scale_table:

  the scale table for the CPS

- home_folder:

  each chord will be rendered into a sub-folder of this one

## Value

the full path to output_directory

## Examples

``` r
if (FALSE) { # \dontrun{

(hexany_scale_table <- cps_scale_table(
  harmonics = c(1, 3, 5, 7),
  choose = 2
))
(render_cps_chords(hexany_scale_table, "~/hexany_chords"))

(eikosany_scale_table <- cps_scale_table())
(render_cps_chords(eikosany_scale_table, "~/eikosany_chords"))

} # }
```
