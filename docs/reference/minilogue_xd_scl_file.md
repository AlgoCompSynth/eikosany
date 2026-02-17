# Create Minilogue XD `.scl` File

Writes a Scala `.scl` file for the Korg Minilogue XD

## Usage

``` r
minilogue_xd_scl_file(
  keyboard_map,
  output_file_path,
  scale_description = "'https://algocompsynth.github.io/eikosany/' made this!"
)
```

## Arguments

- keyboard_map:

  a keyboard map created by `keyboard_map`

- output_file_path:

  path to a file for which you have write permission

- scale_description:

  tell the user what scale this is. The default includes a link to the
  `pkgdown` website for this package.

## Value

a character vector containing the data written to the file. Each element
of the vector is a line of ASCII text.

## Details

The Korg Minilogue XD can be microtuned in two ways:

- 1\. A `user octave`: all octaves of the synthesizer are retuned using
  offsets in cents from 12EDO notes. For scales with 12 or fewer notes,
  such as a hexany or dekany, this will work, and you can use the
  `offset_matrix` function to compute the settings required. This is
  easy to do either on the synthesizer or using the Korg minilogue XD
  Sound Librarian.

- 2\. A `user scale`: this microtunes the whole MIDI keyboard from MIDI
  note numbers zero through 127. You will need to use this method for an
  eikosany, since it has 20 notes.

The standard process to microtune a user scale is to use the Korg
minilogue xd Sound Librarian. You load a Scala `.scl` file or an `.scl`
and `.kbm` file for the scale into the librarian and upload to the
synthesizer. The `.scl` files from `minilogue_xd_scl_file` are designed
to remap the entire keyboard with just a `.scl` file. See the vignette
"Tuning the Korg Minilogue XD to the 1-3-5-7-9-11 Eikosany" for details.

## Examples

``` r
if (FALSE) { # \dontrun{
# `cps_scale_table` returns the 1-3-5-7-9-11 Eikosany by default
eikosany_map <- keyboard_map(cps_scale_table())
file_contents <- minilogue_xd_scl_file(
  eikosany_map,
  "~/minilogue-xd-eikosany.scl",
   "Eikosany 1-3-5-7-9-11"
)
} # }
```
