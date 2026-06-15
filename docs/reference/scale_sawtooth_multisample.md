# Create Scale Sawtooth Multisample

Creates a multisample for the 1010music Blackbox for a given section of
a keyboard map.

## Usage

``` r
scale_sawtooth_multisample(
  keyboard_map,
  start_note_number,
  end_note_number,
  output_directory = "~/Multisample",
  duration_sec = 1,
  velocity = 100,
  sample_rate_hz = 48000,
  bit_width = 24
)
```

## Arguments

- keyboard_map:

  a keyboard map of the scale from eikosany::keyboard_map

- start_note_number:

  the starting MIDI note number for the scale

- end_note_number:

  the ending MIDI note number for the scale

- output_directory:

  character, default "~/Multisample". This will be created if it does
  not exist.

- duration_sec:

  how long to hold each note, default = 1

- velocity:

  MIDI velocity, default = 100, max is 127

- sample_rate_hz:

  sample rate in hz, default = 48000

- bit_width:

  bit width of samples, default = 24

## Value

the full path to output_directory

## Details

The 1010music Blackbox is a small music sampling studio. One of its
features is the ability to connect to a synthesizer and collect a
*multisample*.

A multisample is a set of `WAV` files with fixed duration over a set of
MIDI note numbers, and for each note number, a set of velocities. The
default velocity is 100; maximum possible velocity is 127. The default
`WAV` format is 24 bits with a sample rate of 48 kHz.

## Examples

``` r
if (FALSE) {
  eikosany <- cps_scale_table()
  eikosany_map <- keyboard_map(eikosany)

  # typical 37-key synthesizer
  path <- scale_sawtooth_multisample(eikosany_map, 48, 84)
  print(path)
}
```
