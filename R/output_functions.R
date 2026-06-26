# Wave file / object defaults
SAMP_RATE <- 44100
BIT <- 32
PCM <- FALSE
MAX_VELOCITY <- 127.0
DURATION_SEC <- 1.5

#' @title Create Chord WAV Files
#' @name chord_WAVs
#' @description Creates WAV files for inversions of a chord between
#' two notes
#' @export chord_WAVs
#' @param chord a numeric vector with the scale degrees for the chord
#' @param keyboard_map the keyboard map for the scale
#' @param lowest_note the lowest MIDI note number to use
#' @param output_directory character, no default; will be created!
#' @param duration_sec how long to hold each note
#' @param velocity MIDI velocity, default = 100, max is 127
#' @returns the full path to output_directory
#'
chord_WAVs <- function(
    chord,
    keyboard_map,
    lowest_note,
    duration_sec,
    velocity = 100,
    output_directory
) {

  chord_degrees_label <- paste(chord, collapse = "_")

  # create the directory
  if (! dir.exists(output_directory)) {
    dir.create(output_directory, recursive = TRUE)
  }

  # get the frequencies for all the notes in the chord
  chord_map <- keyboard_map[
    degree %in% chord &
      note_number >= lowest_note
  ]
  frequencies <- sort(chord_map$freq)
  note_numbers <- sort(chord_map$note_number)

  # generate the chords
  chord_span <- length(chord)
  last_index <- length(frequencies)
  root_index <- 1
  inversions2do <- chord_span + 1

  while (inversions2do > 0) {
    end_index <- root_index + chord_span - 1
    chord_frequencies <- frequencies[root_index:end_index]
    chord_label <- paste(
      note_numbers[root_index:end_index],
      collapse = "_"
    )
    wave_object <- chord_synth(
      chord_frequencies,
      duration_sec,
      velocity = 100
    )

    # make file name -
    file_name <- sprintf(
      "%s-%s.wav",
      chord_degrees_label,
      chord_label
    )
    file_path <- paste0(output_directory, "/", file_name)

    # and write it!
    tuneR::writeWave(wave_object, file_path)

    root_index <- root_index + 1
    inversions2do <- inversions2do - 1
  }

  return(invisible(output_directory))

}

#' @title Synthesize a Chord
#' @name chord_synth
#' @description Creates a `Wave` object for a given chord
#' @export chord_synth
#' @importFrom tuneR Wave
#' @importFrom tuneR normalize
#' @importFrom tuneR silence
#' @importFrom tuneR sine
#' @param chord a vector of frequencies for the chord
#' @param duration_sec total duration of the chord in seconds
#' @param velocity MIDI velocity, default = 100, max is 127
#' @returns a `Wave` object containing the synthesized chord
#' @examples
#' \dontrun{
#'   justmajor7th <- c(1, 5/4, 3/2, 7/4)
#'   wave <- chord_synth(256*justmajor7th, duration_sec = 10)
#'   tuneR::play(wave)
#' }
#'
chord_synth <- function(
  chord,
  duration_sec,
  velocity = 100
) {

  # initialize wave object
  chord_wave <- tuneR::silence(
    duration = duration_sec,
    samp.rate = SAMP_RATE,
    bit = BIT,
    pcm = PCM,
    xunit = "time"
  )

  for (note in chord) {
    chord_wave <- chord_wave + tuneR::sine(
      freq = note,
      duration = duration_sec,
      samp.rate = SAMP_RATE,
      bit = BIT,
      pcm = PCM,
      xunit = "time"
    )
  }

  # normalize to given velocity
  chord_wave <- tuneR::normalize(
    chord_wave,
    level = velocity / MAX_VELOCITY,
    unit = as.character(BIT),
    pcm = PCM,
    center = TRUE
  )
}

#' @title Render the Chords of a CPS
#' @name render_cps_chords
#' @description Make WAV files for all chords of a given CPS
#' @export render_cps_chords
#' @param scale_table the scale table for the CPS
#' @param output_directory chords will be rendered into this folder
#' @returns the full path to output_directory
#' @examples
#' \dontrun{
#'
#'   hexany_scale_table <- cps_scale_table(
#'     harmonics = c(1, 3, 5, 7),
#'     choose = 2,
#'     root_divisor = 15
#'   )
#'   render_cps_chords(hexany_scale_table, "~/Music/hexany_chords")
#'   hexany_paths <- list.files("~/Music/hexany_chords", pattern = "\\.wav$", full.names = TRUE)
#'   combine_wav_files(hexany_paths, "~/Music/hexany_combined.wav")
#'
#'   eikosany_scale_table <- cps_scale_table(
#'     harmonics = c(1, 3, 5, 7, 9, 11),
#'     choose = 3,
#'     root_divisor = 33
#'   )
#'   render_cps_chords(eikosany_scale_table, "~/Music/eikosany_chords")
#'   eikosany_paths <- list.files("~/Music/eikosany_chords", pattern = "\\.wav$", full.names = TRUE)
#'   combine_wav_files(eikosany_paths, "~/Music/eikosany_combined.wav")
#' }
#'
render_cps_chords <- function(scale_table, output_directory) {

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
    chord_WAVs(
      chord,
      keyboard_map,
      lowest_note = 60 - scale_degrees / 2,
      duration_sec = DURATION_SEC,
      output_directory = output_directory
    )
  }

   return(invisible(output_directory))
}

#' @title Combine WAV Files into a Single WAV File
#' @name combine_wav_files
#' @description Reads a list of WAV files and concatenates them in order into
#' a single output WAV file.
#' @export combine_wav_files
#' @importFrom tuneR readWave
#' @importFrom tuneR bind
#' @importFrom tuneR writeWave
#' @param wav_files character vector of paths to WAV files to combine, in the
#' order they should appear in the output.
#' @param output_file character, full path (including filename) for the
#' combined output WAV file.
#' @returns the full path to `output_file`, invisibly.
#' @examples
#' \dontrun{
#' wav_paths <- list.files("~/my_chords", pattern = "\\.wav$", full.names = TRUE)
#' combine_wav_files(wav_paths, "~/my_chords/combined.wav")
#' }
#'
combine_wav_files <- function(wav_files, output_file) {

  if (length(wav_files) == 0) {
    stop("wav_files must contain at least one file path.")
  }

  stopifnot(length(wav_files) > 0)

  # read first file to start accumulation
  combined <- tuneR::readWave(wav_files[[1]])

  # bind remaining files sequentially
  if (length(wav_files) > 1) {
    for (i in 2:length(wav_files)) {
      combined <- tuneR::bind(combined, tuneR::readWave(wav_files[[i]]))
    }
  }

  tuneR::writeWave(combined, output_file)

  return(invisible(output_file))

}
