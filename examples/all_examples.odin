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
import "core:math/rand"
import "core:os"
import plot "../terminal_plots"

main :: proc ( ) {
    
    fmt.println( "=== Terminal Plots in ODIN - ALL EXAMPLES ===\n" )
    fmt.println( "Press Enter to continue between examples..." )
    
    example_scatter( )
    wait_for_enter( )
    
    example_plot( )
    wait_for_enter( )
    
    example_histograms( )
    wait_for_enter( )
    
    example_house( )
    wait_for_enter( )
    
    example_colors( )
    wait_for_enter( )
    
    example_olympic_rings( )
    wait_for_enter( )
    
    example_ellipses( )
    wait_for_enter( )
    
    example_multiple_plots( )
    wait_for_enter( )
    
    fmt.println( "\n=== ALL EXAMPLES COMPLETED ===" )
}

wait_for_enter :: proc ( ) {
    
    fmt.println( "\n[Press Enter to continue...]" )
    buf : [ 1 ]byte
    os.read( os.stdin, buf[ : ] )
}

// Example 1: Simple scatter plot
example_scatter :: proc ( ) {
    
    fmt.println( "=== EXAMPLE 1: SCATTER PLOT ===" )
    fmt.println( "Plot of sin(x) as scatter points\n" )
    
    N :: 20
    X := make( [ ]f64, N )
    Y := make( [ ]f64, N )
    defer delete( X )
    defer delete( Y )
    
    for i in 0 ..< N {
        X[ i ] = f64( i ) / f64( N - 1 ) * 2 * math.PI
        Y[ i ] = math.sin( X[ i ] )
    }
    
    result := plot.scatter( X, Y, 60, 30 )
    fmt.println( result )
}

// Example 2: Line plot with interpolation
example_plot :: proc ( ) {
    
    fmt.println( "=== EXAMPLE 2: LINE PLOT ===" )
    fmt.println( "Plot of sin(x) with line interpolation\n" )
    
    N :: 20
    X := make( [ ]f64, N )
    Y := make( [ ]f64, N )
    defer delete( X )
    defer delete( Y )
    
    for i in 0 ..< N {
        
        X[ i ] = f64( i ) / f64( N - 1 ) * 2 * math.PI
        Y[ i ] = math.sin( X[ i ] )
    }
    
    result := plot.plot( X, Y, 60, 30 )
    fmt.println( result )
}

// Example 3: Histograms ( horizontal and vertical )
example_histograms :: proc ( ) {
    
    fmt.println( "=== EXAMPLE 3: HISTOGRAMS ===" )
    
    // Generate normal distribution data
    N :: 10000
    data := make( [ ]f64, N )
    defer delete( data )
    
    // Box-Muller transform for normal distribution
    for i in 0 ..< N / 2 {
        
        u1 := rand.float64( )
        u2 := rand.float64( )
        
        r := math.sqrt( -2.0 * math.ln( u1 ) )
        theta := 2.0 * math.PI * u2
        
        data[ 2 * i ]     = r * math.cos( theta )
        data[ 2 * i + 1 ] = r * math.sin( theta )
    }
    
    fmt.println( "Histogram left to right (horizontal bars):\n" )
    result := plot.hist( data, 40, 60 )
    fmt.println( result )
    
    fmt.println( "\nHistogram displayed with Figure (vertical bars):\n" )
    fig := plot.make_figure( )
    defer plot.destroy_figure( & fig )
    
    fig.width = 80
    fig.height = 25
    fig.x_label = "Value"
    fig.y_label = "Frequency"
    
    plot.figure_histogram( & fig, data, 80 )
    
    result2 := plot.figure_show( & fig, legend=false )
    fmt.println( result2 )
}

// Example 4: Canvas drawing (house)
example_house :: proc ( ) {
    
    fmt.println( "=== EXAMPLE 4: CANVAS DRAWING (HOUSE) ===" )
    fmt.println( "Low-level canvas API for custom drawings\n" )
    
    canvas := plot.make_canvas( 40, 20 )
    defer plot.destroy_canvas( & canvas )
    
    // Draw house
    plot.canvas_rect( & canvas, 0.1, 0.1, 0.6, 0.6 )
    plot.canvas_line( & canvas, 0.1, 0.1, 0.6, 0.6 )
    plot.canvas_line( & canvas, 0.1, 0.6, 0.6, 0.1 )
    plot.canvas_line( & canvas, 0.1, 0.6, 0.35, 0.8 )
    plot.canvas_line( & canvas, 0.35, 0.8, 0.6, 0.6 )
    
    plot.canvas_text( & canvas, 0.3, 0.5, "hi", true, plot.Color_Name.Red )
    plot.canvas_point( & canvas, 0.35, 0.35, true, plot.Color_Name.Blue )
    plot.canvas_fill_char( & canvas, 0.35, 0.1 )
    
    result := plot.canvas_plot( & canvas )
    fmt.println( result )
}

