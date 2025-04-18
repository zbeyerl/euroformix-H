% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepareC.R
\name{prepareC}
\alias{prepareC}
\title{prepareC}
\usage{
prepareC(
  nC,
  samples,
  popFreq,
  refData,
  condOrder,
  knownRef,
  kit,
  BWS,
  FWS,
  AT,
  pC,
  lambda,
  fst,
  knownRel,
  ibd,
  minF,
  normalize,
  adjFragQallele
)
}
\arguments{
\item{nC}{Number of contributors in model.}

\item{samples}{A list of samples (evidence) with structure [[samplename]][[locus]] = list(adata,...)}

\item{popFreq}{A list of allele frequencies for a given population.}

\item{refData}{Reference objects has locus-list element [[i]] with a list element 'r' which contains a 2 long vector with alleles for each references.}

\item{condOrder}{Specify conditioning references from refData (must be consistent order). For instance condOrder=(0,2,1,0) means that we restrict the model such that Ref2 and Ref3 are respectively conditioned as 2. contributor and 1. contributor in the model.}

\item{knownRef}{Specify known non-contributing references from refData (index). For instance knownRef=(1,2) means that reference 1 and 2 is known non-contributor in the hypothesis. This affectes coancestry correction.}

\item{kit}{shortname of kit: Obtained from getKit()}

\item{BWS}{Boolean of whether back-stutter model should be used}

\item{FWS}{Boolean of whether for-stutter model should be used}

\item{AT}{The analytical threshold given. Used when considering probability of allele drop-outs.}

\item{pC}{A numeric for allele drop-in probability. Default is 0.}

\item{lambda}{Parameter in modeled peak height shifted exponential model. Default is 0.}

\item{fst}{is the coancestry coeffecient. Default is 0.}

\item{knownRel}{gives the index of the reference which the 1st unknown is related to.}

\item{ibd}{the identical by decent coefficients of the relationship (specifies the type of relationship)}

\item{minF}{The freq value included for new alleles (new alleles as potential stutters will have 0). Default NULL is using min.observed in popFreq.}

\item{normalize}{Whether normalization should be applied or not. Default is FALSE.}

\item{adjFragQallele}{Indicate whether fragmenth length of Q-allele is based on averaged weighted with frequencies}
}
\value{
ret A list of data input to call the C++ code with
}
\description{
Preparing C++ calls (structure data into vectors)
}
\author{
Oyvind Bleka
}
