% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cps_functions.R
\name{ps_scale_table}
\alias{ps_scale_table}
\title{Create Product Set Scale Table}
\usage{
ps_scale_table(
  ps_def = c("1x3x5", "5x9x11", "1x7x9", "1x3x11", "3x5x9", "1x5x7", "3x9x11", "1x7x11",
    "5x7x9", "3x5x11", "1x3x7", "7x9x11", "1x5x9", "3x7x9", "5x7x11", "1x9x11", "3x5x7",
    "1x3x9", "1x5x11", "3x7x11"),
  root_divisor
)
}
\arguments{
\item{ps_def}{the product set scale definition. This is a character
vector of products. Each product is a set of any number of integers
separated by a lower-case "x". For example, the \code{ps_def} of the 1-3-5-7
Hexany is

\code{c("1x3", "1x5", "1x7", "3x5", "3x7", "5x7")}

The default is the \code{ps_def} for the 1-3-5-7-9-11 Eikosany.}

\item{root_divisor}{a divisor that scales one of the products to 1/1.
Most published CPS scales just use the smallest of the products for this,
but Erv Wilson used 1x3x11 for the Eikosany, because that maps 1x5x11 to
concert pitches for A: 55, 110, 220, 440 etc. There is no default value.}
}
\value{
a \code{data.table} with six columns:
\itemize{
\item \code{note_name}: the given product set definition, re-ordered by the
degrees of the resulting scale (character)
\item \code{ratio}: the ratio that defines the note, as a number between 1 and
2
\item \code{ratio_frac}: the ratio as a vulgar fraction (character)
\item \code{ratio_cents}: the ratio in cents (hundredths of a semitone)
\item \code{interval_cents}: interval between this note and the previous note
\item \code{degree}: scale degree from zero to (number of notes) - 1
}
}
\description{
Creates a scale table from a product set definition
}
\examples{

# the default yields the 1-3-5-7-9-11 Eikosany
print(eikosany <- ps_scale_table(root_divisor = 33))

# Kraig Grady's Eikosany as two complementary extended Dekanies
# See _Microtonality and the Tuning Systems of Erv Wilson_, pages 127 - 131
# for the process used to create these scales
print(grady_a <- ps_scale_table(c(
  "1x3x11",
  "1x9",
  "3x9x11",
  "1x7x11",
  "1x3x7",
  "7x9x11",
  "3x7x9",
  "1x9x11",
  "1x3x9",
  "1x7",
  "3x7x11",
  "1x7x9"
), root_divisor = 33))
print(grady_a_offsets <- offset_matrix(grady_a))
print(grady_b <- ps_scale_table(c(
  "3x5x11",
  "1x5x9",
  "3x5x9x11",
  "5x7x11",
  "3x5x7",
  "1x5x11",
  "1x3x5",
  "5x9x11",
  "3x5x9",
  "1x5x7",
  "3x5x7x11",
  "5x7x9"
), root_divisor = 3*5*11))
print(grady_b_offsets <- offset_matrix(grady_b))
}
\seealso{
\code{\link[=offset_matrix]{offset_matrix()}}
}
