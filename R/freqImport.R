#' @title freqImport
#' @author Oyvind Bleka
#' @description Imports allele frequencies directly from file(s) or URLs
#' @details The function supports XML as input, directly from an URL or local file (for instance from the STRidER webpage).
#' @param f The path of file(s) or an url. If file(s), then the url argument must be FALSE.
#' @param url Whether f is pointing to an url or not. Default is FALSE.
#' @param xml Whether f is pointing to an xml format file or not. If FALSE then table formats with standard separator types are considered. Default is FALSE.
#' @return dblist A list giving the population frequencies for every population
#' @export

freqImport = function(f=NULL,url=FALSE,xml=FALSE) {
 if(is.null(f) || length(f)==0) {
  stop("No frequency file were given!")
 }
 dbList <- list() #list of populations
 if(xml) {
   if(url) { #if f was given as an url 
    #f <- RCurl::getURL(f,.opts = RCurl::curlOptions(ssl.verifypeer=FALSE, verbose=TRUE)) #get url
  	con = curl::curl(url = f)
  	f = readLines(con) #reading text
  	close(con)	
   } 
   xml = XML::xmlTreeParse(f, useInternalNodes=TRUE) #read to text to XML-object
   locs <- unlist(XML::xpathApply(xml, "//name", XML::xmlValue)) #get list of markers
   for(i in 1:length(locs)) { #for each markers:
    loc <- toupper(locs[i]) #consider a specific marker/locus
    attrOrigin <- XML::xpathSApply(xml, paste0("/frequencies/marker[",i,"]/origin"), XML::xmlAttrs) #get all databases for the given marker
    if(length(attrOrigin)==0) next #skip if no data
    dbnames <- attrOrigin[1,] #number of samples not used
    for(name in dbnames) { #for each dbname
     alleles <- XML::xpathSApply(xml, paste0("/frequencies/marker[",i,"]/origin[@name='",name,"']/frequency") , XML::xmlAttrs) #get alleles
     freqs <- as.numeric(XML::xpathSApply(xml, paste0("/frequencies/marker[",i,"]/origin[@name='",name,"']/frequency") , XML::xmlValue)) #get frequencies
     names(freqs) <- alleles
     if(is.null(dbList[[name]])) dbList[[name]] <- list() #create list if not already existing
     dbList[[name]][[loc]] <- freqs #insert frequencies
    }
   }
 } else { #otherwise if other file format is considered
  for(ff in f) { #for each file
   tab=tableReader(ff)
   Anames = tab[,1] #first column is allele frequeneies
   tab = tab[,-1,drop=FALSE] 
   freqlist = list()
   for(j in 1:ncol(tab)) { #for each locus
     tmp = tab[,j]
     tmp2 = tmp[!is.na(tmp) & as.numeric(tmp)>0] #require that allele is not NA and is>0
     names(tmp2) = Anames[!is.na(tmp)]
     freqlist[[j]] = tmp2
   }
   names(freqlist) = toupper(colnames(tab)) #LOCUS-names are assigned as Upper-case! This is important to do!
   pop = unlist(strsplit(basename(ff),"\\."))[1] #get population name (remove '.' symbols)
   dbList[[pop]] <- freqlist
  } #end for each file ff in f
 } #end else
 return(dbList)
}
