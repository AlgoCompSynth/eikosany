# Render the Chords of a CPS

Make WAV files for all chords of a given CPS

## Usage

``` r
render_cps_chords(scale_table, output_directory)
```

## Arguments

- scale_table:

  the scale table for the CPS

- output_directory:

  chords will be rendered into this folder

## Value

the full path to output_directory

## Examples

``` r
if (FALSE) { # \dontrun{

  hexany_scale_table <- cps_scale_table(
    harmonics = c(1, 3, 5, 7),
    choose = 2,
    root_divisor = 15
  )
  render_cps_chords(hexany_scale_table, "~/Music/hexany_chords")
  hexany_paths <- list.files("~/Music/hexany_chords", pattern = "\\.wav$", full.names = TRUE)
  combine_wav_files(hexany_paths, "~/Music/hexany_combined.wav")

  eikosany_scale_table <- cps_scale_table(
    harmonics = c(1, 3, 5, 7, 9, 11),
    choose = 3,
    root_divisor = 33
  )
  render_cps_chords(eikosany_scale_table, "~/Music/eikosany_chords")
  eikosany_paths <- list.files("~/Music/eikosany_chords", pattern = "\\.wav$", full.names = TRUE)
  combine_wav_files(eikosany_paths, "~/Music/eikosany_combined.wav")
} # }
```
