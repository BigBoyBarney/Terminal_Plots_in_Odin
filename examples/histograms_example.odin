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
import plot "../terminal_plots"

main :: proc ( ) {
    // Generate normal distribution data
    N :: 10000
    data := make( [ ]f64, N )
    defer delete( data )
    
    // Box-Muller transform for normal distribution
    for i in 0 ..< N/2 {
        u1 := rand.float64( )
        u2 := rand.float64( )
        
        r := math.sqrt( -2.0 * math.ln( u1 ) )
        theta := 2.0 * math.PI * u2
        
        data[ 2 * i ] = r * math.cos( theta )
        data[ 2 * i + 1 ] = r * math.sin( theta )
    }
    
    fmt.println( "Histogram left to right" )
    result := plot.hist( data )
    fmt.println( result )
    
    fmt.println( "\nHistogram rotated" )
    result2 := plot.histogram( data )
    fmt.println( result2 )
}
