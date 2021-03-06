
#' Create points in a circle around an existing point
#'
#' This function caclulates the position of points in a circle around a start point. The circle
#' is based on the distance of the second point that is provided. This allows for example to
#' compare the the temperature conditions in all directions (i.e. is a bird flying in the
#' direction of warmer temperatures).
#'
#' @param lon Longitude of point 1
#' @param lat Latitude of point 1
#' @param lon2 Longitude of point 2
#' @param lat2 Latitude of point 2
#' @param pointN The number of points that should be created on the circle
#' @param PROJ The projection of the points (should be equal area)
#'
#' @return A table with the real point and estimated points around it
#' @export
#'
#' @importFrom sp SpatialPointsDataFrame spsample CRS
#' @importFrom rgeos gBuffer
#' @importFrom methods as
#' @examples
#' x        = 10
#' y        = 10
#' x2       = 100
#' y2       = 600
#' pointN   = 36
#' PROJ     = '+proj=laea +lat_0=90 +lon_0=-156.653428 +x_0=0 +y_0=0 +datum=WGS84 +units=m
#'             +no_defs +ellps=WGS84 +towgs84=0,0,0 '
#'
#' dp = pointCircle(x, y, x2, y2, pointN = 36, PROJ)
#'
#' # visualization of the example
#' library(sp)
#' dp = as.data.table (dp)
#' PS  = SpatialPointsDataFrame(dp[1, .(x,y)], dp[1, .(pointType)],
#'                              proj4string = CRS(PROJ), match.ID = TRUE)
#' PS2 = SpatialPointsDataFrame(dp[, .(x2,y2)], dp[, .(pointType)],
#'                              proj4string = CRS(PROJ), match.ID = TRUE)
#'
#' plot(PS2[PS2@data$pointType == 'estimated', ], col = 'red')         # estimated points
#' plot(PS2[PS2@data$pointType == 'real', ], col = 'blue', add = TRUE) # second point
#' plot(PS, add = TRUE)                                                # first point

pointCircle = function(lon, lat, lon2, lat2, pointN = 36, PROJ){

  # distance between the two points
  P_dist = sqrt(sum((c(lon, lat) - c(lon2, lat2))^2))

  # create spatial points

  PS = SpatialPointsDataFrame( cbind(lon,lat), data.frame(pointType = 'real'),
                               proj4string = CRS(PROJ), match.ID = TRUE)
  PS2 = SpatialPointsDataFrame(cbind(lon2,lat2), data.frame(pointType = 'real'),
                               proj4string = CRS(PROJ), match.ID = TRUE )

  # create a circle around the point with the distance of the second point
  PS_buffer = gBuffer(PS, width = P_dist, quadsegs = 10)
  PS_line = as(PS_buffer, "SpatialLines")

  # sample points on the circle
  PS_points = spsample(PS_line, n = pointN, type = 'regular')

  dE = data.frame(PS_points)

  d1 = data.frame(x = lon,
                  y = lat,
                  x2 = lon2,
                  y2 = lat2,
                  pointType = 'real' )


  d2 = data.frame(x  = rep(lon, nrow(dE)),
                  y  = rep(lat, nrow(dE)),
                  x2 = dE$x,
                  y2 = dE$y,
                  pointType = rep('estimated', nrow(dE)) )

  d = rbind(d1, d2)

  d

}






