% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cps_functions.R
\name{offset_matrix}
\alias{offset_matrix}
\title{Create Offset Matrix}
\usage{
offset_matrix(scale_table)
}
\arguments{
\item{scale_table}{a scale table}
}
\value{
the offset matrix. Columns represent key names in 12-tone
equal temperament. Rows represent note names from the scale table. The
value of a matrix cell is the offset in cents you need to apply to the
column name's key to get the row name's scale note.
}
\description{
Creates an offset matrix from a scale table. An offset
matrix is used to retune an octave for synthesizers that support such
retunings, like the Korg Minilogue XD and the Dirtywave M8 tracker.
}
\details{
The columns of an offset matrix represent key names in 12-tone
equal temperament. Rows represent note names from a scale table. The
value of a matrix cell is the offset in cents you need to apply to the
column name's key to get the row name's scale note.

For example, if the value in row "3x9" and column "C#" is 104, you
would tune the "C#" key up 104 cents to have it play "3x9". If the
value in row "1x7", column "D#" is -33, you would tune the "D#" key
down 33 cents.

Keep in mind that you can only use each 12-TET key once, and you have
to end up with a key for all the notes in the scale. The strategy I
use is:

For scales with seven or fewer notes, I retune the white keys starting
with C, and retune any left-over white keys to the last note in the
scale. For a hexany, it's fun to stick an extra note in somewhere.

For scales with 8 to 12 notes, I retune the keys from left to right,
again sometimes adding notes to fill up to 12. There's an example of this
in \emph{Microtonality and the Tuning Systems of Erv Wilson}, pages 127 - 131.
This example is worked out in examples \code{grady_a} and \code{grady_b} for the
function \code{ps_scale_table}.
}
\seealso{
\code{\link[=ps_scale_table]{ps_scale_table()}}
}
