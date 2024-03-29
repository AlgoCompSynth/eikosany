% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cps_functions.R
\name{cps_chord_table}
\alias{cps_chord_table}
\title{Create CPS Chord Table}
\usage{
cps_chord_table(scale_table)
}
\arguments{
\item{scale_table}{a CPS scale table based on an \emph{even} number of
harmonic factors. It will abort via

\code{stop("number of harmonic factors must be even!")}

if it receives one with an odd number.}
}
\value{
a data.table with four columns:
\itemize{
\item \code{chord}: the chord expressed as colon-separated harmonics. A
subharmonic chord is prefixed with a "~".
\item \code{degrees}: the chord expressed as colon-separated scale degrees
\item \code{chord_index}: the row number of the chord in the combination output
\item \code{is_subharm}: zero if it's harmonic, one if it's subharmonic.
}
The resulting data.table is sorted into harmonic-subharmonic pairs using
\code{data.table::setkey.}
}
\description{
Creates a chord table for a combination product set scale
based on an \emph{even} number of harmonic factors.
}
\details{
The algorithm used only works for a combination product set
built from an \emph{even} number of harmonic factors, so it aborts if it
receives one with an odd number.

In the following, the symbol \verb{n)m} is Erv Wilson's notation for the
number of combinations of \code{m} items taken \code{n} at a time. \code{n_harmonics}
is the number of harmonic factors, the resulting chords will have
\code{choose <- n_harmonics / 2 + 1} notes. There will be
\verb{choose)n_harmonics} "harmonic" chords and \verb{choose)n_harmonics}
"sub-harmonic" chords.
}
\examples{

# compute the tetrads of the 1-3-5-7-9-11 Eikosany
eikosany <- cps_scale_table(root_divisor = 33)
print(eikosany_chords <- cps_chord_table(eikosany))

# compute the pentads of the 1-3-5-7-9-11-13-15 Hebdomekontany
hebdomekontany <- cps_scale_table(
  harmonics = c(1, 3, 5, 7, 9, 11, 13, 15),
  choose = 4,
  root_divisor = 3 * 5 * 7
)
print(hebdomekontany_chords <- cps_chord_table(hebdomekontany))
}
