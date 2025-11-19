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
    
    fig := plot.make_figure( )
    defer plot.destroy_figure( & fig )
    
    fig.width  = 50
    fig.height = 20
    
    // Generate sine wave data
    N :: 20
    x := make( [ ]f64, N )
    y := make( [ ]f64, N )
    defer delete( x )
    defer delete( y )
    
    for i in 0 ..< N {
        
        x[ i ] = f64( i ) * 2.0 * math.PI / f64( N - 1 )
        y[ i ] = math.sin( x[ i ] )
    }
    
    // Plot the sine wave
    plot.figure_plot( & fig, x, y, plot.color_from_name( "red" ), "sin(x)" )
    
    // Add text labels at every 5th point
    xs     := make( [ dynamic ]f64 )
    ys     := make( [ dynamic ]f64 )
    labels := make( [ dynamic ]string )
    defer delete( xs )
    defer delete( ys )
    defer delete( labels )
    
    for i := 0; i < N; i += 5 {
        
        append( & xs, x[ i ] )
        append( & ys, y[ i ] )
        append( & labels, fmt.tprintf( "x %.3f", y[ i ] ) )
    }
    
    plot.figure_text( & fig, xs[ : ], ys[ : ], labels[ : ], plot.color_from_name( "green" ) )
    
    result := plot.figure_show( & fig, legend = true )
    fmt.println( result )
}
