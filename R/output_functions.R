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
      duration_sec = 4,
      velocity = 100,
      sample_rate_hz = 48000,
      bit_width = 24
    )

    # make file name -
    file_name <- sprintf(
      "%s-%s.wav",
      signal,
      chord_label
    )
    file_path <- paste0(output_directory, "/", file_name)

    # and write it!
    tuneR::writeWave(wave_object, file_path)

    root_index <- root_index + 1
  }

  return(output_directory)

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
#' @param duration_sec total duration of the chord in seconds, default = 1
#' @param velocity MIDI velocity, default = 100, max is 127
#' @param sample_rate_hz sample rate in hz, default = 48000
#' @param bit_width bit width of samples, default = 24
#' @param attack_sec ADSR attack time in seconds - linear ramp from silence
#' to peak amplitude, default = 0
#' @param decay_sec ADSR decay time in seconds - linear ramp from peak
#' amplitude down to `sustain_level`, default = 0
#' @param sustain_level ADSR sustain amplitude level as a fraction of peak,
#' between 0 and 1, default = 1
#' @param release_sec ADSR release time in seconds - linear ramp from
#' `sustain_level` to silence, default = 0
#' @returns a `Wave` object containing the synthesized chord
#' @examples
#' \dontrun{
#' justmajor7th <- c(1, 5/4, 3/2, 7/4)
#' wave <- chord_synth(256*justmajor7th, duration_sec = 10)
#' tuneR::play(wave)
#'
#' # with ADSR envelope
#' wave <- chord_synth(
#'   256 * justmajor7th,
#'   duration_sec = 4,
#'   attack_sec = 0.1,
#'   decay_sec = 0.2,
#'   sustain_level = 0.7,
#'   release_sec = 0.5
#' )
#' tuneR::play(wave)
#' }
#'
chord_synth <- function(
  chord,
  signal = "tria",
  duration_sec = 1,
  velocity = 100,
  sample_rate_hz = 48000,
  bit_width = 24,
  attack_sec = 0,
  decay_sec = 0,
  sustain_level = 1,
  release_sec = 0
) {

  # detonate if bad bit width
  legal_bit_widths <- c(8, 16, 24, 32, 64)
  if (!(bit_width %in% legal_bit_widths)) {
    stop(paste0("bit_width", bit_width, "not in", legal_bit_widths))
  }

  # validate envelope parameters
  if (attack_sec + decay_sec + release_sec > duration_sec) {
    stop("attack_sec + decay_sec + release_sec must not exceed duration_sec")
  }
  if (sustain_level < 0 || sustain_level > 1) {
    stop("sustain_level must be between 0 and 1")
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

  # build and apply ADSR envelope
  n_samples <- length(sample_vector)
  n_attack  <- round(attack_sec  * sample_rate_hz)
  n_decay   <- round(decay_sec   * sample_rate_hz)
  n_release <- round(release_sec * sample_rate_hz)
  n_sustain <- n_samples - n_attack - n_decay - n_release

  envelope <- c(
    seq(0,             1,             length.out = n_attack),
    seq(1,             sustain_level, length.out = n_decay),
    rep(sustain_level,                n_sustain),
    seq(sustain_level, 0,             length.out = n_release)
  )
  sample_vector <- sample_vector * envelope

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
      paste0(home_folder, "/chord_", chord_labels[i])
    chord_WAVs(
      chord,
      keyboard_map,
      lowest_note = 60,
      highest_note = 60 + 2 * scale_degrees,
      output_directory = folder_name
    )
  }

  return(home_folder)
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

utils::globalVariables(c(
  "highest_note",
  "freq"
))
