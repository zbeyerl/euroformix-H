% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/contLikINT.R
\name{contLikINT}
\alias{contLikINT}
\title{contLikINT}
\usage{
contLikINT(
  nC,
  samples,
  popFreq,
  lower,
  upper,
  refData = NULL,
  condOrder = NULL,
  knownRef = NULL,
  xi = NULL,
  prC = 0,
  reltol = 1,
  threshT = 50,
  fst = 0,
  lambda = 0,
  pXi = function(x) 1,
  kit = NULL,
  scale = 0,
  maxEval = 0,
  knownRel = NULL,
  ibd = c(1, 0, 0),
  xiFW = 0,
  pXiFW = function(x) 1,
  maxThreads = 0,
  verbose = TRUE
)
}
\arguments{
\item{nC}{Number of contributors in model.}

\item{samples}{A List with samples which for each samples has locus-list elements with list elements adata and hdata. 'adata' is a qualitative (allele) data vector and 'hdata' is a quantitative (peak heights) data vector.}

\item{popFreq}{A list of allele frequencies for a given population.}

\item{lower}{Lower bounds of parameters. Must be in following order: mx1,..,mx_(nC-1),mu,sigma,beta,xi.}

\item{upper}{Upper bounds of parameters. Must be in following order: mx1,..,mx_(nC-1),mu,sigma,beta,xi.}

\item{refData}{Reference objects has locus-list element [[i]] with a list element 'r' which contains a 2 long vector with alleles for each references.}

\item{condOrder}{Specify conditioning references from refData (must be consistent order). For instance condOrder=(0,2,1,0) means that we restrict the model such that Ref2 and Ref3 are respectively conditioned as 2. contributor and 1. contributor in the model.}

\item{knownRef}{Specify known non-contributing references from refData (index). For instance knownRef=(1,2) means that reference 1 and 2 is known non-contributor in the hypothesis. This affectes coancestry correction.}

\item{xi}{A numeric giving stutter-ratio if it is known. Default is NULL, meaning it is integrated out.}

\item{prC}{A numeric for allele drop-in probability. Default is 0.}

\item{reltol}{Required relative tolerance error of evaluations in integration routine.}

\item{threshT}{The detection threshold given. Used when considering probability of allele drop-outs.}

\item{fst}{is the coancestry coeffecient. Default is 0.}

\item{lambda}{Parameter in modeled peak height shifted exponential model. Default is 0.}

\item{pXi}{Prior function for xi-parameter (stutter). Flat prior on [0,1] is default.}

\item{kit}{shortname of kit: Obtained from getKit()}

\item{scale}{used to make integrale calculateable for small numbers. For scale!=0, integrale must be scaled afterwards with exp(-scale) to be correct.}

\item{maxEval}{Maximum number of evaluations in the adaptIntegrate function. Default is 0 which gives an infinite limit.}

\item{knownRel}{gives the index of the reference which the 1st unknown is related to.}

\item{ibd}{the identical by decent coefficients of the relationship (specifies the type of relationship)}

\item{xiFW}{A numeric giving FW stutter-ratio if it is known.Default is 0, meaning stutter is not used.}

\item{pXiFW}{Prior function for xiFW-parameter (FW stutter). Flat prior on [0,1] is default.}

\item{maxThreads}{Maximum number of threads to be executed by the parallelization}

\item{verbose}{Whether printing limits to integrate over. Printing progress if maxEval>0. Default is TRUE.}
}
\value{
ret A list(margL,deviation,nEvals,scale) where margL is Marginalized likelihood for hypothesis (model) given observed evidence, deviation is the confidence-interval of margL, nEvals is number of evaluations.
}
\description{
contLikINT marginalizes the likelihood through numerical integration.
}
\details{
Replaced by new function calcINT
}
\references{
Hahn,T. (2005). CUBA - a library for multidimensional numerical integration. Computer Physics Communications, 168(2),78-95.
}
\author{
Oyvind Bleka
}
\keyword{Marginalized}
\keyword{likelihood}
