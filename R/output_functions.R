#' @title Create Minilogue XD `.scl` File
#' @name minilogue_xd_scl_file
#' @description Writes a Scala `.scl` file for the Korg Minilogue XD
#' @export minilogue_xd_scl_file
#' @param keyboard_map a keyboard map created by `keyboard_map`
#' @param output_file_path path to a file for which you have write permission
#' @param scale_description tell the user what scale this is. The default
#' includes a link to the `pkgdown` website for this package.
#' @returns a character vector containing the data written to the file. Each
#' element of the vector is a line of ASCII text.
#' @examples
#' \dontrun{
#' # `cps_scale_table` returns the 1-3-5-7-9-11 Eikosany by default
#' eikosany_map <- keyboard_map(cps_scale_table())
#' file_contents <- minilogue_xd_scl_file(
#'   eikosany_map,
#'   "~/minilogue-xd-eikosany.scl",
#'    "Eikosany 1-3-5-7-9-11"
#' )
#' }
#' @details The Korg Minilogue XD can be microtuned in two ways:
#' \itemize{
#' \item 1. A `user octave`: all octaves of the synthesizer are retuned using
#' offsets in cents from 12EDO notes. For scales with 12 or fewer notes, such as
#' a hexany or dekany, this will work, and you can use the `offset_matrix`
#' function to compute the settings required. This is easy to do either on
#' the synthesizer or using the Korg minilogue XD Sound Librarian.
#' \item 2. A `user scale`: this microtunes the whole MIDI keyboard from MIDI
#' note numbers zero through 127. You will need to use this method for an
#' eikosany, since it has 20 notes.
#' }
#'
#' The standard process to microtune a user scale is to use the Korg
#' minilogue xd Sound Librarian. You load a Scala `.scl` file or an `.scl`
#' and `.kbm` file for the scale into the librarian and upload to the
#' synthesizer. The `.scl` files from `minilogue_xd_scl_file` are
#' designed to remap the entire keyboard with just a `.scl` file. See the
#' vignette "Tuning the Korg Minilogue XD to the 1-3-5-7-9-11 Eikosany" for
#' details.

minilogue_xd_scl_file <- function(
    keyboard_map,
    output_file_path,
    scale_description = "'https://algocompsynth.github.io/eikosany/' made this!"
) {

  # check the keyboard map
  if (length(keyboard_map$cents) != 128) {
    stop("Keyboard map must have 128 rows!")
  }

  # construct data
  rcents <- round(keyboard_map$cents, 0)
  text_data <- c(
    paste("!", output_file_path),
    scale_description,
    "! number of ratios in scale",
    "127",
    "! ratios (cents above MIDI note number 0)",
    as.character(sprintf("%f", rcents[2:128]))
  )

  # write to file
  writeLines(text_data, output_file_path)

  # return the data
  return(text_data)
}

#' @title Create Chord Plot
#' @name chord_plot
#' @description Creates a `ggplot2` object to plot a chord
#' @export chord_plot
#' @importFrom magrittr "%>%"
#' @importFrom pichor generate_keys_chords
#' @importFrom pichor highlight_keys
#' @importFrom pichor ggpiano
#' @importFrom ggplot2 labs
#' @param chord a numeric vector with the scale degrees for the chord
#' @param title_string A string to use for a plot title. This will usually
#' be the chord name from a chord table
#' @param keyboard_map the keyboard map for the scale
#' @param base_note_number This routine assumes a 37-key synth keyboard,
#' with the leftmost key emitting a MIDI note number for a C. Thus,
#' `base_note_number` must be equal to zero modulo 12. The default is 48,
#' the C below middle C. This is where the Minilogue XD is set after a
#' factory reset.
#' @returns a `ggplot2` object that can be printed
#' @examples
#' \dontrun{
#'   eikosany <- cps_scale_table()
#'   eikosany_map <- keyboard_map(eikosany)
#'   print(chord_plot(
#'     c(1, 6, 11, 15),
#'      "1:3:5:7",
#'      eikosany_map,
#'      48
#'   ))
#' }
chord_plot <-
  function(chord, title_string, keyboard_map, base_note_number = 48) {

    chord_map <- keyboard_map[
      degree %in% chord & note_number >= base_note_number &
        note_number < base_note_number + 37
    ]
    key_numbers <- chord_map$note_number - base_note_number + 1
    keyboard_data <- pichor::generate_keys_chords(number_white_keys = 22)
  plot <-
    pichor::highlight_keys(data = keyboard_data, key_numbers) %>%
    pichor::ggpiano(keyboard_data, labels = TRUE) +
    ggplot2::labs(title = title_string)
  return(plot)
}

#' @title Create Chord MIDI File
#' @name chord_midi_file
#' @description Creates a MIDI file to play a given chord on a remapped
#' synthesizer
#' @export chord_midi_file
#' @importFrom gm Music
#' @importFrom gm Meter
#' @importFrom gm Tempo
#' @importFrom gm Line
#' @param chord a numeric vector with the scale degrees for the chord
#' @param keyboard_map the keyboard map for the scale
#' @param output_directory character, default "~/MIDI". This will be created
#' if it does not exist.
#' @param file_name character, default is `paste("chord", chord, sep="_")`.mid
#' @param tempo numeric, beats per minute, default is 60
#' @param hold_beats numeric number of beats to hold the chord, default is 1
#' @returns the full path to the file
#' @details The created MIDI file will play all inversions of the chord from
#' the lowest to the highest notes in the keyboard map.
#' @examples
#' \dontrun{
#'   eikosany <- cps_scale_table()
#'   eikosany_map <- keyboard_map(eikosany)
#'   print(chord_midi_file <- chord_midi_file(
#'     c(1, 6, 11, 15),
#'      eikosany_map
#'   ))
#' }
chord_midi_file <- function(
  chord,
  keyboard_map,
  output_directory = "~/MIDI",
  file_name = paste0("chord_", paste(chord, collapse = "_"), ".mid"),
  tempo = 60,
  hold_beats = 1
) {

  # initialize music object
  music_object <- gm::Music() + gm::Meter(4, 4) + gm::Tempo(tempo)

  # get the note numbers for all the notes in the chord
  chord_map <- keyboard_map[degree %in% chord]
  note_numbers <- sort(chord_map$note_number)

  # generate the chords
  chord_span <- length(chord)
  last_note_number <- length(note_numbers)
  root <- 1
  chord_list <- duration_list <- list()

  while (root <= last_note_number) {
    end <- root + chord_span - 1
    if (end > last_note_number) { break }
    chord_list <- append(chord_list, list(note_numbers[root:end]))
    duration_list <- append(duration_list, hold_beats)
    root <- root + 1
  }

  # add the line to the music object
  music_object <- music_object + gm::Line(
    pitches = chord_list,
    durations = duration_list
  )

  return(music_object)
}
