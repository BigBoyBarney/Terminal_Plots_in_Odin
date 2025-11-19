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
    
    fmt.println( "=== Terminal Plots in Odin - Terminal Plotting Library ===\n" )
    
    // Example 1: Simple scatter plot
    example_scatter( )
    
    // Example 2: Line plot
    example_plot( )
    
    // Example 3: Sine and cosine waves
    example_sine_cosine( )
    
    // Example 4: Histogram
    example_histogram( )
    
    // Example 5: Figure with multiple plots
    example_figure( )
}

example_scatter :: proc ( ) {
    
    fmt.println("--- Example 1: Scatter Plot ---")
    
    X := [ ]f64{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
    Y := [ ]f64{ 1, 4, 9, 16, 25, 36, 49, 64, 81, 100 }
    
    result := plot.scatter( X, Y, 60, 20, "X", "Y^2" )
    fmt.println( result )
    fmt.println( )
}

example_plot :: proc( ) {
    
    fmt.println( "--- Example 2: Line Plot ---" )
    
    // Generate some data
    N :: 50
    X := make( [ ]f64, N )
    Y := make( [ ]f64, N )
    defer delete( X )
    defer delete( Y )
    
    for i in 0 ..< N {
        x := f64( i ) / f64( N ) * 4 * math.PI
        X[ i ] = x
        Y[ i ] = math.sin( x )
    }
    
    result := plot.plot( X, Y, 60, 20, "x", "sin(x)" )
    fmt.println( result )
    fmt.println( )
}

example_sine_cosine :: proc ( ) {
    
    fmt.println( "--- Example 3: Sine and Cosine Waves ---" )
    
    // Generate data
    N :: 100
    X := make( [ ]f64, N )
    Y_sin := make( [ ]f64, N )
    Y_cos := make( [ ]f64, N )
    defer delete( X )
    defer delete( Y_sin )
    defer delete( Y_cos )
    
    for i in 0 ..< N {
        
        x := f64( i ) / f64( N ) * 4 * math.PI
        X[ i ] = x
        Y_sin[ i ] = math.sin( x )
        Y_cos[ i ] = math.cos( x )
    }
    
    // Create figure
    fig := plot.make_figure( )
    defer plot.destroy_figure( & fig )
    
    fig.width  = 80
    fig.height = 25
    plot.figure_set_x_limits( & fig, 0, 4 * math.PI )
    plot.figure_set_y_limits( & fig, -1.2, 1.2 )
    fig.x_label = "x"
    fig.y_label = "y"
    
    plot.figure_plot( & fig, X, Y_sin, plot.Color_Name.Red, "sin(x)" )
    plot.figure_plot( & fig, X, Y_cos, plot.Color_Name.Blue, "cos(x)" )
    
    result := plot.figure_show( & fig, legend = true )
    fmt.println( result )
    fmt.println( )
}

example_histogram :: proc ( ) {
    
    fmt.println( "--- Example 4: Histogram ---" )
    
    // Generate random-ish data ( simulating normal distribution )
    N :: 1000
    data := make( [ ]f64, N )
    defer delete( data )
    
    // Simple pseudo-random normal distribution
    for i in 0 ..< N {
        
        // Box-Muller transform approximation
        u1 := f64( i ) / f64( N )
        u2 := f64( ( i * 7 + 13 ) % N ) / f64( N )
        z := math.sqrt( -2 * math.ln( u1 + 0.001 ) ) * math.cos( 2 * math.PI * u2 )
        data[ i ] = z
    }
    
    result := plot.hist( data, 30, 60 )
    fmt.println( result )
    fmt.println( )
}

example_figure :: proc ( ) {
    
    fmt.println( "--- Example 5: Figure with Multiple Plots ---" )
    
    // Generate data
    N :: 50
    X := make( [ ]f64, N )
    Y1 := make( [ ]f64, N )
    Y2 := make( [ ]f64, N )
    Y3 := make( [ ]f64, N )
    defer delete( X )
    defer delete( Y1 )
    defer delete( Y2 )
    defer delete( Y3 )
    
    for i in 0 ..< N {
        x := f64( i ) / f64( N ) * 10
        X[ i ] = x
        Y1[ i ] = math.sqrt( x )
        Y2[ i ] = x
        Y3[ i ] = x * x / 10
    }
    
    // Create figure
    fig := plot.make_figure( )
    defer plot.destroy_figure( & fig )
    
    fig.width   = 70
    fig.height  = 25
    fig.x_label = "x"
    fig.y_label = "f(x)"
    
    plot.figure_plot( & fig, X, Y1, plot.Color_Name.Green, "sqrt(x)" )
    plot.figure_plot( & fig, X, Y2, plot.Color_Name.Yellow, "x" )
    plot.figure_plot( & fig, X, Y3, plot.Color_Name.Cyan, "x^2/10" )
    
    result := plot.figure_show( & fig, legend = true )
    fmt.println( result )
    fmt.println( )
}
