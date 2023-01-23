#' @title Create Minilogue XD Scale File
#' @name create_minilogue_xd_scale_file
#' @description Writes a Scala `.scl` file for the Korg Minilogue XD
#' @export create_minilogue_xd_scale_file
#' @param keyboard_map a keyboard map created by `create_keyboard_map`
#' @param output_file_path path to a file for which you have write permission
#' @param scale_description tell the user what scale this is
#' @return a character vector containing the data written to the file. Each
#' element of the vector is a line of ASCII text.
#' @examples
#' \dontrun{
#'
#' eikosany_map <- create_keyboard_map(create_scale_table())
#' create_minilogue_xd_scale_file(
#'   eikosany_map, "~/test.scl", "Eikosany 1-3-5-7-9-11")
#' }
#' @details The Korg Minilogue XD can be microtuned in two ways:
#' \itemize{
#' \item 1. A `user octave`: all octaves of the synthesizer are microtuned using
#' offsets in cents from 12EDO notes. For scales with 12 or fewer notes, such as
#' a hexany or dekany, this will work, and you can use the key names and
#' offsets from a scale table made by `create_scale_table`.
#' \item 2. A `user scale`: this microtunes the whole MIDI keyboard from MIDI
#' note numbers zero through 127. You will need to use this method for an
#' eikosany.
#' }
#'
#' The standard process to microtune a user scale is to use the Korg minilogue
#' xd Sound Librarian. You load a Scala `.scl` and `.kbm` file for the scale
#' you want into the librarian and upload it to the synthesizer. In theory,
#' the Scala files from any of the microtonal scale creation tools will work.
#'
#' However, when I did this for the 1-3-5-7-9-11 eikosany, mapped so that
#' middle C on the keyboard plays 261.625565 Hz, and all the other keys are
#' mapped to match the eikosany scale, the synthesizer was tuned so that middle
#' C on the keyboard actually played the C two octaves below middle C!
#'
#' By downloading the microtuning from the synthesizer with the librarian and
#' examining the `.scl` and `.kbm` files, it looked like the librarian wasn't
#' correctly processing the input `.kbm` file. But the `.scl` file retrieved
#' from the synthesizer defined the entire mapping that the synthesizer was
#' playing. Technically, that `.scl` file satisfied the requirements defined in
#' <https://www.huygens-fokker.org/scala/scl_format.html>.
#'
#' The `.scl` file downloaded from the synthesizer defined an "octave" of 128
#' notes, and the notes were specified as cents above the default MIDI note
#' zero. This is a low C - 8.175799 Hz. So I prepared a `.scl` file with the
#' cents above note zero and uploaded that to the synthesizer without a `.kbm`
#' file.
#'
#' This correctly microtuned middle C and the notes nearby that I checked. I
#' didn't check the whole keyboard, but as near as I can tell it is all correct
#' except for note zero. The `.scl` file does not specify a value for that
#' note so it retains its default pitch of 8.175799 Hz.
#'
#' What this function does, then, is creates such a `.scl` file from a keyboard
#' map table. FAQ:
#' \itemize{
#' \item Yes, this is an ugly hack.
#' \item No, I will not accept issues against it.
#' \item Yes, I tried other tools to microtune the synthesizer via MIDI `sysex`
#' and they didn't work. I was not in the mood to troubleshoot Korg Windows
#' MIDI driver issues after spending close to a week troubleshooting their
#' sound librarian.
#' \item Yes, I sent an email to Korg support about the sound librarian issue.
#' I have not received any response other than an acknowledgement of my email.
#' }
#'
#' At some point I'll run out of easier tasks and try to troubleshoot the MIDI
#' `sysex` method. Or perhaps Korg will respond with an updated sound librarian.
#' Meanwhile, I've got this function and will be making music with it. Cheers!

create_minilogue_xd_scale_file <- function(
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
#' @name create_chord_plot
#' @description Creates a `ggplot2` object to plot a chord
#' @export create_chord_plot
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
#' @return a `ggplot2` object that can be printed
#' @examples
#' \dontrun{
#'   eikosany <- create_scale_table()
#'   eikosany_map <- create_keyboard_map(eikosany)
#'   print(create_chord_plot(
#'     c(1, 6, 11, 15),
#'      "1:3:5:7",
#'      eikosany_map,
#'      48
#'   ))
#' }
create_chord_plot <-
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

utils::globalVariables(c(
  #"keys_chords"
))
