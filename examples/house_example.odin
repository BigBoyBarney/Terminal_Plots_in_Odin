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
    
    // The underlying canvas implementation can be used on its own
    canvas := plot.make_canvas( 40, 20 )
    defer plot.destroy_canvas( & canvas )
    
    // Draw house
    plot.canvas_rect( & canvas, 0.1, 0.1, 0.6, 0.6 )
    plot.canvas_line( & canvas, 0.1, 0.1, 0.6, 0.6 )
    plot.canvas_line( & canvas, 0.1, 0.6, 0.6, 0.1 )
    plot.canvas_line( & canvas, 0.1, 0.6, 0.35, 0.8 )
    plot.canvas_line( & canvas, 0.35, 0.8, 0.6, 0.6 )
    
    // Add text
    plot.canvas_text( & canvas, 0.3, 0.5, "hi", true, plot.Color_Name.Red )
    
    // Add point
    plot.canvas_point( & canvas, 0.35, 0.35, true, plot.Color_Name.Blue )
    
    // Fill character
    plot.canvas_fill_char( & canvas, 0.35, 0.1 )
    
    result := plot.canvas_plot( & canvas )
    fmt.println( result )
}
