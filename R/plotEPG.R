#' @title plotEPG
#' @author Oyvind Bleka
#' @description EPG plotter created by Oskar Hansson.
#' @details Plots peak height with corresponding allele for one sample for a given kit.
#' @param Data List of adata- and hdata-elements ("samples")
#' @param kitname Short name of kit: See supported kits with getKit()
#' @param threshT The detection threshold can be shown in gray in the plot.
#' @param refcond condition on a list$refname$locname$adata of reference alleles which are labeled in EPG
#' @param showPH Whether peak heights should be included in the plot
#' @export

plotEPG <- function(Data,kitname,threshT=0,refcond=NULL,showPH=FALSE) {
 #Data is list with allele and height data. Only one sample!
 #for selected sample:

 generateEPG<-function(typingKit, alleleList, heightList, locus, sampleName, refList=NULL, refnames=NULL,  samescale = FALSE, showPH=FALSE){

	# This function generates an electropherogram (EPG) like plot from lists of allele names and peak heights.

	# INPUT PARAMETERS:
 	# typingKit - kit short name or index number as specified in the function 'getKit'.
	# alleleList - a list of alleles names.
	# heightList - a list of peak heights.
	# locus - a vector specifying the marker names.
	# sampleName - title on the EPG.
	# refList - a list of reference-index
	# refnames - a vector with reference names
  #samescale - boolean whether same scale should be plotted for all dyers

  drawpeaks <- length(sn)==1 #draw peaks only if one replicate, otherwise draw points

	# CONSTANTS:
	defaultRepeatUnit <- 4 # Default repeat unit in base pairs:
  defaultLocusName <- "Locus " # Default locus name (will be suffixed with a number):
	defaultMarkerSpacing <- 100 # Default marker spacing in base pairs:

	# GRAPH CONSTANTS:
	
	# Graph title:
	# sampleName is used as title.
	xlabel <- "bp" # X axis label:
	ylabel <- "peak height (rfu)"	 # Y axis label:
	peakHalfWidth <- 0.4 # Peak half width in base pair (width of peak = 2 * peakHalfWidth):
	alleleNameTxtSize <- 0.8 # Relative Allele name text size:	
	yMarginTop <- 1.05 # Distance between the highest peak in a plot and the plot border (1.04 = 4% margin).
  if(showPH) yMarginTop <- 1.3 
		
  kit <- getKit(typingKit) # Get kit information.
	# Check if kit was found.	
	if (is.na(kit)[1]) {
		print("Kit not found.")
		print("Using default values.")
		kitFound <- FALSE
 	} else { # Kit found. Save information in vectors.
		kitFound <- TRUE
    unittab <- getKit(typingKit, what="offset")
    rangetab <- getKit(typingKit, what="range") 
		locusVectorKit <- rangetab[,1] # Marker/locus names.
		dyeVectorKit <- rangetab[,2] 	# Dye for each marker/locus    
		offsetVectorKit <- unittab[,2] #Base pair start offset for each marker.
		repeatUnitVectorKit <- unittab[,3] #Size in base pair of repeating unit for each marker.

    #Range of markers:
    locusMinVectorKit <- rangetab[,3]
    locusMaxVectorKit <- rangetab[,4]
	}

	# Check dye vector.
	if (kitFound) {
		dyeVector <- dyeVectorKit
	} else {
		dyeVector <- rep("black", length(locus)) #  Use default color.
	}

	# Check offset vector.
	if (kitFound) {
		offsetVector <- offsetVectorKit
	} else {
		offsetVector <- seq(0, length(locus) * defaultMarkerSpacing, by = defaultMarkerSpacing) #  Use default marker spacing.
	}

	# Check repeatUnit vector.
	if (kitFound) {
		repeatUnitVector <- repeatUnitVectorKit
	} else {
		repeatUnitVector <- rep(defaultRepeatUnit, length(locus))# Use default repeat unit length.
	}


	# PREPARE PARAMETERS

	# Convert dye vector to numeric vector.
	colors <- unique(dyeVector)  
  nColors <-  length(colors) 

	# Create lists:
	bpListByColorList <- list()
	bpListByColorListRep <- list()
	phListByColorRep <- list()
	allelesByColorList <- list()	
  markerByColorList <- list()
  refByColorList <- list() 
  isLab <- length(refnames)>0 #boolean have labels
  bpmarkerByColorList <- list() #used for giving bp for a given marker

	# SORT DATA ACCORDING TO COLOR CHANNEL and
	# CONVERT ALLELE NAMES TO FRAGMENT LENGTH IN BASE PAIRS

	# Loop over all color channels.
	for (color in 1:nColors){
    basePairTmpLst <- list()
    
		# Boolean vector indicating selected markers (same color).
 		selectedMarkers <- dyeVector == colors[color]

    if (kitFound) {
      markerByColorList[[color]] <- locusVectorKit[selectedMarkers] #EDIT by OB: marker names
		} else {
      markerByColorList[[color]] <- locus #EDIT by OB: marker names
    }
		allelesByColor <- alleleList[selectedMarkers] # Extract all alleles in the same color channel.
		heightsByColor <- heightList[selectedMarkers] # Extract all peak heights in the same color channel.		
		offsetByColor <- offsetVector[selectedMarkers]# Extract all marker offsets in the same color channel.
		repeatUnitByColor <- repeatUnitVector[selectedMarkers] # Extract all repeat unit sizes in the same color channel.
    refByColor <- refList[selectedMarkers] #added OB

		# Loop over all markers in that color channel.
		for(marker in 1:length(markerByColorList[[color]]) ){
			alleleValue <- allelesByColor[[marker]] # Get alleles for the current marker.
			hasXY <- sapply(alleleValue,function(x) length(grep("[X,x,Y,y]", x))) # Check presence of X/Y.
			if (sum(hasXY)>0) {
			  alleleValue <- lapply(alleleValue,function(x) { #Use 1 and 2 for X and Y.
                       x <- sub("X", 1, toupper(x))
                       x <- sub("Y", 2, toupper(x))
                       return(x)
                    })
	    } 
		  alleleValue <- lapply(alleleValue,as.numeric) 
            
			# Convert all allele names in current marker to base pairs.
			basePairTmpLst[[marker]] <- lapply(alleleValue,function(x) return(offsetByColor[marker] + floor(x) * repeatUnitByColor[marker] + (x %% 1) * 10) )
		}
    bpmarkerByColorList[[color]] <- sapply(basePairTmpLst,function(x) min(unlist(x)))
           
		# Add basepair to list.
		for(row in 1:length(allelesByColor)){

			# Avoid 'subscript out of bounds' error.
      tmp <- cbind(unlist(allelesByColor[[row]]),unlist(basePairTmpLst[[row]]))
      if(isLab)  tmp <- cbind(tmp,unlist(refByColor[[row]]))
      tmp <- unique(tmp) #consider only the unique

			if (length(bpListByColorList)<color){
				bpListByColorListRep[[color]] <- basePairTmpLst[[row]]
				phListByColorRep[[color]] <- heightsByColor[[row]]
				allelesByColorList[[color]] <- tmp[,1] #get unique alleles
				bpListByColorList[[color]] <- as.numeric(tmp[,2]) #get unique base pairs
        if(isLab) refByColorList[[color]] <- tmp[,3]
			} else {
        for(ss in sn) {
 				  bpListByColorListRep[[color]][[ss]] <- c(bpListByColorListRep[[color]][[ss]], basePairTmpLst[[row]][[ss]]) 
				  phListByColorRep[[color]][[ss]] <- c(phListByColorRep[[color]][[ss]], heightsByColor[[row]][[ss]])
        }
				allelesByColorList[[color]] <- c(allelesByColorList[[color]], tmp[,1] )
        bpListByColorList[[color]] <- c(bpListByColorList[[color]],as.numeric(tmp[,2])) #get unique base pairs           
 				if(isLab) refByColorList[[color]] <- c(refByColorList[[color]],tmp[,3])
			}
		}
	}

  ################
	# CREATE GRAPH #
  ################
	# Set up the plot window according to the number of color channels.
	par(mfrow = c(nColors, 1))

	# Make x axis cross at y = 0 (i.e. remove the 4% margin at both ends of the y axis).
	par(yaxs = "i")

	# Reduce the spacing between the plots.
	# c(bottom, left, top, right) is the number of lines of margin to be specified on the four sides of the plot.
	# The default is c(5, 4, 4, 2) + 0.1
	par(mar = c(2.3, 4, 1.5, 1) + 0.1)

	# Define lower and upper bound for the x/y axis.
	xMin <- min(sapply( bpListByColorList,function(x) min(na.omit(x))))
	xMax <- max(sapply( bpListByColorList,function(x) max(na.omit(x))))
	yMaxCol <- sapply( phListByColorRep,function(x) max(sapply(x,function(y) max(na.omit(y)))) )  #get maximum of y per col
  yMaxCol[is.infinite(yMaxCol)] = 1e-6 

	#Loop over all color channels.
	for (color in 1:nColors) {

		# Get alleles and peak heights for current marker.
		bpVec <- bpListByColorList[[color]]
		bpVecRep <- bpListByColorListRep[[color]]
		hVec <- phListByColorRep[[color]]
		aVec <- allelesByColorList[[color]]
    if(isLab) rVec <- refByColorList[[color]] #references for each alleles

		# Create blank plot with axes.
    yMax <- 1
		noData <- FALSE
		if(length(yMaxCol)>0) {
      yMax <- yMaxCol[color]
      if(samescale) yMax <- max(yMaxCol)
    } else {
      noData <- TRUE
    }

    plot(c(xMin, xMax), c(0, yMax), type="n", ylim = c(0, yMax * yMarginTop), ann = FALSE,axes=FALSE)
    axis(side = 2)
    bpgrid = 25
    nl <- ceiling(xMax/bpgrid) #number of ticks (for each 25 bp)
    xs = seq(0,bpgrid*nl,bpgrid)
    axis(side = 1,at=xs,labels=rep("",length(xs)))
    if(isLab && color==1) legend("topright",legend=paste0("Label ",1:length(refnames)," = ",refnames),bty="n")
    abline(h=0)
    if(threshT>0) abline(h=threshT,col="gray",lwd=0.5) #plot threshold
		if (noData) text(xMax / 1.4, yMax / 2, labels="No data", cex = 1.5) # Write text if no data.
		if (color == 1) 	title(main = sampleName, col.main = "red", font.main = 4) # Create a title.
		title(ylab = ylabel) # Label the y axes.

		# Write allele names under the alleles.
		# The additional par(xpd=TRUE) makes it possible to write text outside of the plot region.
		if(length(bpVec)==0) next #skip if no info
      text(bpVec, 0, labels = aVec, cex = alleleNameTxtSize, pos = 1, xpd = TRUE) 
      if(isLab) text(bpVec,-yMax/20,labels=rVec,cex = alleleNameTxtSize,pos=1, xpd = TRUE)
      text(bpmarkerByColorList[[color]],  yMax * yMarginTop ,markerByColorList[[color]],cex=1,font=2,xpd = TRUE)

   	# Loop over all peaks.
		for (peak in 1:length(bpVec)) {
			if (drawpeaks) { # Create corners of peak triangle.
       ph <- hVec[[1]][peak]
			 xCords <- c(bpVec[peak] - peakHalfWidth, bpVec[peak], bpVec[peak] + peakHalfWidth)
			 yCords <- c(0, ph, 0)
  		 polygon(xCords, yCords, col = tolower(as.character(colors[color]))) # Plot peaks as filled polygons.
       if(showPH && ph!=1e-6)  text(bpVec[peak],ph+20*nchar(ph), labels = hVec[[1]][peak], cex = alleleNameTxtSize,srt=90) 
         
			} else {# If scatterplot is to be drawn. 
        delta <- peakHalfWidth/length(sn)*4 #width of bars
        for(sind in 1:length(sn)) {
          if(is.na(bpVec[peak])) next
          ind <- which(round(bpVecRep[[sn[sind]]])==round(bpVec[peak]))
          x1 <- bpVec[peak]+delta*((sind-1)-length(sn)/2)
          x2 <- bpVec[peak]+delta*(sind-length(sn)/2)
    		  if(length(ind)>0) {
            ph <- hVec[[sn[sind]]][ind]
            rect(x1,0,x2,ph,border=tolower(as.character(colors[color])),col=sind,lwd=0.1)
            if(showPH && ph!=1e-6)  text((x1+x2)/2,ph+20*nchar(ph), labels = ph, cex = alleleNameTxtSize,srt=90,col=sind) 
    		  }
        }
			} 
		} #end for each peak
  }#end for each color
  dev.new()
  op <- par(no.readonly = TRUE)
  dev.off()
  par(op)
 } #end plot function

 ################
 #START FUNCTION#
 ################
 
  #fix order prior:
  kit <- getKit(kitname)
  sn <- names(Data) #sample names
  locs <- unique(unlist(lapply(Data,names))) #get unique loci
  alist <- hlist <- clist <- list() #lists to store allele and peak height data
  for(loc in locs) { #impute missing heights with 1
    adata <- lapply(Data,function(x) x[[loc]]$adata)
    hdata <- lapply(Data,function(x) x[[loc]]$hdata)
    clist[[loc]] <- list()
    for(ss in sn) { #impute missing heights with 1
      lA <- length(adata[[ss]])
      if(length(hdata[[ss]])==0 && length(lA>0)) hdata[[ss]] <- rep(1,lA) #impute with height 1 (if hdata is missing)
    }
  
    #reference data:
    if(!is.null(refcond)) {
     rdata <- lapply(refcond,function(x) unlist(x[[loc]]))
     unrdata <- unique(unlist(rdata))
     for(ss in sn) { 
      isdup <- duplicated(adata[[ss]]) #check if any alleles comes several times
      adata[[ss]] <- adata[[ss]][!isdup]
      hdata[[ss]] <- hdata[[ss]][!isdup]
      newA <- unrdata[!unrdata%in%adata[[ss]]] #get new alleles not seen in data
      nA <- length(newA)
      if(nA>0) {
       adata[[ss]] <- c(adata[[ss]], newA)
       hdata[[ss]] <- c(hdata[[ss]], rep(1e-6,nA)) #insert peak heights
      }
      clist[[loc]][[ss]] <- rep("",length(adata[[ss]]))
      for(rn in names(refcond)) {
       ri <- which(names(refcond)==rn) #reference index
       ind <- adata[[ss]]%in%rdata[[rn]]
       fix <- nchar(clist[[loc]][[ss]][ind])>0 
       clist[[loc]][[ss]][ind][fix] <- paste0(clist[[loc]][[ss]][ind][fix],"/")
       clist[[loc]][[ss]][ind] <- paste0(clist[[loc]][[ss]][ind],ri)
      }
     }
    }
    alist[[loc]] <- adata
    hlist[[loc]] <- hdata
  } #end for each loci
  
  if (!is.na(kit[[1]][1])) { #the kit was found.
    kitlocs <- toupper(getKit(kitname,what="marker")) #make uppercase
    sname <- paste0(kitname," - ",paste0(sn,collapse="/"))
    AMELname <- kitlocs[grep("AM",kitlocs,fixed=TRUE)] #get amel-name
    if(!is.null(AMELname)) {
     AMind <- grep("AM",toupper(locs),fixed=TRUE)
     locs[AMind] <- AMELname
     names(alist)[AMind] <- AMELname
     names(hlist)[AMind] <- AMELname
     if(!is.null(refcond)) names(clist)[AMind] <- AMELname
    }
    
    #Insert missing loci:
    missloc <- kitlocs[!kitlocs%in%locs] #get missing loci
    for(loc in missloc) {
      alist[[loc]] = rep(list(""),length(sn))
      hlist[[loc]] = rep(list(1e-6),length(sn))
      names(alist[[loc]]) <- names(hlist[[loc]]) <- sn
      if(!is.null(refcond)) { 
        clist[[loc]] = rep(list(""),length(sn))
        names(clist[[loc]]) <- sn 
      }
    }
    alist <- alist[kitlocs] 
    hlist <- hlist[kitlocs] 
    if(!is.null(refcond))  clist <- clist[kitlocs] 
    
  } else {
    kitlocs <- locs
  }
#typingKit=kitname;alleleList=alist;heightList=hlist;locus=kitlocs;sampleName=sname;refList=clist;refnames=names(refcond);showPH=showPH
   generateEPG(typingKit=kitname,alleleList=alist,heightList=hlist, locus=kitlocs,sampleName=sname, refList=clist,refnames=names(refcond),showPH=showPH)

} 

