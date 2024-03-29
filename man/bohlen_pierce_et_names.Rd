% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{bohlen_pierce_et_names}
\alias{bohlen_pierce_et_names}
\title{Note names for equal-tempered Bohlen-Pierce scale}
\format{
\subsection{\code{bohlen_pierce_et_names}}{

A character vector with 13 elements
}
}
\source{
\url{https://en.wikipedia.org/wiki/Bohlen\%E2\%80\%93Pierce_scale#Intervals_and_scale_diagrams}
}
\usage{
bohlen_pierce_et_names
}
\description{
For scale tables created using function \code{et_scale_table}, the user must
specify note names. As a convenience, the \code{eikosany} package includes
data sets for \verb{12EDO}, \verb{19EDO}, \verb{31EDO}, and the equal-tempered
Bohlen-Pierce scale.
}
\details{
Even in 2023, code often breaks when given
characters outside the 7-bit international standard. So we don't even
have flats, let alone half-flats, half-sharps, naturals, or any of the
other symbols alternate tuning theorists have proposed.

So for scales created with equal divisions of the octave, we use a
"/b" for a half-flat, "b" for a flat, "bb" for a double-flat, /#"
for a half-sharp, "#" for a sharp. and "##" for a double-sharp. Thanks
in advance for your understanding.
}
\keyword{datasets}
