# Synthesize a Chord

Creates a `Wave` object for a given chord

## Usage

``` r
chord_synth(
  chord,
  signal = "tria",
  duration_sec = 1,
  velocity = 100,
  sample_rate_hz = 48000,
  bit_width = 24
)
```

## Arguments

- chord:

  a vector of frequencies for the chord

- signal:

  The `seewave` signal type: "sine", "tria", "square" or "saw", default
  = "tria"

- duration_sec:

  how many seconds to hold each note, default = 1

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
justmajor7th <- c(1, 5/4, 3/2, 7/4)
wave <- chord_synth(256*justmajor7th, duration_sec = 10)
tuneR::play(wave)
} # }
```
