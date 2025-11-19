// Canvas example - Drawing custom shapes with low-level API

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
import "core:math"
import plot "../terminal_plots"

main :: proc ( ) {
    
    fmt.println( "=== Canvas Drawing Example ===\n" )
    
    // Create a 40x20 character canvas
    canvas := plot.make_canvas( 40, 20, 0.0, 0.0, 1.0, 1.0 )
    defer plot.destroy_canvas( & canvas )
    
    // Draw a house
    // Base
    plot.canvas_rect( & canvas, 0.1, 0.1, 0.6, 0.6 )
    
    // Roof lines
    plot.canvas_line( & canvas, 0.1, 0.6, 0.35, 0.8 )
    plot.canvas_line( & canvas, 0.35, 0.8, 0.6, 0.6 )
    
    // Door
    plot.canvas_line( & canvas, 0.25, 0.1, 0.25, 0.3 )
    plot.canvas_line( & canvas, 0.35, 0.1, 0.35, 0.3 )
    plot.canvas_line( & canvas, 0.25, 0.3, 0.35, 0.3 )
    
    // Window
    plot.canvas_point( & canvas, 0.45, 0.45, true, plot.Color_Name.Yellow )
    plot.canvas_point( & canvas, 0.47, 0.45, true, plot.Color_Name.Yellow )
    plot.canvas_point( & canvas, 0.45, 0.47, true, plot.Color_Name.Yellow )
    plot.canvas_point( & canvas, 0.47, 0.47, true, plot.Color_Name.Yellow )
    
    // Add text
    plot.canvas_text( & canvas, 0.65, 0.5, "HOME", true, plot.Color_Name.Cyan )
    
    // Draw some decorative circles (using points)
    draw_circle( & canvas, 0.8, 0.8, 0.1 )
    draw_circle( & canvas, 0.8, 0.2, 0.08 )
    
    result := plot.canvas_plot( & canvas )
    fmt.println( result )
}

// Helper to draw a circle using points
draw_circle :: proc( canvas : ^plot.Canvas,
                     cx     : f64,
                     cy     : f64,
                     radius : f64 ) {
    
    steps :: 50
    for i in 0 ..< steps {
        
        angle := f64( i ) / f64( steps ) * 2 * math.PI
        x := cx + radius * math.cos( angle )
        y := cy + radius * math.sin( angle )
        plot.canvas_point( canvas, x, y, true, plot.Color_Name.Green )
    }
}
