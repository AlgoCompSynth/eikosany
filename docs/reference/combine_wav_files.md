# Combine WAV Files into a Single WAV File

Reads a list of WAV files and concatenates them in order into a single
output WAV file.

## Usage

``` r
combine_wav_files(wav_files, output_file)
```

## Arguments

- wav_files:

  character vector of paths to WAV files to combine, in the order they
  should appear in the output.

- output_file:

  character, full path (including filename) for the combined output WAV
  file.

## Value

the full path to `output_file`, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
wav_paths <- list.files("~/my_chords", pattern = "\\.wav$", full.names = TRUE)
combine_wav_files(wav_paths, "~/my_chords/combined.wav")
} # }
```
