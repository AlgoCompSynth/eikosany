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

  # compute pitch bend offsets
  index2name <- result_table$ratio_cents %/% 100
  offset_cents <- result_table$ratio_cents %% 100
  index2increment <- offset_cents > 50 & (index2name + 1) < 12
  index2name[index2increment] <- index2name[index2increment] + 1
  offset_cents[index2increment] <- offset_cents[index2increment] - 100
  result_table$key_12EDO <- .NAMES_12EDO[index2name + 1]
  result_table$offset_cents <- offset_cents

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

#' @title Create Interval Table
#' @name create_interval_table
#' @description Creates an interval table from a scale table
#' @importFrom fractional fractional
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @export create_interval_table
#' @param scale_table a scale table from `create_scale_table`
#' @return an interval table. This is a data.table with seven columns
#' \itemize{
#' \item `from` name of "from" note
#' \item `from_degree` scale degree of "from" note
#' \item `to` name of "to" note
#' \item `to_degree` scale degree of "to" note
#' \item `ratio` interval as a number
#' \item `ratio_frac` interval as a vulgar fraction (character)
#' \item `ratio_cents` interval in cents
#' }
#' @examples
#' \dontrun{
#'
#' # default is the 1-3-5-7-9-11 Eikosany
#' eikosany <- create_scale_table()
#' print(eikosany_interval_table <-create_interval_table(eikosany))
#'
#' }

create_interval_table <- function(scale_table) {

  # get dimensions
  scale_degrees <- length(scale_table$degree)
  out_rows <- scale_degrees * (scale_degrees - 1) / 2
  # allocate output vectors
  from_name <- to_name <- vector(mode = "character", length = out_rows)
  from_degree <- to_degree <- vector(mode = "integer", length = out_rows)
  ratio <- vector(mode = "numeric", length = out_rows)

  out_ix <- 0
  for (ix_from in 1:(scale_degrees - 1)) {
    for (ix_to in (ix_from + 1):scale_degrees) {

      out_ix <- out_ix + 1
      ratio[out_ix] <-
        scale_table$ratio[ix_to] / scale_table$ratio[ix_from]
      from_name[out_ix] <- scale_table$note_name[ix_from]
      to_name[out_ix] <- scale_table$note_name[ix_to]
      from_degree[out_ix] <- scale_table$degree[ix_from]
      to_degree[out_ix] <- scale_table$degree[ix_to]

    }
  }

  ratio_frac <- as.character(fractional::fractional(ratio))
  ratio_cents <- .ratio2cents(ratio)

  result <- data.table::data.table(
    from_name,
    from_degree,
    to_name,
    to_degree,
    ratio,
    ratio_frac,
    ratio_cents
  )
  data.table::setkey(result, ratio)
  return(result)
}

#' @title Create Chord Table
#' @name create_chord_table
#' @description Creates a chord table for a combination product set scale
#' based on an *even* number of harmonic factors.
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom utils combn
#' @importFrom utils globalVariables
#' @export create_chord_table
#' @param scale_table a scale table based on an *even* number of harmonic
#' factors. It will abort via
#'
#'   `stop("number of harmonic factors must be even!")`
#'
#' if it receives one with an odd number.
#' @return a data.table with four columns:
#' \itemize{
#' \item `chord`: the chord expressed as colon-separated harmonics. A
#' subharmonic chord is prefixed with a "~".
#' \item `degrees`: the chord expressed as colon-separated scale degrees
#' \item `chord_index`: the row number of the chord in the combination output
#' \item `is_subharm`: zero if it's harmonic, one if it's subharmonic.
#' }
#' The resulting data.table is sorted into harmonic-subharmonic pairs using
#' `data.table::setkey.`
#' @details The algorithm used only works for a combination product set
#' built from an *even* number of harmonic factors, so it aborts if it
#' receives one with an odd number.
#'
#' In the following, the symbol `n)m` is Erv Wilson's notation for the
#' number of combinations of `m` items taken `n` at a time. `n_harmonics`
#' is the number of harmonic factors, the resulting chords will have
#' `choose <- n_harmonics / 2 + 1` notes. There will be
#' `choose)n_harmonics` "harmonic" chords and `choose)n_harmonics`
#' "sub-harmonic" chords. T
#'
#' @examples
#' \dontrun{
#'
#' # compute the tetrads of the 1-3-5-7-9-11 Eikosany
#' eikosany <- create_scale_table()
#' print(eikosany_chords <- create_chord_table(eikosany))
#'
#' # compute the pentads of the 1-3-5-7-9-11-13-15 Hebdomekontany
#' hebdomekontany <- create_scale_table(
#'   harmonics = c(1, 3, 5, 7, 9, 11, 13, 15), choose = 4
#' )
#' print(hebdomekontany_chords <- create_chord_table(hebdomekontany))
#' }

