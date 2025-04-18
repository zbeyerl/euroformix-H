% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepareCobj.R
\name{prepareCobj}
\alias{prepareCobj}
\title{prepareCobj}
\usage{
prepareCobj(c, verbose = FALSE)
}
\arguments{
\item{c}{returned list object from prepareC function}

\item{verbose}{Whether to printing time used}
}
\value{
Pointer to C++ module
}
\description{
Wrapper function to prepare the C++ module
}
\details{
Takes values from prepareC functions and prepares datastructure in C++
}
\author{
Oyvind Bleka
}
