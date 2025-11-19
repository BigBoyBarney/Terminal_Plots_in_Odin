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

draw_scene :: proc ( mouse_list : [ ][ 2 ]f64,
                     cat_list   : [ ][ 2 ]f64 ) {
                         
    fig := plot.make_figure( )
    defer plot.destroy_figure( & fig )
    
    fig.width  = 50
    fig.height = 20
    
    // Draw mouse positions with text labels
    mouse_x := make( [ dynamic ]f64 )
    mouse_y := make( [ dynamic ]f64 )
    names := make( [ dynamic ]string )
    defer delete( mouse_x )
    defer delete( mouse_y )
    defer delete( names )
    
    for mouse, idx in mouse_list {
        
        append( & mouse_y, mouse[ 0 ] ) // Note: Python swaps x,y in text()
        append( & mouse_x, mouse[ 1 ] )
        append( & names, fmt.tprintf( "o MOUSE %d", idx ) )
    }
    
    plot.figure_text( & fig, mouse_x[ : ], mouse_y[ : ], names[ : ], plot.color_from_name( "red" ) )
    
    // Draw cat positions as scatter
    cat_x := make( [ dynamic ]f64 )
    cat_y := make( [ dynamic ]f64 )
    defer delete( cat_x )
    defer delete( cat_y )
    
    for cat in cat_list {
        
        append( & cat_y, cat[ 0 ] ) // Note: Python swaps x,y
        append( & cat_x, cat[ 1 ] )
    }
    
    plot.figure_scatter( & fig, cat_x[ : ], cat_y[ : ], plot.color_from_name( "green" ), "Cat", 'x' )
    
    result := plot.figure_show( & fig, legend = true )
    fmt.println( result )
}

main :: proc() {
    
    mouse_list := [ ][ 2 ]f64 {
        
        { -36, 108 }, { -36, 108.2 }, { -35.1, 108 },
    }
    
    cat_list := [ ][ 2 ]f64{
        
        { -35.4, 108 },
    }
    
    draw_scene( mouse_list, cat_list )
}
