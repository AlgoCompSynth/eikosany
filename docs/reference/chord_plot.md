# Create Chord Plot

Creates a `ggplot2` object to plot a chord

## Usage

``` r
chord_plot(chord, title_string, keyboard_map, base_note_number = 48)
```

## Arguments

- chord:

  a numeric vector with the scale degrees for the chord

- title_string:

  A string to use for a plot title. This will usually be the chord name
  from a chord table

- keyboard_map:

  the keyboard map for the scale

- base_note_number:

  This routine assumes a 37-key synth keyboard, with the leftmost key
  emitting a MIDI note number for a C. Thus, `base_note_number` must be
  equal to zero modulo 12. The default is 48, the C below middle C. This
  is where the Minilogue XD is set after a factory reset.

## Value

a `ggplot2` object that can be printed

## Examples

``` r
if (FALSE) { # \dontrun{
  eikosany <- cps_scale_table()
  eikosany_map <- keyboard_map(eikosany)
  print(chord_plot(
    c(1, 6, 11, 15),
     "1:3:5:7",
     eikosany_map,
     48
  ))
} # }
```
