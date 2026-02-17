# Create Chord WAV Files

Creates WAV files for inversions of a chord between two notes

## Usage

``` r
chord_WAVs(
  chord,
  keyboard_map,
  lowest_note = 48,
  highest_note = 84,
  output_directory = "~/Multisample",
  signal = "tria",
  duration_sec = 1,
  velocity = 100,
  sample_rate_hz = 48000,
  bit_width = 24
)
```

## Arguments

- chord:

  a numeric vector with the scale degrees for the chord

- keyboard_map:

  the keyboard map for the scale

- lowest_note:

  the lowest MIDI note number to use, default is 48.

- highest_note:

  the highest MIDI note number to use, default is 84.

- output_directory:

  character, default "~/Multisample". This will be created if it does
  not exist.

- signal:

  the `seewave` signal type, default is "tria"

- duration_sec:

  how long to hold each note, default = 4

- velocity:

  MIDI velocity, default = 100, max is 127

- sample_rate_hz:

  sample rate in hz, default = 48000

- bit_width:

  bit width of samples, default = 24

## Value

the full path to output_directory

## Examples

``` r
if (FALSE) { # \dontrun{
eikosany <- cps_scale_table()
eikosany_chords <- cps_chord_table(eikosany)
eikosany_map <- keyboard_map(eikosany)
chord_degrees <- eikosany_chords$degrees
for (i in 1:length(chord_degrees)) {
  chord <- as.numeric(unlist(strsplit(chord_degrees[i], ":")))
  folder_name <-
    paste0("~/eikosany-chords/chord-", gsub(":", "-", chord_degrees[i]))
  print(paste0("generating WAVs in folder ", folder_name))
  chord_WAVs(
    chord,
    keyboard_map = eikosany_map,
    lowest_note = 40,
    highest_note = 80,
    output_directory = folder_name
  )
}
} # }
```
