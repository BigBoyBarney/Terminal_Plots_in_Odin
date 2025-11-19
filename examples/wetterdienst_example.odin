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
import "core:encoding/json"
import "core:os"
import "core:strings"
import "core:slice"
import plot "../terminal_plots"

// Simplified regression calculation
regression :: proc ( x : [ ]f64,
                     y : [ ]f64 ) -> 
                   ( m : f64,
                     b : f64 ) {
                         
    n := f64( len( x ) )
    if n == 0 do return 0, 0
    
    sum_x  : f64 = 0
    sum_xx : f64 = 0
    sum_y  : f64 = 0
    sum_xy : f64 = 0
    
    for i in 0 ..< len( x ) {
        
        sum_x  += x[ i ]
        sum_xx += x[ i ] * x[ i ]
        sum_y  += y[ i ]
        sum_xy += x[ i ] * y[ i ]
    }
    
    m = ( n * sum_xy - sum_x * sum_y ) / ( n * sum_xx - sum_x * sum_x )
    b = ( sum_y - m * sum_x ) / n
    
    return m, b
}

main :: proc ( ) {
    
    fmt.println( "\nWetterdienst Example (Simplified)" )
    fmt.println( "==================================\n" )
    fmt.println( "Note: This is a simplified version of the Python example." )
    fmt.println( "The full example requires parsing compressed JSON data from" )
    fmt.println( "the German Weather Service (Deutscher Wetterdienst).\n" )
    
    // Demonstrate with synthetic temperature data
    fmt.println( "Showing synthetic temperature trend data:\n" )
    
    fig := plot.make_figure( )
    defer plot.destroy_figure( & fig )
    
    fig.width  = 120
    fig.height = 30
    plot.figure_set_x_limits( & fig, 1970, 2021 )
    plot.figure_set_y_limits( & fig, -18, 12 )
    fig.y_label = "Celsius"
    fig.x_label = "Year"
    
    // Generate synthetic data for two stations
    years            := make( [ ]f64, 51 )
    dresden_temps    := make( [ ]f64, 51 )
    schaafheim_temps := make( [ ]f64, 51 )
    defer delete( years )
    defer delete( dresden_temps )
    defer delete( schaafheim_temps )
    
    // Dresden-Klotzsche ( synthetic trend )
    for i in 0 ..< 51 {
        
        year := f64( 1970 + i )
        years[ i ] = year
        // Simulate warming trend with some variation
        dresden_temps[ i ]    = -5.0 + ( year - 1970.0 ) * 0.08 + math.sin( year * 0.5 ) * 2.0
        schaafheim_temps[ i ] = -3.0 + ( year - 1970.0 ) * 0.09 + math.cos( year * 0.7 ) * 2.5
    }
    
    // Plot Dresden data
    plot.figure_plot( & fig, years, dresden_temps, plot.color_from_rgb( 100, 150, 255 ), "Dresden-Klotzsche", 'x' )
    
    // Calculate and plot regression for Dresden
    m_d, b_d := regression( years, dresden_temps )
    reg_y_d := make( [ ]f64, 2 ) 
    reg_x := [ ]f64{ 1970, 2021 }
    defer delete( reg_y_d )
    reg_y_d[ 0 ] = m_d * 1970 + b_d
    reg_y_d[ 1 ] = m_d * 2021 + b_d
    plot.figure_plot( & fig, reg_x, reg_y_d, plot.color_from_rgb( 50, 100, 200 ), "Dresden - regression", ' ' )
    
    // Plot Schaafheim data
    plot.figure_plot( & fig, years, schaafheim_temps, plot.color_from_rgb( 100, 255, 100 ), "Schaafheim-Schlierbach", 'o' )
    
    // Calculate and plot regression for Schaafheim
    m_s, b_s := regression( years, schaafheim_temps )
    reg_y_s := make( [ ]f64, 2 )
    defer delete( reg_y_s )
    reg_y_s[ 0 ] = m_s * 1970 + b_s
    reg_y_s[ 1 ] = m_s * 2021 + b_s
    plot.figure_plot( & fig, reg_x, reg_y_s, plot.color_from_rgb( 50, 200, 50 ), "Schaafheim - regression", ' ' )
    
    fmt.println( "                    Temperature of two stations in Germany at 1. January (Synthetic Data)" )
    result := plot.figure_show( & fig, legend = true )
    fmt.println( result )
    
    fmt.println( "\nNote: To use real data, download from:" )
    fmt.println( "https://github.com/earthobservations/wetterdienst" )
}
