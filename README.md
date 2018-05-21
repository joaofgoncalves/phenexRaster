# phenexRaster
      
A set of ancillary functions for running phenex R package


## Installation

Installation is easy you just have to run the following lines:     

```R

if(!("devtools" %in% installed.packages()[,1])){
  install.packages("devtools")
}
  
library(devtools)
install_github("joaofgoncalves/phenexRaster")

```


## How does phenexRaster works?

[[work in progress... ;-)]]

_phenexRaster_ provides some ancillary tools to apply phenex functionalities to a \code{Raster*} object.
To do this it applies in sequence the following functions: 
   - _modelNDVI_: used to model, smooth and interpolate VI time-series), and, 
   - _phenoPhase_ used for Phenological Phase Extraction (calculation of _'phenometrics'_).

Typically, satellite time-series, such as those provided by MODIS, make available 8- or 16-day composites 
(e.g., MOD13Q1 16-day/250m  data product) while _phenex_ works with daily data. _phenexRaster_ starts by 
constructing an annual data matrix with daily time-steps; then, values from each composite are injected in 
the matrix in positions corresponding to the reference Julian day of the composite. This makes it easier to 
smooth and interpolate values of vegetation indices using the _modelNDVI_ function. Using this matrix we can 
then extract phenological phase indicators by applying the function _phenoPhase_.


## Warnings 

These functions are experimental and errors may happen! In addition, the performance 
of _phenoPhase_ may not be suitable to work with large datasets (npixels > 5E5 or so). 
A couple of limitations apply to this package:      

   - Only complete years can be used (at least for now);

   - Only a single value can be passed to _modelNDVI_ function: _multipleSeasons_, _correction_, and, _method_ parameters; as well as for _phenoPhase_ function: _method_ and _threshold_ parameters.
   
   
