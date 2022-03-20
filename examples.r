import::from("src/hex.r", "hex", "hexgrid", "hexcoords")

# Plot a hexagonal coordinate grid
plot_hexagonal_coordinate_grid = function(){
    plot.new()
    plot.window(xlim=c(0,1),ylim=c(0,1))
    box()
    title(main="Hexagonal coordinate grid")
    hexgrid(r=0.1, text=TRUE)
    }


plot_horizontal_hexagonal_lines = function(){
    plot.new()
    plot.window(xlim=c(0,1), ylim=c(0,1))
    title(main="Hexagonal lines")
    
    # Initialize coordinate system
    r = 0.1
    hexcoord = hexcoords(r)

    # hexcoord returns a list    
    coords = Map(c, hexcoord(1, 0:7), hexcoord(3, 0:7), hexcoord(5, 0:7))
    invisible(Map(hex, x=coords$x, y=coords$y, r=r, col="red", border=NA))
    }


plot_random_hexagons = function(){
    plot.new()
    plot.window(xlim=c(0,1), ylim=c(0,1))
    title(main="Random colored hexagons")
    
    # Initialize coordinate system
    r = 0.1
    hexcoord = hexcoords(r)

    # all possible points:
    grid = expand.grid(x=0:6,y=0:7)
    # sample n of them and grab some random colors
    n=10
    points = grid[ sample(nrow(grid), n), ]
    cols = palette.colors(n, palette="Set 1", recycle=TRUE)
    
    # Need to pack passed function (hexcoord) in list for Map to work
    invisible(Map(hex, x=points$x, y=points$y, r=r,coords=list(hexcoord), 
                  col=cols, border=NA))
    }

if(sys.nframe() == 0){
    png("examples/grid.png")
    plot_hexagonal_coordinate_grid()
    dev.off()
    
    png("examples/lines.png")
    plot_horizontal_hexagonal_lines()
    dev.off()
    
    png("examples/random.png")
    plot_random_hexagons()
    dev.off()
    
    } else {
    plot_hexagonal_coordinate_grid()
    readline("Press enter to continue")
    plot_horizontal_hexagonal_lines()
    readline("Press enter to continue")
    plot_random_hexagons()
    }
