# helper functions

.collapse_product <- function(x) {
  paste(x, collapse = "x")
}

.collapse_colon <- function(x) {
  paste(x, collapse = ":")
}

.octave_reduce <- function(x) {
  w <- as.numeric(x)

  ix <- (w > 2)
  while (any(ix)) {
    w[ix] <- w[ix] / 2
    ix <- (w > 2)
  }

  ix <- (w < 1)
  while (any(ix)) {
    w[ix] <- w[ix] * 2
    ix <- (w < 1)
  }

  return(w)
}

.ratio2cents <- function(ratio) {
  return(log2(ratio) * 1200)
}

#' @title Create Scale Table
#' @name scale_table
#' @description Creates a scale table from a combination product set definition
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom data.table ":="
#' @importFrom data.table ".I"
#' @importFrom fractional fractional
#' @importFrom utils combn
#' @importFrom utils globalVariables
#' @export scale_table
#' @param harmonics a vector of the harmonics to use - defaults to the first
#' six odd numbers, the harmonics that define the 1-3-5-7-9-11 Eikosany.
#' @param choose the number of harmonics to choose for each combination -
#' defaults to 3, the number of harmonics for each combination in the
#' Eikosany.
#' @return a `data.table` with ten columns:
#' \itemize{
#' \item `product`: the product of harmonics that defines the note (character)
#' \item `ratio`: the ratio that defines the note, as a number between 1 and
#' 2
#' \item `ratio_frac`: the ratio as a vulgar fraction (character)
#' \item `ratio_cents`: the ratio in cents (hundredths of a semitone)
#' \item `degree`: scale degree from zero to (number of notes) - 1
#' }
#' @examples
#' \dontrun{
#'
#' # the defaults yield the 1-3-5-7-9-11 Eikosany
#' print(eikosany <- scale_table())
#'
#' # the 1-7-9-11-13 Dekany
#' dekany_harmonics <- c(1, 7, 9, 11, 13)
#' dekany_choose <- 2
#' print(dekany_1_7_9_11_13 <- scale_table(dekany_harmonics, dekany_choose))
#'
#' # We might want to print out sheet music for a conventional keyboard
#' # player, since the synthesizer is mapping MIDI note numbers to pitches.
#' # We assume at least a 37-key synthesizer with middle C on the left,
#' # so the largest CPS scale we can play is a 35-note "35-any", made from
#' # seven harmonics taken three at a time.
#' harmonics_35 <- c(1, 3, 5, 7, 9, 11, 13)
#' choose_35 <- 3
#' print(any_35 <- scale_table(harmonics_35, choose_35))
#'
#' }

scale_table <- function(harmonics = c(1, 3, 5, 7, 9, 11), choose = 3) {
  result_table <- combn(harmonics, choose)
  product <- apply(result_table, 2, .collapse_product)
  num_product <- apply(result_table, 2, prod)
  normalizer <- min(num_product)
  ratio <- .octave_reduce(num_product / normalizer)
  ratio_frac <- as.character(fractional::fractional(ratio))
  ratio_cents <- .ratio2cents(ratio)
  result_table <- data.table::data.table(
    product,
    ratio,
    ratio_frac,
    ratio_cents
  )
  data.table::setkey(result_table, ratio)
  result_table <- result_table[, "degree" := .I - 1]
  return(result_table)
}

#' @title Create Interval Matrix
#' @name interval_matrix
#' @description Creates an interval matrix from a scale table
#' @importFrom fractional fractional
#' @export interval_matrix
#' @param scale_table a scale table from the `scale_table` function
#' @return an interval matrix
#' @examples
#' \dontrun{
#'
#' # the defaults yield the 1-3-5-7-9-11 Eikosany
#' print(eikosany_interval_matrix <-interval_matrix(scale_table()))
#' }


interval_matrix <- function(scale_table) {
  fractional::fractional(outer(
    scale_table$ratio,
    scale_table$ratio,
    "/"
  ))
}

#' @title Create Chord Table
#' @name chord_table
#' @description Creates a chord table
#' @importFrom data.table data.table
#' @importFrom utils combn
#' @importFrom utils globalVariables
#' @export chord_table
#' @param scale_table the scale table to use for note number and name lookup
#' @param harmonics a vector of the harmonics to use - defaults to the first
#' six odd numbers, the harmonics that define the 1-3-5-7-9-11 eikosany.
#' @param choose the number of harmonics to choose for each chord -
#' defaults to 4, to compute tetrads for the eikosany.
#' @return a data.table with five columns:
#' \itemize{
#' \item `chord_label`: the chord expressed as colon-separated harmonics
#' \item `harmonic_scale_degrees`: the harmonic chord expressed as
#' colon-separated scale degrees
#' \item `subharmonic_scale_degrees`: the subharmonic chord expressed as
#' colon-separated scale degrees
#' }
#' @examples
#' \dontrun{
#'
#' # the defaults yield the 1-3-5-7-9-11 Eikosany
#' eikosany_scale <- scale_table()[["scale_table"]]
#' print(eikosany_scale)
#'
#' # the defaults yield the tetrads of the 1-3-5-7-9-11 Eikosany
#' eikosany_chords <- chord_table(eikosany_scale)
#' print(eikosany_chords)
#' }

