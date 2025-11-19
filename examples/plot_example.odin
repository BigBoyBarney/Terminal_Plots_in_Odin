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

main :: proc() {
    
    // Create X values from 0 to 2 * PI
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
