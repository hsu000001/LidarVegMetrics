#'Calculate Vertical Distribution Ratios
#'
#'@description This function calculates two vertical distribution ratios for vegetation analysis from lidar data. The ratios are calulated as the 98%ile - 50%ile / 98%ile, and 100%ile - 50%ile / 100%ile.
#'
#'@usage calcVertDistRatio(x, resolution = 30, pointClasses = c(3,4,5))
#'
#'@param x Spatial Points Data Frame containing X, Y, Z coordinates and Classification data.
#'@param resolution Number specifying the grid cell resolution of the output raster.
#'@param pointClasses List of numbers specifying the point classifications to subset the lidar data.
#'@return returns a raster stack where each layer is a ratio.
#'@author Nicholas Kruskamp
#'@examples
#'
#'@export

calcVertDistRatio <- function(x, outputDir, tileName, resolution = 30, pointClasses = c(100:200)){
  percLayer <- calcHeightPercentiles(x, resolution = resolution, percentiles = c(.50, .98, 1.0))
  x <- x[x$Classification %in% pointClasses, ]
  vdr98 <- (percLayer$X98 - percLayer$X50) / percLayer$X98

  prod <- "vdr98"
  outputFile <- file.path(outputDir, prod, paste(tileName, paste(prod,".tif", sep = ""), sep = "_"))
  raster::writeRaster(vdr98, outputFile)

  vdr100 <- (percLayer$X100 - percLayer$X50) / percLayer$X100
  prod <- "vdr100"
  outputFile <- file.path(outputDir, prod, paste(tileName, paste(prod,".tif", sep = ""), sep = "_"))
  raster::writeRaster(vdr100, outputFile)


  layer_list <- list(vdr98, vdr100)
  names(layer_list) <- c("vdr98", "vdr100")
  return(layer_list)
  }