chord_table <- function(
  scale_table,
  harmonics = c(1, 3, 5, 7, 9, 11),
  choose = 4
) {
  chords <- combn(harmonics, choose)

  # make the chord labels
  chord_label <- apply(chords, 2, .collapse_colon)
  harmonic_note_numbers <- harmonic_note_names <-
    subharmonic_note_numbers <- subharmonic_note_names <- c()

  for (it in 1:length(chord_label)) {

    # convert the chord label to note number and note name chords
    result_list <-
      .convert_chords(chord_label[it], harmonics, scale_table
    )
    harmonic_note_numbers <-
      c(harmonic_note_numbers, result_list[["harmonic_note_numbers"]])
    harmonic_note_names <-
      c(harmonic_note_names, result_list[["harmonic_note_names"]])
    subharmonic_note_numbers <-
      c(subharmonic_note_numbers, result_list[["subharmonic_note_numbers"]])
    subharmonic_note_names <-
      c(subharmonic_note_names, result_list[["subharmonic_note_names"]])
  }

  return(data.table::data.table(
    chord_label,
    harmonic_note_numbers,
    harmonic_note_names,
    subharmonic_note_numbers,
    subharmonic_note_names
  ))

}
.note_name_table <- function() {
  min_note_number <- 0
  max_note_number <- 127
  note_name_table <- data.table::data.table(
    midi_note_number = min_note_number:max_note_number
  )
  note_names <- c(
    "C ",
    "C#",
    "D ",
    "D#",
    "E ",
    "F ",
    "F#",
    "G ",
    "G#",
    "A ",
    "A#",
    "B "
  )
  note_name_table <- note_name_table[, list(
    midi_note_number,
    note_name = paste(
      note_names[midi_note_number %% 12 + 1],
      midi_note_number %/% 12 - 1,
      sep = " "
    )
  )]

  return(note_name_table)
}

.pitch_bend_offsets <- function(cents) {
  note_names <- c(
    "C ",
    "C#",
    "D ",
    "D#",
    "E ",
    "F ",
    "F#",
    "G ",
    "G#",
    "A ",
    "A#",
    "B ",
    "C'"
  )

  base <- cents %/% 100
  offset_cents <- cents %% 100
  index <- offset_cents > 50
  base[index] <- base[index] + 1
  offset_cents[index] <- offset_cents[index] - 100
  base_12EDO <- note_names[base + 1]
  return(list(base_12EDO = base_12EDO, offset_cents = offset_cents))
}

.convert_chords <- function(chord_label, harmonics, scale_table) {

  # unpack the chord label
  chord <- as.numeric(unlist(strsplit(chord_label, ":")))

  # harmonics not in the chord
  others <- setdiff(harmonics, chord)
  harmonic_note_numbers <- subharmonic_note_numbers <- c()


  for (i in chord) {

    # make a note_label for the note
    harmonic_note <- .collapse_product(sort(union(i, others)))

    # look up its note number and collect
    harmonic_note_numbers <- c(
      harmonic_note_numbers,
      as.numeric(scale_table[
        note_label == harmonic_note, list(midi_note_number)
      ])
    )

    # make a note_label for the note
    subharmonic_note <- .collapse_product(sort(setdiff(chord, i)))

    # look up its note number and collect
    subharmonic_note_numbers <- c(
      subharmonic_note_numbers,
      as.numeric(scale_table[
        note_label == subharmonic_note, list(midi_note_number)
      ])
    )
  }

  harmonic_note_names <- subharmonic_note_names <- c()

  harmonic_note_numbers <- sort(harmonic_note_numbers)
  for (hnn in harmonic_note_numbers) {

    # look up note name and collect
    harmonic_note_names <- c(
      harmonic_note_names,
      as.character(scale_table[midi_note_number == hnn, list(note_name)])
    )
  }

  subharmonic_note_numbers <- sort(subharmonic_note_numbers)
  for (shnn in subharmonic_note_numbers) {

    # look up note name and collect
    subharmonic_note_names <- c(
      subharmonic_note_names,
      as.character(scale_table[midi_note_number == shnn, list(note_name)])
    )
  }

  # create return list
  return(list(
    harmonic_note_numbers = .collapse_colon(harmonic_note_numbers),
    harmonic_note_names = .collapse_colon(harmonic_note_names),
    subharmonic_note_numbers = .collapse_colon(subharmonic_note_numbers),
    subharmonic_note_names = .collapse_colon(subharmonic_note_names)
  ))
}

utils::globalVariables(c(
  "base_12EDO",
  "note_label",
  "midi_note_number",
  "note_name",
  "offset_cents"
))
