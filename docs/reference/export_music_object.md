# Export Music Object

Exports a `gm` music object to a MIDI file

## Usage

``` r
export_music_object(music_object, file_name, output_directory = "~/MIDI")
```

## Arguments

- music_object:

  a `gm` music object

- file_name:

  character The ".mid" suffix will be supplied

- output_directory:

  character, default "~/MIDI". This will be created if it does not
  exist.

## Value

the full path to the file

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
  print(file_path <- export_music_object(
    eikosany_music_object,
    "eikosany_chords"
  ))

  vanilla <- et_scale_table()
  vanilla_map <- keyboard_map(vanilla)
  print(vanilla_music_object <- chord_music_object(
    c(0, 4, 7, 10),
     vanilla_map
  ))
  print(file_path <- export_music_object(
    vanilla_music_object,
    "vanilla_chords"
  ))
} # }
```