create_chord_table <- function(scale_table) {
  harmonics <- .label2harmonics(scale_table$note_name, .NOTE_SEP)
  n_harmonics <- length(harmonics)
  if (n_harmonics %% 2 == 1) {
    stop("number of harmonic factors must be even!")
  } else {
    choose <- n_harmonics / 2 + 1
  }
  chords <- t(combn(harmonics, choose))
  num_chords <- nrow(chords)
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

  # make table
  result_table <- data.table::data.table(
    chord = c(chord_label, subchord_label),
    degrees = c(harm_label, subharm_label)
  )
  result_table$chord_index <- c(seq(1, num_chords), seq(1, num_chords))
  result_table$is_subharm <- 0
  result_table$is_subharm[grep("/", result_table$chord)] <- 1
  data.table::setkey(result_table, chord_index, is_subharm)
  return(result_table)
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
#' \item `key_name`: note name of the key in 12EDO. This is the key you'd
#' normally press to play this note number
#' \item `key_octave`: the octave the key normally plays
#' \item `note_name`: the note name from the scale table
#' \item `ratio_frac`: ratio for the note as a vulgar fraction
#' \item `degree`: the scale degree of the note
#' \item `octave`: the octave number of the note
#' \item `freq`: the frequency in Hz
#' \item `cents`: cents above default MIDI note `.NN_MIN`, which has frequency
#' `.FREQ_MIN`.
#' \item `ref_keyname`: some synthesizers, including the Korg Minilogue XD,
#' let you retune a key as an offset in cents from another reference key.
#' This column is the name of that reference key.
#' \item `ref_octave`: the octave number of the reference key
#' \item `ref_offset`: the offset in cents from the reference key
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
  degrees_12edo <- 12
  octave <- (note_number - .NN_MIDDLE_C) %/% degrees
  key_octave <- (note_number - .NN_MIDDLE_C) %/% degrees_12edo
  degree <- (note_number - .NN_MIDDLE_C) %% degrees
  degree_12EDO <- (note_number - .NN_MIDDLE_C) %% degrees_12edo

  # note names
  note_name <- key_name <- ratio_frac <-
    vector(mode = "character", length = note_numbers)
  note_name[note_number + 1] <- scale_table$note_name[degree + 1]
  ratio_frac[note_number + 1] <- scale_table$ratio_frac[degree + 1]
  key_name[note_number + 1] <- .NAMES_12EDO[degree_12EDO + 1]

  # cents and frequencies
  cents <-
    scale_table$ratio_cents[degree + 1] + octave * 1200 + .CENTS_MIDDLE_C
  freq <- .cents2ratio(cents) * .FREQ_MIN

  # reference keys and offsets
  rcents <- round(cents, 0) # round for printing / offset calculations
  ref_semitones <- rcents %/% 100
  ref_offsets <- rcents %% 100
  ref_octave <- ref_semitones %/% degrees_12edo
  ref_degree <- ref_semitones %% degrees_12edo

  index2increment <- ref_offsets > 50
  ref_offsets[index2increment] <- ref_offsets[index2increment] - 100
  ref_degree[index2increment] <- ref_degree[index2increment] + 1
  index2overflow <- ref_degree == degrees_12edo
  ref_octave[index2overflow] <- ref_octave[index2overflow] + 1
  ref_degree[index2overflow] <- 0
  ref_keyname <- .NAMES_12EDO[ref_degree]

  # fix octave numbers
  octave <- octave + middle_c_octave
  key_octave <- key_octave + middle_c_octave

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
    key_name,
    key_octave,
    note_name,
    ratio_frac,
    degree,
    octave,
    freq,
    cents,
    ref_keyname,
    ref_octave,
    ref_offsets
  )
  data.table::setkey(keyboard_map, note_number)

  return(keyboard_map)

}

utils::globalVariables(c(
  "cents_12edo",
  "chord_index",
  "degree",
  "freq_12edo",
  "is_subharm",
  "note_name",
  "note_number",
  "product"
))
