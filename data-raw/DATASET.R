## code to prepare `DATASET` dataset goes here

edo12_names <- c(
  "C",
  "C#|Db",
  "D",
  "D#|Eb",
  "E",
  "F",
  "F#|Gb",
  "G",
  "G#|Ab",
  "A",
  "A#|Bb",
  "B"
)
usethis::use_data(edo12_names, overwrite = TRUE)

edo19_names <- c(
  "C",
  "C#",
  "Db",
  "D",
  "D#",
  "Eb",
  "E",
  "E#|Fb",
  "F",
  "F#",
  "Gb",
  "G",
  "G#",
  "Ab",
  "A",
  "A#",
  "Bb",
  "B",
  "B#|Cb"
)
usethis::use_data(edo19_names, overwrite = TRUE)

edo31_names <- c(
  "C",
  "C/#",
  "C#",
  "Db",
  "D/b",
  "D",
  "D/#",
  "D#",
  "Eb",
  "E/b",
  "E",
  "Fb",
  "E#",
  "F",
  "F/#",
  "F#",
  "Gb",
  "G/b",
  "G",
  "G/#",
  "G#",
  "Ab",
  "A/b",
  "A",
  "A/#",
  "A#",
  "Bb",
  "B/b",
  "B",
  "Cb",
  "B#"
)
usethis::use_data(edo31_names, overwrite = TRUE)

bohlen_pierce_et_names <- c(
  "C",
  "C#|Db",
  "D",
  "E",
  "F",
  "F#|Gb",
  "G",
  "H",
  "H#|Jb",
  "J",
  "A",
  "A#|Bb",
  "B"
)
usethis::use_data(bohlen_pierce_et_names, overwrite = TRUE)

# Make Eiksoany chord MIDI files

## Create chord table
scale <- eikosany::cps_scale_table() # 1-3-5-7-9-11 Eikosany is the default
scale_degrees <- length(scale$degree) - 1
map <- eikosany::keyboard_map(scale)
chords <- eikosany::cps_chord_table(scale)

## make filename-compatible chord names
chord_names <- chords$chord
chord_names <- gsub(":/", "-", chord_names, fixed = TRUE)
chord_names <- gsub(":", "-", chord_names, fixed = TRUE)
chord_names <- gsub("/", "sub-", chord_names, fixed = TRUE)

## convert the chord degrees to a matrix
degrees <- chords$degrees
degrees_matrix <- matrix(
  unlist(lapply(strsplit(degrees, ":"), as.numeric)),
  byrow = TRUE,
  nrow = length(degrees)
)

## main loop to generate MIDI files
for (ichord in 1:nrow(degrees_matrix)) {
  chord_vector <- degrees_matrix[ichord, ]

  # all inversions over the same three octaves in a typical 37-key synth
  music_object <- eikosany::chord_music_object(
    chord_vector,
    map,
    lowest_note = 40,
    highest_note = 100,
    tempo = 60,
    hold_beats = 1
  )

  # write the file
  file_name <- paste0("eikosany-", chord_names[ichord])
  file_path <- eikosany::export_music_object(
    music_object,
    file_name,
    output_directory = "inst/Eikosany-Chord-MIDI-Files"
  )
  print(file_path)
}
