#'Read LiDAR point data
#'
#'@description This function reads and returns values associated with the LAS file format. The LAS file is a public file format for the interchange of LiDAR 3-dimensional point cloud data (American Society of Photogrammetry and Remote Sensing - ASPRS)
#'
#'@usage readLASdata_bin (LASfile, inputCRS, returnAll=FALSE)
#'
#'@param LASfile A standard LAS data file (ASPRS)
#'@param An exactly formatted proj4 string to be interpreted as a CRS by SP pacakge.
#'@param Logical. Default FALSE. By default, only returns Classification 0, 1, & 2.
#'@return Returns a Spatial Points class of the point information stored in the LAS file.
#'@author Nicholas Kruskamp
#'@examples
#'
#'@export
#'@importFrom rlas readlasdata
#'@importFrom sp coordinates proj4string CRS

readLidarData <- function(inputFile, inputCRS, returnAll = FALSE){

  x <- rlas::readlasdata(inputFile, Intensity = F, ReturnNumber = T,
                         NumberOfReturns = T, ScanDirectionFlag = F,
                         EdgeOfFlightline = F, Classification = T,
                         ScanAngle = F, UserData = F, PointSourceID = F,
                         RGB = F, filter = "")

  if (returnAll==F) x[x$Classification %in% c(0, 1, 2), ]

  sp::coordinates(x) <- ~X+Y
  sp::proj4string(x) <- sp::CRS(inputCRS)
  return(x)
}