# Example Session

``` r
library(eikosany)
library(data.table)
#> 
#> Attaching package: 'data.table'
#> The following object is masked from 'package:base':
#> 
#>     %notin%
library(tuneR)
```

## Overview

This vignette walks through a complete example session using `eikosany`
to generate, synthesize, and explore the 1-3-5-7-9-11 Eikosany. The
session covers:

1.  Building the scale table and chord table,
2.  Synthesizing all chords in order and combining them into a single
    WAV file, and
3.  Synthesizing a randomized version via a random walk through the
    chord table.

The synthesis and file I/O steps use `eval=FALSE` since they write audio
files to disk and take non-trivial time to render.

## Building the Scale and Chord Tables

The 1-3-5-7-9-11 Eikosany is the default output of `cps_scale_table`. We
use `root_divisor = 33` (i.e., 1×3×11) following Erv Wilson’s original
convention, which maps the product 1×5×11 to the 5/3 ratio.

``` r
eik_root_33 <- cps_scale_table(root_divisor = 33)
eik_root_33
```

The scale has 20 degrees (plus the octave as row 21). Each row gives the
product label used as the note name, its ratio to the root, the ratio as
a fraction, the ratio in cents, the interval in cents from the previous
degree, and the degree number.

Next, we compute the chord table — all tetrads (4-note chords) that can
be formed from the scale:

``` r
chord_eik_root_33 <- cps_chord_table(eik_root_33)
chord_eik_root_33
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
```

The chord table contains 30 rows: 15 harmonic tetrads and their 15
subharmonic complements (`is_subharm = 1`). The `degrees` column gives
the scale degrees of each chord as a colon-separated string, which we
will use to look up frequencies via `keyboard_map`.

## Sequential Synthesis

We synthesize each chord in order using `chord_synth` with its default
parameters (triangle wave, 1 second duration, 48 kHz / 24-bit). The
`keyboard_map` function maps scale degrees to frequencies; we restrict
to MIDI note numbers 60–79 to keep all chords in a consistent register
around middle C.

``` r
output_dir <- path.expand("~/Music/eik_wavs_sequential")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

km <- keyboard_map(eik_root_33)

chord_list   <- chord_eik_root_33$degrees
chord_labels <- chord_eik_root_33$chord
chord_labels <- gsub("/", "-", chord_labels, fixed = TRUE)
chord_labels <- gsub(":", "_", chord_labels, fixed = TRUE)

for (i in seq_along(chord_list)) {
  degrees <- as.numeric(unlist(strsplit(chord_list[i], ":")))
  freqs   <- sort(km[degree %in% degrees & note_number >= 60 & note_number <= 79, freq])
  if (length(freqs) < 2) next
  wave      <- chord_synth(freqs)
  file_path <- file.path(output_dir, sprintf("%02d-%s.wav", i, chord_labels[i]))
  writeWave(wave, file_path)
}
```

This produces 30 WAV files in `~/Music/eik_wavs_sequential`, one per
chord, named and numbered to match the order in `chord_eik_root_33`.

### Combining into a Single File

``` r
wav_files <- sort(list.files(output_dir, pattern = "\\.wav$", full.names = TRUE))
combine_wav_files(wav_files, file.path(output_dir, "eik_root_33_combined.wav"))
```

The result is a 30-second file that plays all 15 harmonic tetrads
followed by all 15 subharmonic tetrads in sequence.

## Random Walk Synthesis

For a more musical exploration, we traverse the chord table via a random
walk: starting at a randomly chosen row, at each step we move either one
row up or one row down (with wraparound), and synthesize the current
chord with a uniformly random duration between 0.25 and 1 second. The
walk stops once the accumulated duration reaches 2 minutes.

``` r
set.seed(6174)

n_chords        <- nrow(chord_eik_root_33)
total_duration  <- 0
target_duration <- 120  # 2 minutes in seconds
current_row     <- sample(seq_len(n_chords), 1)
wave_list       <- list()

while (total_duration < target_duration) {
  dur     <- round(runif(1, 0.25, 1), 2)
  deg     <- as.numeric(unlist(strsplit(chord_eik_root_33$degrees[current_row], ":")))
  freqs   <- sort(km[degree %in% deg & note_number >= 60 & note_number <= 79, freq])

  if (length(freqs) >= 2) {
    wave_list      <- c(wave_list, list(chord_synth(freqs, duration_sec = dur)))
    total_duration <- total_duration + dur
  }

  direction   <- sample(c(-1L, 1L), 1)
  current_row <- ((current_row - 1L + direction) %% n_chords) + 1L
}
```

With `set.seed(6174)` the walk starts at row 7 (`1:3:7:9`), visits 191
chords, and reaches 120.16 seconds total.

### Combining into a Single File

``` r
combined <- wave_list[[1]]
for (w in wave_list[-1]) {
  combined <- tuneR::bind(combined, w)
}
writeWave(combined, file.path(output_dir, "eik_root_33_random.wav"))
```

The resulting file `eik_root_33_random.wav` is approximately 17 MB and
captures the harmonic texture of the Eikosany as heard through a
continuous, locally-coherent random traversal of its chord space.
