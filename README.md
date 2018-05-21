# phenexRaster
A set of ancillary functions for running phenex R package

## Installation

Installation is easy you just have to run the following lines:     

```R

if(!("devtools" %in% installed.packages()[,1])){
  install.packages("devtools")
}
  
library(devtools)
install_github("joaogoncalves/phenexRaster")

```

## Warnings 

These functions are experimental and errors may happen. In addition, the performance 
of _phenoPhase_ may not be suitable to work with large datasets (npixels > 5E5 or so). 
A couple of limitations apply to this package:      

   - Only complete years can be used (at least for now);

   - Only a single value can be passed to _modelNDVI_ function: _multipleSeasons_, _correction_, and, _method_ parameters; as well as for _phenoPhase_ function: _method_ and _threshold_ parameters.
   
   
