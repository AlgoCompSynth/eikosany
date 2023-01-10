# helper functions

# separator for notes (products)
.note_sep <- "x"

# separator for chords
.chord_sep <- ":"

.matrix2label <- function(matrix, separator) {
  apply(matrix, MARGIN = 1, FUN = paste, collapse = separator)
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
  note_label <- .matrix2label(note_matrix, .note_sep)
  note_index <- data.table::data.table(product = note_label)
  degree_table <- scale_table[
    note_index,
    list(product, degree),
    on = "product"
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
  result_table <- t(combn(harmonics, choose))
  product <- .matrix2label(result_table, .note_sep)
  num_product <- apply(result_table, 1, prod)
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
#' # the defaults yield the 1-3-5-7-9-11 Eikosany
#' eikosany_scale <- scale_table()
#' print(eikosany_scale)
#'
#' # compute the tetrads of the 1-3-5-7-9-11 Eikosany
#' eikosany_chords <- chord_table(eikosany_scale, 4)
#' print(eikosany_chords)
#' }

chord_table <- function(scale_table, choose) {
  harmonics <- .label2harmonics(scale_table$product, .note_sep)
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
  chord_label <- .matrix2label(chords, .chord_sep)
  subchord_label <- paste("/", chord_label, sep = "")
  harm_label <- .matrix2label(harm_matrix, .chord_sep)
  subharm_label <- .matrix2label(subharm_matrix, .chord_sep)

  return(data.table::data.table(
    chord = c(chord_label, subchord_label),
    degrees = c(harm_label, subharm_label)
  ))
}

utils::globalVariables(c(
  "degree",
  "product"
))
