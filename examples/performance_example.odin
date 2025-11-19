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
import "core:math/rand"
import "core:time"
import plot "../terminal_plots"

main :: proc ( ) {
    
    // Generate random data
    N :: 1000
    y := make( [ ]f64, N )
    x := make( [ ]f64, N )
    defer delete( y )
    defer delete( x )
    
    for i in 0 ..< N {
        
        y[ i ] = rand.float64( )
        x[ i ] = f64( i )
    }
    
    // Time 100 plot generations
    start := time.now( )
    for i in 0 ..< 100 {
        result := plot.plot( x, y, 60, 30, "x", "y" )
        delete( result )
    }
    duration := time.since( start )
    
    fmt.printf( "Took %.3f sec\n", time.duration_seconds( duration ) )
}
