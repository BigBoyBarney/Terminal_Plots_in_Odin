// Terminal Plots in Odin
//
// A port of plotille lib from Python to Odin.
// Github tammoippen - plotille
// https://github.com/tammoippen/plotille
//
// License
// MIT Open Source License


package terminal_plots

import "core:math"

// Generate ellipse points
ellipse :: proc( x_center    := 0.0,
                 y_center    := 0.0,
                 x_amplitude := 1.0,
                 y_amplitude := 1.0, 
                 n           := 100,
                 allocator   := context.allocator ) -> 
               ( X, Y : [ ]f64 ) {
                   
    context.allocator = allocator
    
    X = make( [ ]f64, n + 1 )
    Y = make( [ ]f64, n + 1 )
    
    for i in 0 ..= n {    
    // for i in 0 ..< n {
    
        angle := f64( i ) / f64( n ) * 2 * math.PI
        X[ i ] = x_center + x_amplitude * math.cos( angle )
        Y[ i ] = y_center + y_amplitude * math.sin( angle )
    }
    
    return X, Y
}

// Generate circle points ( ellipse with equal amplitudes )
circle :: proc ( x_center  := 0.0,
                 y_center  := 0.0,
                 radius    := 1.0,
                 n         := 100,
                 allocator := context.allocator ) -> 
               ( X, Y : [ ]f64 ) {
                   
    return ellipse( x_center, y_center, radius, radius, n, allocator )
}
