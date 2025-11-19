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
import plot "../terminal_plots"

main :: proc ( ) {
    
    // Create corner nodes
    nodes := make( [ dynamic ][ 2 ]f64 )
    defer delete( nodes )
    
    append( & nodes, [ 2 ]f64{ 0, 0 })
    append( & nodes, [ 2 ]f64{ 9, 0 })
    append( & nodes, [ 2 ]f64{ 0, 9 })
    append( & nodes, [ 2 ]f64{ 9, 9 })
    
    // Add 10 random nodes
    for i in 0 ..< 10 {
        
        x := f64( rand.int31( ) % 10 )
        y := f64( rand.int31( ) % 10 )
        append( & nodes, [ 2 ]f64{ x, y } )
    }
    
    // Create 5 random edges
    edges := make( [ dynamic ][ 2 ]int )
    defer delete( edges )
    
    for i in 0 ..< 5 {
        
        from := int( rand.int31( ) ) % len( nodes )
        to   := int( rand.int31( ) ) % len( nodes )
        if from == to {
            
            to = ( from + 1 ) % len( nodes )
        }
        append( & edges, [ 2 ]int{ from, to } )
    }
    
    // Create canvas with size 50x20 and coordinate range 0-10
    canvas := plot.make_canvas( 50, 20, 0, 0, 10, 10, nil, .Names )
    defer plot.destroy_canvas( & canvas)
    
    // Draw all nodes as 'x' markers
    for node in nodes {
        
        plot.canvas_point( & canvas, node.x, node.y, true, nil, 'x' )
    }
    
    // Draw edges as lines
    for edge in edges {
        
        from_node := nodes[ edge[ 0 ] ]
        to_node := nodes[ edge[ 1 ] ]
        plot.canvas_line( & canvas, from_node.x, from_node.y, to_node.x, to_node.y, true, nil )
    }
    
    // Plot the canvas
    result := plot.canvas_plot( & canvas )
    fmt.println( result )
}
