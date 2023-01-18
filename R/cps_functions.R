# helper functions and constants

# convert MIDI note number to EDO frequency
.EDO_DEGREES = 12
.REF_FREQ = 440
.REF_NN = 69
.nn2freq <- function(note_number) {
  .REF_FREQ * 2 ^ ((note_number - .REF_NN) / .EDO_DEGREES)
}

.NN_MIN <- 0; .CENTS_MIN <- 0; .FREQ_MIN <- .nn2freq(.NN_MIN)
.NN_MAX <- 127; .CENTS_MAX <- 100 * .NN_MAX; .FREQ_MAX <- .nn2freq(.NN_MAX)
.NN_RANGE <- seq(.NN_MIN, .NN_MAX, 1)

.NN_MIDDLE_C <- 60; .CENTS_MIDDLE_C <- 100 * .NN_MIDDLE_C
.FREQ_MIDDLE_C <- .nn2freq(.NN_MIDDLE_C)

.NAMES_12EDO <- c(
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
.DEGREES_12EDO <- seq(0, 11)
.CENTS_12EDO <- 100 * .DEGREES_12EDO

# separator for notes (products)
.NOTE_SEP <- "x"

# separators for chords
..CHORD_SEP <- ":"
.SUBCHORD_SEP <- ":/"

.matrix2label <- function(matrix, separator) {
  label <- apply(matrix, MARGIN = 1, FUN = paste, collapse = separator)
  if (separator == .SUBCHORD_SEP) {
    label <- paste("/", label, sep = "")
  }
  return(label)
}

.label2matrix <- function(label, separator) {
  matrix(
    unlist(lapply(strsplit(label, separator), as.numeric)),
    byrow = TRUE,
    nrow = length(label)
  )
}

.label2harmonics <- function(label, separator) {
  unique(sort(unlist(lapply(strsplit(label, separator), as.numeric))))
}

.matrix2degree <- function(note_matrix, scale_table) {
  note_label <- .matrix2label(note_matrix, .NOTE_SEP)
  note_index <- data.table::data.table(note_name = note_label)
  degree_table <- scale_table[
    note_index,
    list(note_name, degree),
    on = "note_name"
  ]
  return(degree_table)
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

.cents2ratio <- function(cents) {
  return(2 ^ (cents / 1200))
}

.pitch_bend_offsets <- function(cents) {
  note_names <- .NAMES_12EDO
  index2name <- cents %/% 100
  offset_cents <- cents %% 100
  index2increment <- offset_cents > 50 & (index2name + 1) < 12
  index2name[index2increment] <- index2name[index2increment] + 1
  offset_cents[index2increment] <- offset_cents[index2increment] - 100
  key_12EDO <- note_names[index2name + 1]
  return(list(key_12EDO = key_12EDO, offset_cents = offset_cents))
}

#' @title Create Scale Table
#' @name create_scale_table
#' @description Creates a scale table from a combination product set definition
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom data.table ":="
#' @importFrom data.table ".I"
#' @importFrom fractional fractional
#' @importFrom utils combn
#' @importFrom utils globalVariables
#' @export create_scale_table
#' @param harmonics a vector of the harmonics to use - defaults to the first
#' six odd numbers, the harmonics that define the 1-3-5-7-9-11 Eikosany.
#' @param choose the number of harmonics to choose for each combination -
#' defaults to 3, the number of harmonics for each combination in the
#' Eikosany.
#' @return a `data.table` with ten columns:
#' \itemize{
#' \item `note_name`: the product of harmonics that defines the note (character)
#' \item `ratio`: the ratio that defines the note, as a number between 1 and
#' 2
#' \item `ratio_frac`: the ratio as a vulgar fraction (character)
#' \item `ratio_cents`: the ratio in cents (hundredths of a semitone)
#' \item `degree`: scale degree from zero to (number of notes) - 1
#' \item `key_12EDO`: note name for closest 12EDO note
#' \item `offset_cents`: offset in cents from `key_12EDO`
#' }
#' @details The Dirtywave M8
#' (https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20220621.pdf?v=1655861519,
#' page 24) can use arbitrary scales defined by offsets in cents from a 12EDO
#' note. For scales with 12 or fewer notes per octave, you can just define
#' the scale using `key_12EDO` and `offset_cents` from this table. For scales
#' with more than 12 notes per octave, you need to allocate multiple scales in
#' the M8.
#'
#' There may be other synthesizers that can be tuned this way, but the M8 is
#' the only one I have.
#'
#' @examples
#' \dontrun{
#'
#' # the defaults yield the 1-3-5-7-9-11 Eikosany
#' print(eikosany <- create_scale_table())
#'
#' # the 1-3-5-7 Hexany
#' hexany_harmonics <- c(1, 3, 5, 7)
#' hexany_choose = 2
#' print(hexany <- create_scale_table(hexany_harmonics, hexany_choose))
#'
#' # the 1-7-9-11-13 2)5 Dekany
#'
#' dekany_harmonics <- c(1, 7, 9, 11, 13)
#' dekany_choose <- 2
#' print(dekany <- create_scale_table(dekany_harmonics, dekany_choose))
#'
#' # We might want to print out sheet music for a conventional keyboard
#' # player, since the synthesizer is mapping MIDI note numbers to pitches.
#' # We assume at least a 37-key synthesizer with middle C on the left,
#' # so the largest CPS scale we can play is a 35-note "35-any", made from
#' # seven harmonics taken three at a time.
#' harmonics_35 <- c(1, 3, 5, 7, 9, 11, 13)
#' choose_35 <- 3
#' print(any_35 <- create_scale_table(harmonics_35, choose_35))
#'
#' }

create_scale_table <- function(harmonics = c(1, 3, 5, 7, 9, 11), choose = 3) {
  result_table <- t(combn(harmonics, choose))
  note_name <- .matrix2label(result_table, .NOTE_SEP)
  num_product <- apply(result_table, 1, prod)
  normalizer <- min(num_product)
  ratio <- .octave_reduce(num_product / normalizer)
  ratio_frac <- as.character(fractional::fractional(ratio))
  ratio_cents <- .ratio2cents(ratio)
  result_table <- data.table::data.table(
    note_name,
    ratio,
    ratio_frac,
    ratio_cents
  )
  data.table::setkey(result_table, ratio)
  result_table <- result_table[, "degree" := .I - 1]
  pitch_bend_offsets <- .pitch_bend_offsets(result_table$ratio_cents)
  result_table$key_12EDO <- pitch_bend_offsets$key_12EDO
  result_table$offset_cents <- pitch_bend_offsets$offset_cents
  return(result_table)
}

#' @title Create 12EDO Scale Table
#' @name create_12edo_scale_table
#' @description Creates a scale table for 12EDO
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom data.table ":="
#' @importFrom data.table ".I"
#' @importFrom fractional fractional
#' @importFrom utils combn
#' @importFrom utils globalVariables
#' @export create_12edo_scale_table
#' @return a `data.table` with ten columns:
#' \itemize{
#' \item `note_name`: the note name (character)
#' \item `ratio`: the ratio that defines the note, as a number between 1 and
#' 2
#' \item `ratio_frac`: the ratio as a vulgar fraction (character). The ratios
#' for 12EDO are irrational, so this is an approximation.
#' \item `ratio_cents`: the ratio in cents (hundredths of a semitone)
#' \item `degree`: scale degree from zero to (number of notes) - 1
#' \item `key_12EDO`: note name for nearest 12EDO note
#' \item `offset_cents`: offset in cents from `key_12EDO`
#' }
#' @examples
#' \dontrun{
#'
#' print(vanilla <- create_12edo_scale_table())
#'
#' }

create_12edo_scale_table <- function() {
  key_12EDO <- note_name <- .NAMES_12EDO
  degree <- .DEGREES_12EDO
  ratio_cents <- degree * 100
  ratio <- .cents2ratio(ratio_cents)
  ratio_frac <- as.character(fractional::fractional(ratio))
  offset <- vector(mode = "numeric", length = 12); offset <- offset - offset
  scale_table <- data.table::data.table(
    note_name,
    ratio,
    ratio_frac,
    ratio_cents,
    degree,
    key_12EDO,
    offset
  )
  data.table::setkey(scale_table, ratio)
  return(scale_table)
}

#' @title Create Interval Matrix
#' @name create_interval_matrix
#' @description Creates an interval matrix from a scale table
#' @importFrom fractional fractional
#' @export create_interval_matrix
#' @param scale_table a scale table from the `create_scale_table` function
#' @return an interval matrix
#' @examples
#' \dontrun{
#'
#' # the 1-3-5-7 Hexany
#' hexany_harmonics <- c(1, 3, 5, 7)
#' hexany_choose = 2
#' hexany <- create_scale_table(hexany_harmonics, hexany_choose)
#' print(hexany_interval_matrix <-create_interval_matrix(hexany))
#' }

create_interval_matrix <- function(scale_table) {
  fractional::fractional(outer(
    scale_table$ratio,
    scale_table$ratio,
    "/"
  ))
}

#' @title Create Chord Table
#' @name create_chord_table
#' @description Creates a chord table
#' @importFrom data.table data.table
#' @importFrom utils combn
#' @importFrom utils globalVariables
#' @export create_chord_table
#' @param scale_table the scale table to use for note number and name lookup
#' @param choose the number of harmonics to choose for each chord
#' @return a data.table with two columns:
#' \itemize{
#' \item `chord`: the chord expressed as colon-separated harmonics. A
#' subharmonic chord is prefixed with a "~".
#' \item `degrees`: the chord expressed as colon-separated scale degrees
#' }
#' @examples
#' \dontrun{
#'
#'
#' # compute the tetrads of the 1-3-5-7-9-11 Eikosany
#' eikosany <- create_scale_table()
#' print(eikosany_chords <- create_chord_table(eikosany, 4))
#' }

create_chord_table <- function(scale_table, choose) {
  harmonics <- .label2harmonics(scale_table$note_name, .NOTE_SEP)
  chords <- t(combn(harmonics, choose))
  others <- t(
    apply(chords, MARGIN = 1, FUN = function(x) setdiff(harmonics, x)
  ))

  # allocate result matrices
  harm_matrix <- subharm_matrix <- chords

  for (icol in 1:ncol(chords)) {

    # note as a column matrix
    col_matrix <- matrix(chords[, icol])

    # harmonic note matrix
    harm_note_matrix <- cbind(col_matrix, others)
    harm_note_matrix <- t(apply(harm_note_matrix, MARGIN = 1, FUN = sort))

    # harmonic note degree
    harm_note_degree <- .matrix2degree(harm_note_matrix, scale_table)
    harm_matrix[, icol] <- harm_note_degree$degree

    # subharmonic note matrix
    subharm_note_matrix <- t(apply(
      harm_note_matrix, MARGIN = 1, FUN = function(x) setdiff(harmonics, x)
    ))
    subharm_note_matrix <- t(apply(subharm_note_matrix, MARGIN = 1, FUN = sort))

    # subharmonic note degree
    subharm_note_degree <- .matrix2degree(subharm_note_matrix, scale_table)
    subharm_matrix[, icol] <- subharm_note_degree$degree

  }

  harm_matrix <- t(apply(harm_matrix, MARGIN = 1, FUN = sort))
  subharm_matrix <- t(apply(subharm_matrix, MARGIN = 1, FUN = sort))

  # make labels
  chord_label <- .matrix2label(chords, ..CHORD_SEP)
  subchord_label <- .matrix2label(chords, .SUBCHORD_SEP)
  harm_label <- .matrix2label(harm_matrix, ..CHORD_SEP)
  subharm_label <- .matrix2label(subharm_matrix, ..CHORD_SEP)

  return(data.table::data.table(
    chord = c(chord_label, subchord_label),
    degrees = c(harm_label, subharm_label)
  ))
}

#' @title Create Keyboard Map
#' @name create_keyboard_map
#' @description Creates a keyboard map
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom data.table ":="
#' @export create_keyboard_map
#' @param scale_table an output of `create_scale_table`
#' @param middle_c_octave octave number for middle C. There are varying
#' conventions for the octave number for middle C. The default for this
#' function is 4, but other software can use 3 or even some other number
#' @return the keyboard map. This is a data.table with eight columns:
#' \itemize{
#' \item `note_number`: the MIDI note number from `.NN_MIN` through `.NN_MAX`
#' \item `note_name`: the note name
#' \item `ratio_frac`: ratio for the note as a vulgar fraction
#' \item `octave`: the octave number of the note
#' \item `degree`: the scale degree of the note
#' \item `freq`: the frequency in Hz
#' \item `cents`: cents above default MIDI note `.NN_MIN`, which has frequency
#' `.FREQ_MIN`.
#' \item `name_12edo`: note name of the key in 12EDO
#' }
#' @details The function is currently hard-coded to compute the map so that
#' middle C with frequency `.FREQ_MIDDLE_C`is mapped to MIDI note number
#' `.NN_MIDDLE_C` and scale degree 0. With the current constants this is the
#' same as it is on 12EDO with A440 on note 69. This note is 6000 cents above
#' MIDI note number 0.
#' @examples
#' \dontrun{
#'
#' hexany_harmonics <- c(1, 3, 5, 7)
#' hexany_choose = 2
#' hexany <- create_scale_table(hexany_harmonics, hexany_choose)
#' print(hexany_keyboard_map <- create_keyboard_map(hexany))
#' dekany_harmonics <- c(1, 7, 9, 11, 13)
#' dekany_choose <- 2
#' dekany <- create_scale_table(dekany_harmonics, dekany_choose)
#' print(dekany_keyboard_map <- create_keyboard_map(dekany))
#' print(
#'   vanilla_keyboard_map <- create_keyboard_map(create_12edo_scale_table())
#' )
#' print(
#'   eikosany_keyboard_map_c3 <-
#'     create_keyboard_map(create_scale_table(), middle_c_octave = 3)
#' )
#' }

create_keyboard_map <- function(scale_table, middle_c_octave = 4) {

  # create note number vector
  note_number <- .NN_RANGE
  note_numbers <- length(note_number)

  # create indices
  degrees <- nrow(scale_table)
  octave <- (note_number - .NN_MIDDLE_C) %/% degrees
  degree <- (note_number - .NN_MIDDLE_C) %% degrees
  degree_12EDO <- (note_number - .NN_MIDDLE_C) %% 12

  # note names
  note_name <- name_12edo <- ratio_frac <-
    vector(mode = "character", length = note_numbers)
  note_name[note_number + 1] <- scale_table$note_name[degree + 1]
  ratio_frac[note_number + 1] <- scale_table$ratio_frac[degree + 1]
  name_12edo[note_number + 1] <- .NAMES_12EDO[degree_12EDO + 1]

  # cents and frequencies
  cents <-
    scale_table$ratio_cents[degree + 1] + octave * 1200 + .CENTS_MIDDLE_C
  freq <- .cents2ratio(cents) * .FREQ_MIN

  # fix octave number
  octave <- octave + middle_c_octave

  # replace out of range values
  index_low <- cents < .CENTS_MIN
  cents[index_low] <- .CENTS_MIN
  freq[index_low] <- .FREQ_MIN
  index_high <- cents > .CENTS_MAX
  cents[index_high] <- .CENTS_MAX
  freq[index_high] <- .FREQ_MAX

  # build and return the map
  keyboard_map <- data.table::data.table(
    note_number,
    note_name,
    ratio_frac,
    octave,
    degree,
    freq,
    cents,
    name_12edo
  )
  data.table::setkey(keyboard_map, note_number)

  return(keyboard_map)

}

utils::globalVariables(c(
  "cents_12edo",
  "degree",
  "freq_12edo",
  "note_name",
  "note_number",
  "product"
))
