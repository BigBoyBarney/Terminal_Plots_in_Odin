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
import "core:strings"
import "core:unicode/utf8"

import plot "../terminal_plots"

main :: proc ( ) {
    
    width  := 12
    height := 10
    spacer := " "
    
    // Generate normal distribution data (10,000 points)
    N :: 10000
    X_data := make( [ ]f64, N )
    defer delete( X_data )
    
    for i in 0 ..< N {
        
        // Box-Muller transform for normal distribution
        u1 := rand.float64( )
        u2 := rand.float64( )
        X_data[ i ] = math.sqrt( -2.0 * math.ln( u1 ) ) * math.cos( 2.0 * math.PI * u2 )
    }
    
    fmt.println( "\n\nNote: Image logo display not available." )
    fmt.println( "Showing 4 side-by-side plots instead:\n" )
    
    // Plot 1: Histogram ( vertical )
    fig_hist       := plot.make_figure( )
    fig_hist.width  = width
    fig_hist.height = height
    plot.figure_histogram( & fig_hist, X_data, 160, plot.color_from_rgb( 255, 150, 100 ), "" )
    hist_str := plot.figure_show( & fig_hist, legend = false )
    plot.destroy_figure( & fig_hist )
    
    // Plot 2: Scatter plot with line
    fig_plot       := plot.make_figure( )
    fig_plot.width  = width
    fig_plot.height = height
    plot.figure_set_y_limits( & fig_plot, -2, 2 )
    
    // Random scatter points
    x_scatter := make( [ ]f64, 10 )
    y_scatter := make( [ ]f64, 10 )
    defer delete( x_scatter )
    defer delete( y_scatter )
    
    for i in 0 ..< 10 {
        
        u1 := rand.float64( )
        u2 := rand.float64( )
        x_scatter[ i ] = f64( i )
        y_scatter[ i ] = math.sqrt( -2.0 * math.ln( u1 ) ) * math.cos( 2.0 * math.PI * u2 )
    }
    
    plot.figure_scatter( & fig_plot, x_scatter, y_scatter,
                         plot.color_from_rgb(100, 200, 100), "", 'o' )
    
    // Add a line
    line_x := [ ]f64{ 0, 9 }
    line_y := [ ]f64{ 2, 0 }
    plot.figure_plot( & fig_plot, line_x, line_y, plot.color_from_rgb( 150, 150, 255 ), "", 'x' )
    
    // Add sine wave
    sine_x := make( [ ]f64, 20 )
    sine_y := make( [ ]f64, 20 )
    defer delete(sine_x)
    defer delete(sine_y)
    for i in 0 ..< 20 {
        sine_x[ i ] = f64(i) * 9.0 / 19.0
        sine_y[ i ] = 0.25 * math.sin( sine_x[ i ] ) - 1.0
    }
    plot.figure_plot( & fig_plot, sine_x, sine_y, plot.color_from_rgb( 200, 200, 100 ), "", ' ' )
    
    plot_str := plot.figure_show( & fig_plot, legend = false )
    plot.destroy_figure( & fig_plot )
    
    // Plot 3: Heat map ( just a figure with circle )
    fig_heat       := plot.make_figure( )
    fig_heat.width  = width
    fig_heat.height = height
    plot.figure_set_y_limits( & fig_heat, -2, 2 )
    plot.figure_set_x_limits( & fig_heat, -2, 2 )
    fig_heat.origin = false
    
    // Draw circle
    circle_pts := 100
    circle_x   := make( [ ]f64, circle_pts )
    circle_y   := make( [ ]f64, circle_pts )
    defer delete( circle_x )
    defer delete( circle_y )
    
    for i in 0 ..< circle_pts {
        
        angle := f64( i ) * 2.0 * math.PI / f64( circle_pts )
        circle_x[ i ] = 1.5 * math.cos( angle )
        circle_y[ i ] = 1.5 * math.sin( angle )
    }
    plot.figure_plot( & fig_heat, circle_x, circle_y, plot.color_from_rgb( 200, 100, 200 ), "", ' ' )
    
    heat_str := plot.figure_show( & fig_heat, legend = false )
    plot.destroy_figure( & fig_heat )
    
    // Plot 4: Simple horizontal histogram
    hist_h := plot.hist( X_data, 12, 12, false, plot.color_from_rgb( 180, 100, 220 ) )
    
    // Split all plots into lines
    hist_lines := strings.split( hist_str, "\n" )
    plot_lines := strings.split( plot_str, "\n" )
    heat_lines := strings.split( heat_str, "\n" )
    histh_lines := strings.split( hist_h, "\n" )
    defer delete( hist_lines )
    defer delete( plot_lines )
    defer delete( heat_lines )
    defer delete( histh_lines )
    
    
    // Apply extend_plot_lines to each plot 
    // Adds trailing spaces: 20 for first / last 2 lines, 7 for middle lines
    extend_lines :: proc ( lines : [ ]string ) -> 
                           [ ]string {
        
        result := make( [ ]string, len( lines ) )
        max_line_size := 0
        for i in 0 ..< len( lines ) {
            
            len_line_runes := utf8.rune_count( lines[ i ] )
            // fmt.printfln( "len_line_runes : %d, [%s], max : %d", len_line_runes, lines[ i ], max_line_size )
            max_line_size = max( max_line_size, len_line_runes )
        }
        
        for i in 0 ..< len( lines ) {
            
            len_line_runes := utf8.rune_count( lines[ i ] );
            delta := max_line_size - len_line_runes 
            result[ i ] = strings.concatenate( { lines[ i ], strings.repeat( " ", delta ) } )
        }
        return result
    }
    
    hist_extended  := extend_lines( hist_lines )
    plot_extended  := extend_lines( plot_lines )
    heat_extended  := extend_lines( heat_lines )
    histh_extended := extend_lines( histh_lines )

    // Print side by side.    
    max_len := max( len( hist_extended ), len( plot_extended ), len( heat_extended ), len( histh_extended ) )
    
    for i in 0..<max_len {
        
        // Get line from each plot or empty string
        
        h := i < len( hist_extended ) ? hist_extended[ i ] : ""
        p := i < len( plot_extended ) ? plot_extended[ i ] : ""
        // t := i < len( heat_extended ) ? heat_extended[ i ] : ""
        hh := i < len( histh_extended ) ? histh_extended[ i ] : ""
        
        // fmt.println( h, " ", p, " ", t, " ", hh )
        fmt.println( h, " ", p, " ", hh )
    }
    
    
    fmt.println( "\n" )

}
