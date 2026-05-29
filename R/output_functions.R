#' @title Create Chord Music Object
#' @name chord_music_object
#' @description Creates a `gm` music object for a given chord and keyboard map
#' @export chord_music_object
#' @importFrom gm Music
#' @importFrom gm Meter
#' @importFrom gm Tempo
#' @importFrom gm Line
#' @param chord a numeric vector with the scale degrees for the chord
#' @param keyboard_map the keyboard map for the scale
#' @param lowest_note the lowest MIDI note number to use. Default is 48.
#' @param highest_note the highest MIDI note number to use. Default is 84.
#' @param tempo numeric, beats per minute, default is 60
#' @param hold_beats numeric number of beats to hold the chord, default is 1
#' @returns the music object
#' @details The created music object contains a single line with all inversions
#' of the chord from the given lowest to the highest notes in the keyboard map.
#' @examples
#' \dontrun{
#'   eikosany <- cps_scale_table()
#'   eikosany_map <- keyboard_map(eikosany)
#'   print(eikosany_music_object <- chord_music_object(
#'     c(1, 6, 11, 15),
#'      eikosany_map,
#'      lowest_note = 40,
#'      highest_note = 80
#'   ))
#'
#'   vanilla <- et_scale_table()
#'   vanilla_map <- keyboard_map(vanilla)
#'   print(vanilla_music_object <- chord_music_object(
#'     c(0, 4, 7, 10),
#'      vanilla_map
#'   ))
#' }
chord_music_object <- function(
    chord,
    keyboard_map,
    lowest_note = 48,
    highest_note = 84,
    tempo = 60,
    hold_beats = 1
) {

  # initialize music object
  music_object <- gm::Music() + gm::Meter(4, 4) + gm::Tempo(tempo)

  # get the note numbers for all the notes in the chord
  chord_map <- keyboard_map[degree %in% chord & note_number >= lowest_note & note_number <= highest_note]
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

#' @title Export Music Object
#' @name export_music_object
#' @description Exports a `gm` music object to a MIDI file
#' @export export_music_object
#' @importFrom gm export
#' @param music_object a `gm` music object
#' @param file_name character The ".mid" suffix will be supplied
#' @param output_directory character, default "~/MIDI". This will be created
#' if it does not exist.
#' @returns the full path to the file
#' @examples
#' \dontrun{
#'   eikosany <- cps_scale_table()
#'   eikosany_map <- keyboard_map(eikosany)
#'   print(eikosany_music_object <- chord_music_object(
#'     c(1, 6, 11, 15),
#'      eikosany_map,
#'      lowest_note = 40,
#'      highest_note = 80
#'   ))
#'   print(file_path <- export_music_object(
#'     eikosany_music_object,
#'     "eikosany_chords"
#'   ))
#'
#'   vanilla <- et_scale_table()
#'   vanilla_map <- keyboard_map(vanilla)
#'   print(vanilla_music_object <- chord_music_object(
#'     c(0, 4, 7, 10),
#'      vanilla_map
#'   ))
#'   print(file_path <- export_music_object(
#'     vanilla_music_object,
#'     "vanilla_chords"
#'   ))
#' }
export_music_object <- function(
  music_object,
  file_name,
  output_directory = "~/MIDI"
) {

  # create the directory
  dir.create(output_directory, recursive = TRUE)

  # export the object
  gm::export(music_object, output_directory, file_name, formats = "mid")

  file.path(output_directory, paste0(file_name, ".mid"))
}

#' @title Create Chord WAV Files
#' @name chord_WAVs
#' @description Creates WAV files for inversions of a chord between
#' two notes
#' @export chord_WAVs
#' @param chord a numeric vector with the scale degrees for the chord
#' @param keyboard_map the keyboard map for the scale
#' @param lowest_note the lowest MIDI note number to use, default
#' is 48.
#' @param highest_note the highest MIDI note number to use, default
#' is 84.
#' @param output_directory character, default "~/Multisample". This will
#' be created if it does not exist.
#' @param signal the `seewave` signal type, default is "tria"
#' @param duration_sec how long to hold each note, default = 4
#' @param velocity MIDI velocity, default = 100, max is 127
#' @param sample_rate_hz sample rate in hz, default = 48000
#' @param bit_width bit width of samples, default = 24
#' @returns the full path to output_directory
#' @examples
#' \dontrun{
#' eikosany <- cps_scale_table()
#' eikosany_chords <- cps_chord_table(eikosany)
#' eikosany_map <- keyboard_map(eikosany)
#' chord_degrees <- eikosany_chords$degrees
#' for (i in 1:length(chord_degrees)) {
#'   chord <- as.numeric(unlist(strsplit(chord_degrees[i], ":")))
#'   folder_name <-
#'     paste0("~/eikosany-chords/chord-", gsub(":", "-", chord_degrees[i]))
#'   print(paste0("generating WAVs in folder ", folder_name))
#'   chord_WAVs(
#'     chord,
#'     keyboard_map = eikosany_map,
#'     lowest_note = 40,
#'     highest_note = 80,
#'     output_directory = folder_name
#'   )
#' }
#' }
#'
chord_WAVs <- function(
    chord,
    keyboard_map,
    lowest_note = 48,
    highest_note = 84,
    output_directory = "~/Multisample",
    signal = "tria",
    duration_sec = 1,
    velocity = 100,
    sample_rate_hz = 48000,
    bit_width = 24
) {

  # create the directory
  dir.create(output_directory, recursive = TRUE)

  # get the frequencies for all the notes in the chord
  chord_map <- keyboard_map[
    degree %in% chord &
      note_number >= lowest_note &
      note_number <= highest_note
  ]
  frequencies <- sort(chord_map$freq)
  note_numbers <- sort(chord_map$note_number)

  # generate the chords
  chord_span <- length(chord)
  last_index <- length(frequencies)
  root_index <- 1

  while (root_index <= last_index) {
    end_index <- root_index + chord_span - 1
    if (end_index > last_index) { break }
    chord_frequencies <- frequencies[root_index:end_index]
    chord_label <- paste(
      note_numbers[root_index:end_index],
      collapse = "_"
    )
    wave_object <- chord_synth(
      chord_frequencies,
      signal = signal,
      duration_sec = duration_sec,
      velocity = velocity,
      sample_rate_hz = sample_rate_hz,
      bit_width = bit_width
    )

    # make file name -
    file_name <- sprintf(
      "%s-%s.wav",
      signal,
      chord_label
    )
    file_path <- file.path(output_directory, file_name)

    # and write it!
    tuneR::writeWave(wave_object, file_path)

    root_index <- root_index + 1
  }

  output_directory
}

#' @title Synthesize a Chord
#' @name chord_synth
#' @description Creates a `Wave` object for a given chord
#' @export chord_synth
#' @importFrom seewave synth
#' @importFrom tuneR Wave
#' @importFrom tuneR normalize
#' @importFrom tuneR silence
#' @param chord a vector of frequencies for the chord
#' @param signal The `seewave` signal type: "sine", "tria",
#' "square" or "saw", default = "tria"
#' @param duration_sec how many seconds to hold each note,
#' default = 1
#' @param velocity MIDI velocity, default = 100, max is 127
#' @param sample_rate_hz sample rate in hz, default = 48000
#' @param bit_width bit width of samples, default = 24
#' @returns the full path to output_directory
#' @examples
#' \dontrun{
#' justmajor7th <- c(1, 5/4, 3/2, 7/4)
#' wave <- chord_synth(256*justmajor7th, duration_sec = 10)
#' tuneR::play(wave)
#' }
#'
chord_synth <- function(
  chord,
  signal = "tria",
  duration_sec = 1,
  velocity = 100,
  sample_rate_hz = 48000,
  bit_width = 24
) {

  # detonate if bad bit width
  legal_bit_widths <- c(8, 16, 24, 32, 64)
  if (!(bit_width %in% legal_bit_widths)) {
    stop(paste0("bit_width", bit_width, "not in", legal_bit_widths))
  }

  # set `pcm`
  pcm <- ifelse(bit_width < 32, TRUE, FALSE)

  # compute level
  MAX_VELOCITY = 127.0
  level = velocity / MAX_VELOCITY

  # initialize sample vector
  sample_vector <- tuneR::silence(
    duration = duration_sec,
    samp.rate = sample_rate_hz,
    bit = 32,
    xunit = "time"
  )
  sample_vector <- sample_vector@left
  sample_vector <- 0

  for (note in chord) {

    note_wave <- seewave::synth(
      f = sample_rate_hz,
      d = duration_sec,
      cf = note,
      signal = signal,
      output = "Wave")
    sample_vector <- sample_vector + note_wave@left

  }

  # convert numeric to Wave object
  chord_wave_raw <- tuneR::Wave(
    sample_vector,
    samp.rate = sample_rate_hz,
    bit = bit_width,
    pcm = pcm
  )

  # normalize to given velocity - max velocity is 127.0
  chord_wave <- tuneR::normalize(
    chord_wave_raw,
    unit = as.character(bit_width),
    level = level
  )

  return(chord_wave)

}


utils::globalVariables(c(
  "highest_note",
  "freq"
))

#' @title Render the Chords of a CPS
#' @name render_cps_chords
#' @description Make WAV files for all chords of a given CPS
#' @export render_cps_chords
#' @param scale_table the scale table for the CPS
#' @param home_folder each chord will be rendered into a sub-folder
#' of this one
#' @returns the full path to output_directory
#' @examples
#' \dontrun{
#'
#' (hexany_scale_table <- cps_scale_table(
#'   harmonics = c(1, 3, 5, 7),
#'   choose = 2
#' ))
#' (render_cps_chords(hexany_scale_table, "~/hexany_chords"))
#'
#' (eikosany_scale_table <- cps_scale_table())
#' (render_cps_chords(eikosany_scale_table, "~/eikosany_chords"))
#'
#' }
#'
render_cps_chords <- function(scale_table, home_folder) {

  scale_degrees <- nrow(scale_table) - 1
  chord_table <- cps_chord_table(scale_table)
  keyboard_map <- keyboard_map(scale_table)
  chord_degrees <- chord_table$degrees
  chord_labels <- chord_table$chord

  # santize for filename use
  chord_labels <- gsub("/", "-", chord_labels, fixed = TRUE)
  chord_labels <- gsub(":", "_", chord_labels, fixed = TRUE)

  for (i in 1:length(chord_degrees)) {
    chord <- as.numeric(unlist(strsplit(chord_degrees[i], ":")))
    folder_name <-
      file.path(home_folder, paste0("chord_", chord_labels[i]))
    chord_WAVs(
      chord,
      keyboard_map,
      lowest_note = 60,
      highest_note = 60 + 2 * scale_degrees,
      output_directory = folder_name
    )
  }

  home_folder
}
