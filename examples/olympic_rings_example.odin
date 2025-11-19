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
    
    fig := plot.make_figure( )
    defer plot.destroy_figure( & fig )
    
    fig.width  = 50
    fig.height = 20
    
    // The olympic rings
    plot.figure_set_x_limits( & fig, 0, 600 )
    plot.figure_set_y_limits( & fig, 0, 500 )
    
    // Ring centers: [x, y, color]
    Ring :: struct {
        
        x     : f64,
        y     : f64,
        color : plot.Color_Name,
    }
    
    rings := [ ]Ring{
        
        { 250, 300, .Blue },    // Note: Y is flipped compared to Python (500 - 200 = 300)
        { 375, 300, .White },
        { 500, 300, .Red },
        { 310, 250, .Yellow },  // 500 - 250 = 250
        { 435, 250, .Green },
    }
    
    for ring in rings {
        
        X, Y := plot.circle( ring.x, ring.y, 50 )
        defer delete( X )
        defer delete( Y )
        
        plot.figure_plot( & fig, X, Y, ring.color, "" )
    }
    
    result := plot.figure_show( & fig, legend = false )
    fmt.println( result )
}
