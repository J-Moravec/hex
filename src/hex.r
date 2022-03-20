#' hex.r
#'
#' Functions for drawing hexagons and hexagonal grid.


#' Draw a hexagon
#'
#' @param x,y   coordinates of the hexagon centre
#' @param r     **optional** a radius size of the hexagon
#' @param coord **optional** a hexagonal coordinate system. If provided,
#'              x and interpreted as a grid coordinates in this system.
#' @param ... **optional** other parameters passed to the `polygon` funcion,
#'             such as `col`, `border` or `lty`
hex = function(x, y=NULL, r=1, coords=NULL, ...){
    if(is.null(y)){
        if(length(x) == 2){
            y = x[[2]]
            x = x[[1]]
            } else {
            stop("Wrong dimension of a vector")
            }
        }

    if(!is.null(coords)){
        coord = coords(x,y)
        x = coord[[1]]
        y = coord[[2]]
        }


    t = inrad(r)
    polygon(
        c(x + t, x + t, x, x - t, x - t, x),
        c(y - r/2, y + r/2, y + r, y + r/2, y - r/2, y - r),
        ...
        )
    }


#' Draw a hexagonal grid
#'
#' @param r    **optional** a radius size of the hexagons
#' @param x,y  **optional** coordinates of the hexagon centre that defines
#'             the start of the hexagonal grid. Other hex coordinates are
#'             then interpreted relative to this starting point.
#' @param col  **optional** grid color
#' @param lty  **optional** grid line type
#' @param text **optional** prints the hexagonal grid coordinates, useful
#'             for debugging or for visualising the relative grid coordinates.
#' @param ...  other parameters passed to the `hex` function
#' @return a list containing the initiated coordinate system and the relative
#'         grid coordinates used to draw all hexes
hexgrid = function(r=1, x=0, y=0, col="lightgray", lty="dotted", text=FALSE, ...){
    t = inrad(r)
    lim = par("usr")
    
    xmin = floor((lim[1]-x)/(2*t))
    xmax = ceiling((lim[2]-x)/(2*t))
    ymin = floor((lim[3]-y)/(1.5*r))
    ymax = ceiling((lim[4]-y)/(1.5*r))

    # initialize hex coordinate system created by the grid
    hexcoord = hexcoords(r, x, y)
    grid = expand.grid("x"=xmin:xmax, "y"=ymin:ymax)
    coords = hexcoord(grid$x, grid$y)
    Map(hex, coords$x, coords$y, r=r, border=col, lty=lty, ...)

    if(text)
        text(paste0(grid$x, ",", grid$y), x=coords$x, y=coords$y)

    invisible(list("coords"=hexcoord, "grid"=grid))
    }


#' Create a hexagonal coordinate system
#'
#' Create a hexagonal coordinate system based on the hexagonal radius a
#' starting point.
#'
#' In the hexagonal coordinate system assumes a grid of tightly packed hexagons
#' with radius `r`. The `(0,0)` points of the grid starts in the `x` and `y`
#' coordinates.
#'
#' @param r   **optional** a radius size of the hexagons
#' @param x,y **optional** coordinates of the hexagon centre that defines
#'            the start of the hexagonal grid. Other hex coordinates are
#'            then interpreted relative to this starting point.
hexcoords = function(r=1, x=0, y=0){
    t = inrad(r)
    
    function(i, j){
        list("x"=x + i*(2*t) - t*(j%%2),
             "y"=y + j*1.5*r + 0*i)
        }
    }


#' Calculate the inner radius (inradius) of hexagon
#'
#' For hexagon, the inner radius, inradius or the size of traingular height
#' of one of the inner triangle that forms the hexagon, is `r * sqrt(3)/2`
#'
#' @param r radius
#' @return inradius
inrad = function(r){
    r * sqrt(3)/2
    }
