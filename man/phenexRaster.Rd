% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/phenexRaster.R
\name{phenexRaster}
\alias{phenexRaster}
\title{Applies phenex functions to a raster object}
\usage{
phenexRaster(rst, index, years, jdays = seq(1, 365, 16),
  multipleSeasons = FALSE, correction = "bise", method = "LinIP",
  doParallel = FALSE, viMultFactor = NULL, phase, methodPheno = "local",
  threshold = 0.55, n = 1000, export = "memory", ...)
}
\arguments{
\item{rst}{A \code{RasterStack} or \code{RasterBrick} object}

\item{index}{An integer index with the same value for each image in a year; e.g., considering three
images per year and a total of two years we got: c(1,1,1, 2,2,2).}

\item{years}{An integer vector detailing which years are in the time-series. Note that the number of
unique values in \code{index} must be equal to the length of \code{years}.}

\item{jdays}{Julian days for each image considering a single year (e.g., for MODIS MOD13Q1 NDVI 16-day
product, the following could be used \code{jdays = seq(1,365,16)}, default value).}

\item{multipleSeasons}{Determines wether a season detection should be performed or not. 
			Setting \sQuote{multipleSeasons} to TRUE forces following algorithms modelling NDVI and extracting 				phenological phases to be performed once per detected season.}

\item{correction}{A character string determining which method will be used for correction of NDVI values. 
			Should be either:

			\dQuote{\bold{none}}: no correction will be performed.
			
			\dQuote{\bold{ravg}}: Smoothing with running average. Default window size is 7 
				and can be modified by parameter \sQuote{window.ravg}. See also \code{\link{runningAvg}}.


			\dQuote{\bold{bise}}: Best index slope extraction after \emph{Viovy et. al} (1992).
			Second interpretation of bise algorithm.
			Can be modified with parameter \sQuote{slidingperiod}. Default to 40, optimised for 
			the area of Central Europe. This might has to be modified 
			when vegetation dynamics of other climates/habitats are analysed. 
			An maximum increase threshold is defined via parameter \sQuote{growthFactorThreshold} with 
			default to 0.1 (10 percent increase per day allowed).
			The timeserie is cycled via parameter \sQuote{cycleValues}, which is a 
			boolean value determining whether the end of the ndvi timeserie 
			is combined with its beginning or not (default value is true). If false, gaps or low ndvi 
			values at the beginning of timeserie influence the result.
			}

\item{method}{Determines which model will be fitted to the corrected NDVI-timeserie (if the 
				corrected timeserie is not available, the raw one out of \sQuote{values} will be used). 

				\dQuote{\bold{LinIP}}: A linear interpolation is performed. For interpolation, the end of 
				timeserie is connected to the beginning (e.g. after day 365 follows day 1). 
				Applied in \emph{Badeck et. al} (2004) and \emph{Doktor et. al} (2009).

				\dQuote{\bold{Spline}}: A spline interpolation is performed. For interpolation, the end of 
				timeserie is connected to the beginning (e.g. after day 365 follows day 1).

				\dQuote{\bold{DSig}}: Fits a double sigmoidal function to NDVI values (according to Zhang et. al (2003)).

				\dQuote{\bold{DSigC}}: Fits another double sigmoidal function (own C implementation) to NDVI values.

				\dQuote{\bold{DLogistic}}: Fits a double logistic function after \emph{Fischer, Alberte} (1994) to NDVI values.

				\dQuote{\bold{Gauss}}: Fits a symmetric or asymmetric (determined by boolean parameter \sQuote{asym}) gaussian 
					function to NDVI values (own C implementation after \emph{Press, W.H.} (1992)).

				\dQuote{\bold{GaussMix}}: Fits a mixture of gaussian functions to NDVI values (own C implementation after \emph{Press, W.H.} (1992)).
						The number of components is determined by parameter \sQuote{components}. If multiple components are given, 
						the algorithm checks which number performs best.

				\dQuote{\bold{Growth}}: Fits a plant growth model after \emph{Richter et. al} (1991) to NDVI values.

				\dQuote{\bold{FFT}}: Smoothes the corrected or raw NDVI values with fast fourier transformation (implemented in R). 
					The smoothing intensity can be controlled with parameter \sQuote{filter.threshold} with default to 3.

				\dQuote{\bold{SavGol}}: Smoothes the corrected or raw NDVI values with a Savitzky-Golay 
					filter (own C implementation after \emph{Press, W.H.} (1992)). 
					The smoothing algorithm can be modified with parameters 
					\sQuote{window.sav} (window size of filter, default to 7),
					\sQuote{degree} (degree of fitting polynomial, default to 2) 
					and \sQuote{smoothing} (repetition quantity, default to 10).}

\item{doParallel}{This method uses 'foreach'. If a parallel backend is registered, setting \sQuote{do.parallel} to \sQuote{TRUE} enables parallel processing.}

\item{viMultFactor}{A multiplication factor for vegetation indices for putting data in the decimal
format required by package phenex.}

\item{phase}{Determines which phase will be extracted:
			
			\dQuote{\bold{max}}: Day of the year with highest NDVI value is returned.

			\dQuote{\bold{maxval}}: The highest modelled NDVI value and its standard deviation is returned.

			\dQuote{\bold{min}}: Day of the year (before day with maximum NDVI value) 
						with lowest NDVI value is returned. 
		
			\dQuote{\bold{minval}}: The lowest modelled NDVI value and its standard deviation is returned.

			\dQuote{\bold{greenup}}: Day of the year at which greenup takes place and its standard deviation is returned. 
				This day refers to the point where the function of modelled NDVI values 
				exceeds a certain threshold.
			
			\dQuote{\bold{senescence}}: Day of the year at which senescence takes place and its standard deviation is returned. 
				This day refers to the point where the function of modelled NDVI values exceeds 
				a certain threshold.}

\item{methodPheno}{Determines whether a global or local threshold is used for greenup and senescence
extraction. “global” threshold: The day of the year is returned, where NDVI values are first equal or
higher as the value of ‘threshold’. If the threshold is higher than the values of the timeseries, ‘-1’ will
be returned.“local” threshold: The day of the year is returned, for which NDVI values first reach the value
of ‘threshold’ (interpreted as percentage) between lowest and highest NDVI value of the time-series. The lowest
NDVI value is chosen depending on phase selected. For “greenup”, the lowest value before day of maximum NDVI
value is used. For “senescence”, the lowest value after day of maximum NDVI value is used.}

\item{threshold}{Threshold for local or global greenup/senescence-extraction method. 
		Should have numerical value between \sQuote{0} and \sQuote{1}. Global thresholds 
		refer to a fix NDVI value independent of actual NDVI magnitudes. 
		Local thresholds are based on (max - min) * e.g. 0.55. Hence, the respective 
		NDVI value will vary dependent on e.g. land-cover.}

\item{n}{The number \sQuote{n} of normal distributed values around the threshold for estimation of \sQuote{sd}. The normal distribution uses the threshold as mean and a standaed deviation consisting of 			satellite error and standard deviation of fit residuals. The satellite error is considered as 0.02+0.02*value.}

\item{export}{How to export data. Either a string with \code{'memory'} which will put every single output
including VI modelled values and \code{phenoPhase} metrics by year in memory or, \code{'file'} which export
everything to GeoTIFF files. The first option (\code{'memory'}) is not suited for large datasets.}

\item{...}{Further arguments to be passed to \code{\link[phenex]{modelNDVI}}. These are parameters passed
to smoothing or modelling functions. These are: ‘slidingperiod’ for correction “bise”, ‘window.ravg’ for
correction “ravg”, ‘asym’ for method “Gauss”, ‘filter.threshold’ for method “FFT” and ‘degree’, ‘window.sav’
and ‘smoothing’ for method “SavGol”.}
}
\value{
If \code{export = 'memory'}, then a list containing the following elements will be returned:

\describe{

    \item{modVIRstStack}{A RasterStack containing modelled data for all years}

    \item{phenoMetricsRstAvg}{A RasterStack containing \code{phenoPhase} metrics average}

    \item{phenoMetricsRstStd}{A RasterStack containing \code{phenoPhase} metrics standard-deviation}
}

Otherwise \code{NULL} will be returned.
}
\description{
A set of ancillary function used to apply phenex functionalities to a \code{Raster*} object.
Supports the sequential application of functions: \code{\link[phenex]{modelNDVI}} (used to
model, smooth andinterpolate VI time-series) and \code{\link[phenex]{phenoPhase}} used for
Phenological Phase Extraction.
}
\details{
The function supports multiple \code{phase} values (character vector) to be passed to \code{phenoPhase} function.
}
\note{
These functions are experimental and errors may happen. In addition, the performance of \code{phenoPhase} may
not be suitable to work with large datasets (npixels > 5E5 or so). A couple of limitations apply to this function:

\itemize{
   \item Only complete years can be used (at least for now);

   \item only a single value can be passed to \code{modelNDVI} function: \code{multipleSeasons},
   \code{correction}, and, \code{method} parameters; as well as for \code{phenoPhase} function: \code{method}
   and \code{threshold} parameters.
}
}
\seealso{
\code{\link[phenex:modelNDVI]{modelNDVI}}
\code{\link[phenex:phenoPhase]{phenoPhase}}
}
