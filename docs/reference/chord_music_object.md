# Create Chord Music Object

Creates a `gm` music object for a given chord and keyboard map

## Usage

``` r
chord_music_object(
  chord,
  keyboard_map,
  lowest_note = 48,
  highest_note = 84,
  tempo = 60,
  hold_beats = 1
)
```

## Arguments

- chord:

  a numeric vector with the scale degrees for the chord

- keyboard_map:

  the keyboard map for the scale

- lowest_note:

  the lowest MIDI note number to use. Default is 48.

- highest_note:

  the highest MIDI note number to use. Default is 84.

- tempo:

  numeric, beats per minute, default is 60

- hold_beats:

  numeric number of beats to hold the chord, default is 1

## Value

the music object

## Details

The created music object contains a single line with all inversions of
the chord from the given lowest to the highest notes in the keyboard
map.

## Examples

``` r
if (FALSE) { # \dontrun{
  eikosany <- cps_scale_table()
  eikosany_map <- keyboard_map(eikosany)
  print(eikosany_music_object <- chord_music_object(
    c(1, 6, 11, 15),
     eikosany_map,
     lowest_note = 40,
     highest_note = 80
  ))

  vanilla <- et_scale_table()
  vanilla_map <- keyboard_map(vanilla)
  print(vanilla_music_object <- chord_music_object(
    c(0, 4, 7, 10),
     vanilla_map
  ))
} # }
```