// Example 5: Color demonstrations
example_colors :: proc ( ) {
    fmt.println( "=== EXAMPLE 5: COLOR SUPPORT ===\n" )
    
    // No color
    text := plot.apply_color( "Do not print colors, if no_color is set to True", 
                              plot.Color_Name.Red, nil, .Names, true )
    fmt.println( text )
    
    // Foreground
    text = plot.apply_color( "You can set a foreground", plot.Color_Name.Red )
    fmt.println( text )
    
    // Background
    text = plot.apply_color( "and a background.", nil, plot.Color_Name.Red )
    fmt.println( text )
    
    // Both
    text = plot.apply_color( "Or both.", plot.Color_Name.Black, plot.Color_Name.Cyan )
    fmt.println( text )
    
    fmt.println( )
    
    // Named colors
    text = plot.apply_color( "Aside from 4-bit / name colors", plot.Color_Name.Green, nil, .Names )
    fmt.println( text )
    
    // 8-bit
    text = plot.apply_color( "you can also set 8-bit colors / 256-color lookup tables", 
                             u8( 126 ), u8( 87 ), .Byte )
    fmt.println( text )
    
    // RGB
    rgb_fg := plot.RGB_Color{ 50, 50, 50 }
    rgb_bg := plot.RGB_Color{ 166, 237, 240 }
    text = plot.apply_color( "or go with full 24-bit rgb colors", rgb_fg, rgb_bg, .RGB )
    fmt.println( text )
}

// Example 6: Olympic Rings
example_olympic_rings :: proc ( ) {
    
    fmt.println( "=== EXAMPLE 6: OLYMPIC RINGS ===\n" )
    
    fig := plot.make_figure( )
    defer plot.destroy_figure( & fig )
    
    fig.width  = 50
    fig.height = 20
    plot.figure_set_x_limits( & fig, 0, 600 )
    plot.figure_set_y_limits( & fig, 0, 500 )
    
    Ring :: struct {
        
        x     : f64,
        y     : f64,
        color : plot.Color_Name,
    }
    
    rings := [ ]Ring{
        
        { 250, 300, .Blue },
        { 375, 300, .White },
        { 500, 300, .Red },
        { 310, 250, .Yellow },
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

// Example 7: Ellipses
example_ellipses :: proc ( ) {
    
    fmt.println( "=== EXAMPLE 7: ELLIPSES ===\n" )
    
    fig := plot.make_figure( )
    defer plot.destroy_figure( & fig )
    
    fig.width  = 50
    fig.height = 20
    
    X1, Y1 := plot.ellipse( 0, 0, 0.5, 0.5, 20 )
    // X1, Y1 := plot.ellipse( 0, 0, 0.45, 0.45, 20 )
    defer delete( X1 )
    defer delete( Y1 )
    plot.figure_plot( & fig, X1, Y1, nil, "Ellipse 1" )
    
    result := plot.figure_show( & fig, legend = true )
    fmt.println( result )
}

// Example 8: Multiple plots on same figure
example_multiple_plots :: proc ( ) {
    
    fmt.println( "=== EXAMPLE 8: MULTIPLE PLOTS WITH LEGEND ===\n" )
    
    N     :: 100
    X     := make( [ ]f64, N )
    Y_sin := make( [ ]f64, N )
    Y_cos := make( [ ]f64, N )
    Y_tan := make( [ ]f64, N )
    defer delete( X )
    defer delete( Y_sin )
    defer delete( Y_cos )
    defer delete( Y_tan )
    
    for i in 0 ..< N {
        
        x := f64( i ) / f64( N ) * 2 * math.PI
        X[ i ] = x
        Y_sin[ i ] = math.sin( x )
        Y_cos[ i ] = math.cos( x )
        Y_tan[ i ] = math.clamp( math.tan( x ), -2, 2 )  // Clamp tan to avoid infinities
    }
    
    fig := plot.make_figure( )
    defer plot.destroy_figure( & fig )
    
    fig.width  = 80
    fig.height = 25
    plot.figure_set_x_limits( & fig, 0, 2 * math.PI )
    plot.figure_set_y_limits( & fig, -2, 2 )
    fig.x_label = "x (radians)"
    fig.y_label = "y"
    
    plot.figure_plot( & fig, X, Y_sin, plot.Color_Name.Red, "sin(x)" )
    plot.figure_plot( & fig, X, Y_cos, plot.Color_Name.Blue, "cos(x)" )
    plot.figure_plot( & fig, X, Y_tan, plot.Color_Name.Green, "tan(x) [clamped]" )
    
    result := plot.figure_show( & fig, legend=true )
    fmt.println( result )
}
