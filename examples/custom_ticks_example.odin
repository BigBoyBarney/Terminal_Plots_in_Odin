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
    
    Y := [ ]f64{ 0, 10, 20, 20, 21, 25, 30, 32, 40, 44, 50, 51.3, 51.3, 51.3, 51.3, 51.3, 51.3, 51.3, 51.3, 51.3, 51.3 }
    X := make( [ ]f64, len( Y ) )
    defer delete( X )
    
    for i in 0 ..< len( Y ) {
        
        X[ i ] = f64( i )
    }
    
    // The Python version shows 4 plots with different tick formatters
    // We don't have tick formaters, only one formater.
    
    fmt.println( "Custom Ticks Example" )
    fmt.println( "===================\n" )
    fmt.println( "Note: The Python version allows custom tick formatting functions." )
    fmt.println( "This Odin version shows the default tick behavior.\n" )
    
    // Plot 1: Default Y-tick (showing minimum of range)
    fmt.println( "1. Default Y-tick formatter (shows minimum):" )
    fig1 := plot.make_figure( )
    plot.figure_plot( & fig1, X, Y, nil, "" )
    result1 := plot.figure_show( & fig1, legend = false )
    fmt.println( result1 )
    plot.destroy_figure( & fig1 )
    
    // Plot 2: Would show mean of Y values in range (same as default here)
    fmt.println( "\n2. Mean Y value formatter (not available in Odin - showing default):" )
    fig2 := plot.make_figure( )
    plot.figure_plot( & fig2, X, Y, nil, "" )
    result2 := plot.figure_show( & fig2, legend = false )
    fmt.println( result2 )
    plot.destroy_figure( & fig2 )
    
    // Plot 3: Custom string formatter
    fmt.println( "\n3. Custom string formatter (not available in Odin - showing default):" )
    fig3 := plot.make_figure( )
    plot.figure_plot( & fig3, X, Y, nil, "" )
    result3 := plot.figure_show( & fig3, legend = false )
    fmt.println( result3 )
    plot.destroy_figure( & fig3 )
    
    // Plot 4: Custom X and Y tick formatter
    fmt.println( "\n4. Custom X and Y tick formatter (not available in Odin - showing default):" )
    fig4 := plot.make_figure( )
    plot.figure_plot( & fig4, X, Y, nil, "" )
    result4 := plot.figure_show( & fig4, legend = false )
    fmt.println( result4 )
    plot.destroy_figure( & fig4 )
}
