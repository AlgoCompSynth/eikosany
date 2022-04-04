
.collapse_star <- function(x) {
  paste(x, collapse = "*")
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

#' @title Create Scale Table and Interval Matrix
#' @name scale_table
#' @description Creates a scale table and interval matrix from
#' a combination product set definition
#' @importFrom data.table data.table
#' @importFrom data.table setkey
#' @importFrom data.table shift
#' @importFrom fractional fractional
#' @importFrom utils combn
#' @importFrom utils globalVariables
#' @export scale_table
#' @param harmonics a vector of the harmonics to use - defaults to the first
#' six odd numbers, the harmonics that define the 1-3-5-7-9-11 eikosany.
#' @param choose the number of harmonics to choose for each combination -
#' defaults to 3, the number of harmonics for each combination in the
#' eikosany.
#' @param base_frequency the base frequency in Hz - defaults to
#' `440 / (2 ^ (9 / 12))`, the frequency of middle C on a 12-tone equal
#' tempered keyboard when A = 440 Hz.
#' @param base_note_number the MIDI note number corresponding to the
#' base frequency - defaults to 60, the MIDI note number of middle C.
#' @return a list of two items:
#' \itemize{
#' \item `scale_table`: the scale table
#' \item `interval_matrix`: the interval matrix
#' }
#' The scale table contains six columns:
#' \itemize{
#' \item `cps_label`: the product that defines the note
#' \item `ratio`: the ratio that defines the note
#' \item `cents`: the ratio in cents (hundredths of a semitone)
#' \item `frequency`: the frequency of the note in Hz
#' \item `interval`: the interval in cents of the note over the preceding
#' note
#' \item `midi_note_number`: the MIDI note number for the note
#' }
#' The interval matrix is the matrix of all intervals between the notes,
#' expressed as ratios. Column 1 has the ratios of all the notes to the
#' first one, column 2 has the ratios of all the notes to the second one,
#' etc.
#' @examples
#' \dontrun{
#'
#' # the defaults yield the 1-3-5-7-9-11 eikosany
#' eikosany <- scale_table()
#' print(eikosany[["scale_table"]])
#' print(eikosany[["interval_matrix"]])
#'
#' # the 1-7-9-11-13 dekany
#' dekany_harmonics <- c(1, 7, 9, 11, 13)
#' dekany_choose <- 2
#' dekany_1_3_7_9_11_13 <-
#'   scale_table(dekany_harmonics, dekany_choose)
#' print(dekany_1_3_7_9_11_13[["scale_table"]])
#' print(dekany_1_3_7_9_11_13[["interval_matrix"]])
#'
#' }

scale_table <- function(
  harmonics = c(1, 3, 5, 7, 9, 11),
  choose = 3,
  base_frequency = 440 / (2 ^ (9 / 12)),
  base_note_number = 60) {
    scale_table <- combn(harmonics, choose)
    cps_label <- apply(scale_table, 2, .collapse_star)
    product <- apply(scale_table, 2, prod)
    normalizer <- min(product)
    ratio <- .octave_reduce(product / normalizer)
    cents <- .ratio2cents(ratio)
    frequency <- base_frequency * ratio
    scale_table <- data.table::data.table(
      cps_label, ratio, cents, frequency
    )
    setkey(scale_table, frequency)
    scale_table <- scale_table[, .(
      cps_label,
      ratio,
      cents,
      frequency,
      interval = cents - data.table::shift(cents),
      midi_note_number =
        (base_note_number):(base_note_number + nrow(scale_table) - 1)
    )]

    interval_matrix <- fractional(outer(
      scale_table$ratio,
      scale_table$ratio,
      "/"
    ))

    return(list(
      scale_table = scale_table, interval_matrix = interval_matrix
    ))
  }

utils::globalVariables(
  "."
)
