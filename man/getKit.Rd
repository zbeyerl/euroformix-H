% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getKit.R
\name{getKit}
\alias{getKit}
\title{getKit}
\usage{
getKit(kit = NULL, what = NA, fileName = "kit.txt", folderName = NULL)
}
\arguments{
\item{kit}{Short name of kit: See supported kits with getKit()}

\item{what}{Options: "Index","Panel","Short.Name","Full.Name","Marker","Allele","Size","Virtual","Color","Repeat","Range","Offset","Gender"}

\item{fileName}{Name of kit file used to extract kitinformation}

\item{folderName}{Name of folder containing the kit file 'fileName'. Using package folder if not specified.}
}
\value{
res A data frame with kit information
}
\description{
Function to get kit information. Tidied up and slightly modified by Oyvind Bleka
}
\details{
Returns kit information
}
\author{
Oskar Hansson
}
