# Exercise 1

## 1. Generate a scale table and a chord table

Use function `eikosany::cps_chord_table` to compute the tetrads of
the 1-3-5-7-9-11 Eikosany. Hint: it's one of the examples in the
documentation of the function. You should have a scale table
`eikosany` and a chord table `eikosany_chords`.

## 2. Generate a sequence of pairs

The tetrads in `eikosany_chords` are listed in harmonic /
subharmonic pairs. For example, Key 1 has the harmonic chord
`1:3:5:7` and key 2 has its subharmonic variant `/1:/3:/5:/7`.
Generate a table `eikosany_random_pairs` with these pairs in a
random order.

Next, randomize each pair with a coin flip. If the coin comes
up heads, leave the pair in harmonic / subharmonic order. If the
coin comes up tails, switch the order of the tetrads in the pair.
Call the resulting table `eikosany_random_tetrads`.

## 3. Create WAV files of the sequence

- The root frequency of the scale should be A220 - 220 Hz, the A
below middle C.

- Use `eikosany::chord_synth` to generate a WAV file for each
tetrad in `eikosany_random_tetrads`. Use a triangle wave, a
duration of 3 seconds, a velocity of 100, a sample rate of
48,000 samples per second, and a 32-bit width.

## 4. Combine the WAV files

Combine the WAV files, in order. into a single WAV file
`eikosany_random_tetrads.wav`. Place that WAV file in the
audio player widget.
