// Terminal Plots in Odin
//
// A port of plotille lib from Python to Odin.
// Github tammoippen - plotille
// https://github.com/tammoippen/plotille
//
// License
// MIT Open Source License

package main

import "core:fmt"
import plot "../terminal_plots"

main :: proc ( ) {
    
    // First set - single ellipse
    fmt.println( "===>> Single Ellipse" )
    fig := plot.make_figure( )
    defer plot.destroy_figure( & fig )
    
    fig.width  = 50
    fig.height = 20
    
    X1, Y1 := plot.ellipse( 0, 0, 0.5, 0.5, 20 )
    defer delete( X1 )
    defer delete( Y1 )
    
    plot.figure_plot( & fig, X1, Y1, nil, "" )
    
    result := plot.figure_show( & fig, legend = true )
    fmt.println( result )
    
    // Second set - multiple ellipses
    fmt.println( "\n===>> Multiple Ellipses" )
    
    X2, Y2 := plot.ellipse( 0, 0, 1, 1 )
    defer delete( X2 )
    defer delete( Y2 )
    plot.figure_plot( & fig, X2, Y2, nil, "" )
    
    X3, Y3 := plot.ellipse( 0, 0, 0.5, 0.5, 20 )
    defer delete( X3 )
    defer delete( Y3 )
    plot.figure_plot( & fig, X3, Y3, nil, "Ellipse 2" )
    
    result = plot.figure_show( & fig, legend = true )
    fmt.println( result )
    
    // Third set - grid of ellipses
    fmt.println( "\n===>> Grid of Ellipses" )
    plot.figure_clear( & fig )
    
    X_main, Y_main := plot.ellipse( 0, 0, 1, 1 )
    defer delete( X_main )
    defer delete( Y_main )
    plot.figure_plot( & fig, X_main, Y_main, nil, "" )
    
    plot.figure_set_x_limits( & fig, -10, 10 )
    plot.figure_set_y_limits( & fig, -10, 10 )
    
    coords := [ ]f64{ -4, 0, 4 }
    for xx in coords {
        
        for yy in coords {
            
            X, Y := plot.ellipse( xx, yy, 1, 1, 20 )
            defer delete( X )
            defer delete( Y )
            
            label := fmt.tprintf( "%v,%v", xx, yy )
            plot.figure_plot( & fig, X, Y, nil, label )
        }
    }
    
    // Add scatter point
    x_pt := [ ]f64{ 4 }
    y_pt := [ ]f64{ 4 }
    plot.figure_scatter( & fig, x_pt, y_pt, nil, "" )
    
    result = plot.figure_show( & fig, legend = true )
    fmt.println( result )
}
