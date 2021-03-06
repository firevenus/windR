% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pointCircle.R
\name{pointCircle}
\alias{pointCircle}
\title{Create points in a circle around an existing point}
\usage{
pointCircle(lon, lat, lon2, lat2, pointN = 36, PROJ)
}
\arguments{
\item{lon}{Longitude of point 1}

\item{lat}{Latitude of point 1}

\item{lon2}{Longitude of point 2}

\item{lat2}{Latitude of point 2}

\item{pointN}{The number of points that should be created on the circle}

\item{PROJ}{The projection of the points (should be equal area)}
}
\value{
A table with the real point and estimated points around it
}
\description{
This function caclulates the position of points in a circle around a start point. The circle
is based on the distance of the second point that is provided. This allows for example to
compare the the temperature conditions in all directions (i.e. is a bird flying in the
direction of warmer temperatures).
}
\examples{
x        = 10
y        = 10
x2       = 100
y2       = 600
pointN   = 36
PROJ     = '+proj=laea +lat_0=90 +lon_0=-156.653428 +x_0=0 +y_0=0 +datum=WGS84 +units=m
            +no_defs +ellps=WGS84 +towgs84=0,0,0 '

dp = pointCircle(x, y, x2, y2, pointN = 36, PROJ)

# visualization of the example
library(sp)
dp = as.data.table (dp)
PS  = SpatialPointsDataFrame(dp[1, .(x,y)], dp[1, .(pointType)],
                             proj4string = CRS(PROJ), match.ID = TRUE)
PS2 = SpatialPointsDataFrame(dp[, .(x2,y2)], dp[, .(pointType)],
                             proj4string = CRS(PROJ), match.ID = TRUE)

plot(PS2[PS2@data$pointType == 'estimated', ], col = 'red')         # estimated points
plot(PS2[PS2@data$pointType == 'real', ], col = 'blue', add = TRUE) # second point
plot(PS, add = TRUE)                                                # first point
}
