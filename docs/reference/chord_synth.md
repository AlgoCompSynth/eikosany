# Synthesize a Chord

Creates a `Wave` object for a given chord

## Usage

``` r
chord_synth(chord, duration_sec, velocity = 100)
```

## Arguments

- chord:

  a vector of frequencies for the chord

- duration_sec:

  total duration of the chord in seconds

- velocity:

  MIDI velocity, default = 100, max is 127

## Value

a `Wave` object containing the synthesized chord

## Examples

``` r
if (FALSE) { # \dontrun{
  justmajor7th <- c(1, 5/4, 3/2, 7/4)
  wave <- chord_synth(256*justmajor7th, duration_sec = 10)
  tuneR::play(wave)
} # }
```
