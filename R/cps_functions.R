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
  "C",
  "C#",
  "D",
  "D#",
  "E",
  "F",
  "F#",
  "G",
  "G#",
  "A",
  "A#",
  "B"
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

.label2prod <- function(label, separator) {
  unlist(lapply(lapply(strsplit(label, "x"), as.numeric), prod))

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

.period_reduce <- function(x, period) {
  w <- as.numeric(x)

  ix <- (w > period)
  while (any(ix)) {
    w[ix] <- w[ix] / period
    ix <- (w > period)
  }

  ix <- (w < 1)
  while (any(ix)) {
    w[ix] <- w[ix] * period
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

.cps_label <- function(harmonics = c(1, 3, 5, 7, 9, 11), choose = 3) {
  return(.matrix2label(t(combn(harmonics, choose)), .NOTE_SEP))
}

.ratio_table <- function(label, period = 2) {
  num_product <- .label2prod(label, .NOTE_SEP)
  normalizer <- min(num_product)
  ratio <- .period_reduce(num_product / normalizer, period)
  ratio_frac <- as.character(fractional::fractional(ratio))
  ratio_cents <- .ratio2cents(ratio)
  result_table <- data.table::data.table(
    note_name = label,
    ratio,
    ratio_frac,
    ratio_cents
  )
  data.table::setkey(result_table, ratio)
  last_row <- data.table::data.table(
    note_name = paste(result_table$note_name[1], "'", sep = ""),
    ratio = period,
    ratio_frac = as.character(fractional::fractional(period)),
    ratio_cents = .ratio2cents(period)
  )
  result_table <- data.table::rbindlist(list(result_table, last_row))
  result_table <- result_table[, `:=`(
    interval_cents = ratio_cents - data.table::shift(ratio_cents),
    degree = (.I - 1)
  )]
  return(result_table)
}

.compute_pitch_bend_offsets <- function(scale_table) {
  index2name <- scale_table$ratio_cents %/% 100 + 1
  index2name[index2name > 12] <- 12
  offset_cents <- scale_table$ratio_cents - 100 * (index2name - 1)
  index2increment <- offset_cents > 50 & index2name < 12
  index2name[index2increment] <- index2name[index2increment] + 1
  offset_cents[index2increment] <- offset_cents[index2increment] - 100
  temp <- scale_table
  temp$key_12EDO <- .NAMES_12EDO[index2name]
  temp$offset_cents <- offset_cents
  return(temp)
}

.drop_last_row <- function(scale_table) {
  return(scale_table[degree < nrow(scale_table) - 1])
}


#' @title Create Product Set Scale Table
#' @name ps_scale_table
#' @description Creates a scale table from a product set definition
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom data.table ":="
#' @importFrom data.table ".I"
#' @importFrom data.table "shift"
#' @importFrom fractional fractional
#' @importFrom utils combn
#' @importFrom utils globalVariables
#' @export ps_scale_table
#' @param ps_def the product set scale definition. This is a character
#' vector of products. Each product is a set of any number of integers
#' separated by a lower-case "x". For example, the `ps_def` of the 1-3-5-7
#' Hexany is
#'
#'   `c("1x3", "1x5", "1x7", "3x5", "3x7", "5x7")`
#'
#' The default is the `ps_def` for the 1-3-5-7-9-11 Eikosany.
#' @returns a `data.table` with eight columns:
#' \itemize{
#' \item `note_name`: the given product set definition, re-ordered by the
#' degrees of the resulting scale (character)
#' \item `ratio`: the ratio that defines the note, as a number between 1 and
#' 2
#' \item `ratio_frac`: the ratio as a vulgar fraction (character)
#' \item `ratio_cents`: the ratio in cents (hundredths of a semitone)
#' \item `interval_cents`: interval between this note and the previous note
#' \item `degree`: scale degree from zero to (number of notes) - 1
#' \item `key_12EDO`: note name for closest 12EDO note. Note that because
#' most synthesizers do not allow returning relative to the C in the next
#' octave up, the offset will be above B for such a note.
#' \item `offset_cents`: offset in cents from `key_12EDO`
#' }
#' @examples
#'
#' # the default yields the 1-3-5-7-9-11 Eikosany
#' print(eikosany <- ps_scale_table())
#'
#' # Kraig Grady's Eikosany as two complementary extended Dekanies
#' print(grady_a <- ps_scale_table(c(
#'   "1x3x11",
#'   "1x9",
#'   "3x9x11",
#'   "1x7x11",
#'   "1x3x7",
#'   "7x9x11",
#'   "3x7x9",
#'   "1x9x11",
#'   "1x3x9",
#'   "1x7",
#'   "3x7x11",
#'   "1x7x9"
#' )))
#' print(grady_b <- ps_scale_table(c(
#'   "3x5x11",
#'   "1x5x9",
#'   "3x5x9x11",
#'   "5x7x11",
#'   "3x5x7",
#'   "1x5x11",
#'   "1x3x5",
#'   "5x9x11",
#'   "3x5x9",
#'   "1x5x7",
#'   "3x5x7x11",
#'   "5x7x9"
#' )))

ps_scale_table <- function(ps_def = c(
  "1x3x5",
  "5x9x11",
  "1x7x9",
  "1x3x11",
  "3x5x9",
  "1x5x7",
  "3x9x11",
  "1x7x11",
  "5x7x9",
  "3x5x11",
  "1x3x7",
  "7x9x11",
  "1x5x9",
  "3x7x9",
  "5x7x11",
  "1x9x11",
  "3x5x7",
  "1x3x9",
  "1x5x11",
  "3x7x11"
)) {
  scale_table <- .ratio_table(ps_def, period = 2)

  # compute pitch bend offsets
  scale_table <- .compute_pitch_bend_offsets(scale_table)
  return(scale_table)
}

#' @title Create Combination Product Set Scale Table
#' @name cps_scale_table
#' @description Creates a scale table from a combination product set definition
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom data.table ":="
#' @importFrom data.table ".I"
#' @importFrom data.table "shift"
#' @importFrom fractional fractional
#' @importFrom utils combn
#' @importFrom utils globalVariables
#' @export cps_scale_table
#' @param harmonics a vector of the harmonics to use - defaults to the first
#' six odd numbers, the harmonics that define the 1-3-5-7-9-11 Eikosany.
#' @param choose the number of harmonics to choose for each combination -
#' defaults to 3, the number of harmonics for each combination in the
#' Eikosany.
#' @return a `data.table` with eight columns:
#' \itemize{
#' \item `note_name`: the product of harmonics that defines the note (character)
#' \item `ratio`: the ratio that defines the note, as a number between 1 and
#' 2
#' \item `ratio_frac`: the ratio as a vulgar fraction (character)
#' \item `ratio_cents`: the ratio in cents (hundredths of a semitone)
#' \item `interval_cents`: interval between this note and the previous note
#' \item `degree`: scale degree from zero to (number of notes) - 1
#' \item `key_12EDO`: note name for closest 12EDO note. Note that because
#' most synthesizers do not allow returning relative to the C in the next
#' octave up, the offset will be above B for such a note.
#' \item `offset_cents`: offset in cents from `key_12EDO`
#' }
#' @examples
#'
#' # the defaults yield the 1-3-5-7-9-11 Eikosany
#' print(eikosany <- cps_scale_table())
#'
#' # the 1-3-5-7 Hexany
#' hexany_harmonics <- c(1, 3, 5, 7)
#' hexany_choose <- 2
#' print(hexany <- cps_scale_table(hexany_harmonics, hexany_choose))
#'
#' # the 1-7-9-11-13 2)5 Dekany
#'
#' dekany_harmonics <- c(1, 7, 9, 11, 13)
#' dekany_choose <- 2
#' print(dekany <- cps_scale_table(dekany_harmonics, dekany_choose))
#'
#' # We might want to print out sheet music for a conventional keyboard
#' # player, since the synthesizer is mapping MIDI note numbers to pitches.
#' # We assume at least a 37-key synthesizer with middle C on the left,
#' # so the largest CPS scale we can play is a 35-note "35-any", made from
#' # seven harmonics taken three at a time.
#' harmonics_35 <- c(1, 3, 5, 7, 9, 11, 13)
#' choose_35 <- 3
#' print(any_35 <- cps_scale_table(harmonics_35, choose_35))

cps_scale_table <-
  function(harmonics = c(1, 3, 5, 7, 9, 11), choose = 3) {
  label <- .cps_label(harmonics, choose)
  return(ps_scale_table(ps_def = label))
}

#' @title Create Equal-Tempered Scale Table
#' @name et_scale_table
#' @description Creates a scale table for equal divisions of a
#' specified period.
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom data.table ":="
#' @importFrom data.table ".I"
#' @importFrom data.table "shift"
#' @importFrom fractional fractional
#' @importFrom utils combn
#' @importFrom utils globalVariables
#' @export et_scale_table
#' @param note_names a character vector with the names of the notes in the
#' scale. The default is the names of the standard 12 equal divisions of the
#' octave.
#' @param period The period - default is 2, for an octave
#' @return a `data.table` with eight columns:
#' \itemize{
#' \item `note_name`: the note name (character)
#' \item `ratio`: the ratio that defines the note, as a number between 1 and
#' `period`
#' \item `ratio_frac`: the ratio as a vulgar fraction (character). The ratios
#' for most EDOs are irrational, so this is an approximation.
#' \item `ratio_cents`: the ratio in cents (hundredths of a semitone)
#' \item `interval_cents`: interval between this note and the previous note
#' \item `degree`: scale degree from zero to (number of notes) - 1
#' \item `key_12EDO`: note name for closest 12EDO note. Note that because
#' most synthesizers do not allow returning relative to the C in the next
#' octave up, the offset will be above B for such a note.
#' \item `offset_cents`: offset in cents from `key_12EDO`
#' }
#'
#' _Note: offsets are meaningless if `period` is greater than 2, so in that case they are not computed!_
#' @examples
#'
#' print(vanilla <- et_scale_table()) # default is 12EDO, of course
#'
#' # 19-EDO
#' # About the note names: even in 2023, code often breaks when given
#' # characters outside the 7-bit international standard. So we don't even
#' # have flats, let alone half-flats, half-sharps, naturals, or any of the
#' # other symbols alternate tuning theorists have proposed.
#'
#' # So outside of 12EDO, where sharps do double-duty, and product set
#' # scales, where we can use the product label as a note name, we use a
#' # "/b" for a half-flat, "b" for a flat, "/#" for a half-sharp, and "#"
#' # for a sharp. Thanks in advance for your understanding.
#'
#' nn19 <- c(
#'   "C",
#'   "C#",
#'   "Db",
#'   "D",
#'   "D#",
#'   "Eb",
#'   "E",
#'   "E#",
#'   "F",
#'   "F#",
#'   "Gb",
#'   "G",
#'   "G#",
#'   "Ab",
#'   "A",
#'   "A#",
#'   "Bb",
#'   "B",
#'   "B#")
#'
#' print(edo19 <- et_scale_table(nn19))
#'
#' # 31-EDO
#' nn31 <- c(
#'   "C",
#'   "C/#",
#'   "C#",
#'   "Db",
#'   "D/b",
#'   "D",
#'   "D/#",
#'   "D#",
#'   "Eb",
#'   "E/b",
#'   "E",
#'   "Fb",
#'   "E#",
#'   "F",
#'   "F/#",
#'   "F#",
#'   "Gb",
#'   "G/b",
#'   "G",
#'   "G/#",
#'   "G#",
#'   "Ab",
#'   "A/b",
#'   "A",
#'   "A/#",
#'   "A#",
#'   "Bb",
#'   "B/b",
#'   "B",
#'   "Cb",
#'   "B#")
#' print(edo31 <- et_scale_table(nn31))

et_scale_table <- function(note_names = c(
  "C",
  "C#",
  "D",
  "D#",
  "E",
  "F",
  "F#",
  "G",
  "G#",
  "A",
  "A#",
  "B"
), period = 2) {
  note_name <- note_names
  degrees <- length(note_names)
  degree <- seq(0, degrees - 1)
  ratio_cents <- degree * .ratio2cents(period) / degrees
  ratio <- .cents2ratio(ratio_cents)
  ratio_frac <- as.character(fractional::fractional(ratio))
  offset_cents <- vector(mode = "numeric", length = degrees)
  key_12edo <- vector(mode = "character", length = degrees)
  scale_table <- data.table::data.table(
    note_name,
    ratio,
    ratio_frac,
    ratio_cents
  )
  data.table::setkey(scale_table, ratio)
  last_row <- data.table::data.table(
    note_name = paste(scale_table$note_name[1], "'", sep = ""),
    ratio = period,
    ratio_frac = as.character(fractional::fractional(period)),
    ratio_cents = .ratio2cents(period)
  )
  scale_table <- data.table::rbindlist(list(scale_table, last_row))
  scale_table <- scale_table[, `:=`(
    interval_cents = ratio_cents - data.table::shift(ratio_cents),
    degree = .I - 1
  )]

  # compute pitch bend offsets if they are valid
  if (period <= 2) {
    scale_table <- .compute_pitch_bend_offsets(scale_table)
  }
  return(scale_table)
}

#' @title Create Interval Table
#' @name interval_table
#' @description Creates an interval table from a scale table
#' @importFrom fractional fractional
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @export interval_table
#' @param scale_table a scale table from `ps_scale_table`,
#' `cps_scale_table`, or `et_scale_table`
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
#'
#' # default is the 1-3-5-7-9-11 Eikosany
#' eikosany <- cps_scale_table()
#' print(eikosany_interval_table <-interval_table(eikosany))

interval_table <- function(scale_table) {

  # get dimensions
  input_rows <- length(scale_table$degree)
  out_rows <- input_rows * (input_rows - 1) / 2
  # allocate output vectors
  from_name <- to_name <- vector(mode = "character", length = out_rows)
  from_degree <- to_degree <- vector(mode = "integer", length = out_rows)
  ratio <- vector(mode = "numeric", length = out_rows)

  out_ix <- 0
  for (ix_from in 1:(input_rows - 1)) {
    for (ix_to in (ix_from + 1):input_rows) {

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

#' @title Create CPS Chord Table
#' @name cps_chord_table
#' @description Creates a chord table for a combination product set scale
#' based on an *even* number of harmonic factors.
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom utils combn
#' @importFrom utils globalVariables
#' @export cps_chord_table
#' @param scale_table a CPS scale table based on an *even* number of
#' harmonic factors. It will abort via
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
#' "sub-harmonic" chords.
#'
#' @examples
#'
#' # compute the tetrads of the 1-3-5-7-9-11 Eikosany
#' eikosany <- cps_scale_table()
#' print(eikosany_chords <- cps_chord_table(eikosany))
#'
#' # compute the pentads of the 1-3-5-7-9-11-13-15 Hebdomekontany
#' hebdomekontany <- cps_scale_table(
#'   harmonics = c(1, 3, 5, 7, 9, 11, 13, 15), choose = 4
#' )
#' print(hebdomekontany_chords <- cps_chord_table(hebdomekontany))

cps_chord_table <- function(scale_table) {

  # drop last row of scale table
  temp <- .drop_last_row(scale_table)

  harmonics <- .label2harmonics(temp$note_name, .NOTE_SEP)
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
    harm_note_degree <- .matrix2degree(harm_note_matrix, temp)
    harm_matrix[, icol] <- harm_note_degree$degree

    # subharmonic note matrix
    subharm_note_matrix <- t(apply(
      harm_note_matrix, MARGIN = 1, FUN = function(x) setdiff(harmonics, x)
    ))
    subharm_note_matrix <- t(apply(subharm_note_matrix, MARGIN = 1, FUN = sort))

    # subharmonic note degree
    subharm_note_degree <- .matrix2degree(subharm_note_matrix, temp)
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
#' @name keyboard_map
#' @description Creates a keyboard map
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom data.table ":="
#' @export keyboard_map
#' @param scale_table a scale table from `ps_scale_table`,
#' `cps_scale_table`, or `et_scale_table`
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
#'
#' Normally you would only use this to remap a keyboard to a scale with
#' more than 12 notes per octave. For scales with 12 or fewer notes to the
#' octave, it's easier to remap all octaves using the offsets provided in
#' the scale table.
#' @examples
#'
#' eikosany <- cps_scale_table()
#' print(eikosany_keyboard_map <- keyboard_map(eikosany))
#'
#' # 12-EDO for sanity check
#' print(vanilla_keyboard_map <- keyboard_map(et_scale_table()))
#'
#' # check middle C setting
#' print(
#'   eikosany_keyboard_map_c3 <-
#'     keyboard_map(cps_scale_table(), middle_c_octave = 3))

keyboard_map <- function(scale_table, middle_c_octave = 4) {

  # create note number vector
  note_number <- .NN_RANGE
  note_numbers <- length(note_number)

  # drop last row of scale table
  temp <- .drop_last_row(scale_table)

  # create indices
  degrees <- nrow(temp)
  degrees_12edo <- 12
  octave <- (note_number - .NN_MIDDLE_C) %/% degrees
  key_octave <- (note_number - .NN_MIDDLE_C) %/% degrees_12edo
  degree <- (note_number - .NN_MIDDLE_C) %% degrees
  degree_12EDO <- (note_number - .NN_MIDDLE_C) %% degrees_12edo

  # note names
  note_name <- key_name <- ratio_frac <-
    vector(mode = "character", length = note_numbers)
  note_name[note_number + 1] <- temp$note_name[degree + 1]
  ratio_frac[note_number + 1] <- temp$ratio_frac[degree + 1]
  key_name[note_number + 1] <- .NAMES_12EDO[degree_12EDO + 1]

  # cents and frequencies
  cents <-
    temp$ratio_cents[degree + 1] + octave * 1200 + .CENTS_MIDDLE_C
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
  ref_keyname <- .NAMES_12EDO[ref_degree + 1]

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
