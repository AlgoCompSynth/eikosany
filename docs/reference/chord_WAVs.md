# Create Chord WAV Files

Creates WAV files for inversions of a chord between two notes

## Usage

``` r
chord_WAVs(
  chord,
  keyboard_map,
  lowest_note,
  duration_sec,
  velocity = 100,
  output_directory
)
```

## Arguments

- chord:

  a numeric vector with the scale degrees for the chord

- keyboard_map:

  the keyboard map for the scale

- lowest_note:

  the lowest MIDI note number to use

- duration_sec:

  how long to hold each note

- velocity:

  MIDI velocity, default = 100, max is 127

- output_directory:

  character, no default; will be created!

## Value

the full path to output_directory
