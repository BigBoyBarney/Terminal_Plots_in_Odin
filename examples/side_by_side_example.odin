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
import "core:strings"
import "core:unicode/utf8"
import plot "../terminal_plots"

main :: proc ( ) {
    
    // Generate data: x from 0 to 1
    N :: 100
    x := make( [ ]f64, N )
    defer delete( x )
    
    for i in 0 ..< N {
        
        x[ i ] = f64( i ) / f64( N - 1 )
    }
    
    rows    := 5
    columns := 40
    
    // Plot 1: y = 2 * x ( linear )
    y1 := make( [ ]f64, N )
    defer delete( y1 )
    for i in 0 ..< N {
        
        y1[ i ] = 2.0 * x[ i ]
    }
    
    y1_min := y1[ 0 ]
    y1_max := y1[ len( y1 ) - 1 ]
    
    plot1 := plot.plot_with_limits( x, y1, columns, rows, "x", "T", 
                                    0, 1, y1_min, y1_max, 
                                    plot.color_from_name( "red" ) )
    
    // Plot 2: y = exp( -x ) ( exponential decay )
    y2 := make( [ ]f64, N )
    defer delete( y2 )
    for i in 0 ..< N {
        
        y2[ i ] = math.exp( -x[ i ] )
    }
    
    y2_max := y2[ 0 ]
    y2_min := y2[ len( y2 ) - 1 ]
    
    plot2 := plot.plot_with_limits( x, y2, columns, rows, "t", "T",
                                    0, 1, y2_min, y2_max,
                                    plot.color_from_name( "green" ) )
    
    // Print plots separately first
    fmt.println( plot1 )
    fmt.println( plot2 )
    fmt.println( )
    
    // Now combine plots side by side
    lines1 := strings.split( plot1, "\n" )
    lines2 := strings.split( plot2, "\n" )
    defer delete( lines1 )
    defer delete( lines2 )


    // Apply extend_plot_lines to each plot
    extend_lines :: proc( lines : [ ]string ) -> 
                          [ ]string {
        
        result := make( [ ]string, len( lines ) )
        max_line_size := 0
        for i in 0 ..< len( lines ) {
            
            len_line_runes := utf8.rune_count( lines[ i ] )
            // fmt.printfln( "len_line_runes : %d, [%s], max : %d", len_line_runes, lines[ i ], max_line_size )
            max_line_size_2 := max( max_line_size, len_line_runes )
            
            if max_line_size_2 < 100 {
                
               max_line_size = max_line_size_2 
            }
        }
        
        
        for i in 0 ..< len( lines ) {
            
            len_line_runes := utf8.rune_count( lines[ i ] );
            delta := max_line_size - len_line_runes
           
            if delta >= 0 {
                
                result[ i ] = strings.concatenate( { lines[ i ], strings.repeat( " ", delta ) } )    
            } else {
                
                result[ i ] = strings.concatenate( { lines[ i ], strings.repeat( " ", 9 ) } )
            }
            
        }
        return result
    }
    
    lines1_extended  := extend_lines( lines1 )
    lines2_extended  := extend_lines( lines2 )
    
    
    // Print side by side
    max_len := max( len( lines1_extended ), len( lines2_extended ) )
    
    for i in 0 ..< max_len {
        // Get line from each plot or empty string
        
        h := i < len( lines1_extended ) ? lines1_extended[ i ] : ""
        p := i < len( lines2_extended ) ? lines2_extended[ i ] : ""
        
        fmt.println( h, " ", p )
    }
    
    fmt.println("\n")

}
