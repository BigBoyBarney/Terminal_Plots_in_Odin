// Terminal Plots in Odin
//
// A port of plotille lib from Python to Odin.
// Github tammoippen - plotille
// https://github.com/tammoippen/plotille
//
// License
// MIT Open Source License


package terminal_plots

import "core:fmt"
import "core:math"
import "core:strings"

// Canvas for plotting braille dots
// A canvas has width x height characters, with 2x4 dots per character
// Total dots: width * 2 x height * 4
Canvas :: struct {
    
    width      : int,
    height     : int,
    xmin       : f64,
    xmax       : f64,
    ymin       : f64,
    ymax       : f64,
    x_delta_pt : f64,  // x value between one dot
    y_delta_pt : f64,  // y value between one dot
    color_mode : Color_Mode,
    background : Maybe( Color ),
    canvas     : [ ][ ]Dots,  // [height][width]
}

make_canvas :: proc ( width      : int,
                      height     : int,
                      xmin       := 0.0,
                      ymin       := 0.0,
                      xmax       := 1.0,
                      ymax       := 1.0,
                      background : Maybe( Color ) = nil,
                      color_mode := Color_Mode.Names, 
                      allocator  := context.allocator ) ->
                      Canvas {
                         
    context.allocator = allocator
    
    assert( width > 0, "width must be positive" )
    assert( height > 0, "height must be positive" )
    assert( xmin < xmax, "xmin must be less than xmax" )
    assert( ymin < ymax, "ymin must be less than ymax" )
    
    // Allocate canvas grid
    canvas := make( [ ][ ]Dots, height )
    for i in 0 ..< height {
        
        canvas[ i ] = make( [ ]Dots, width )
        for j in 0 ..< width {
            
            canvas[ i ][ j ] = make_dots( bg = background, color_mode = color_mode )
        }
    }
    
    return Canvas{
        
        width      = width,
        height     = height,
        xmin       = xmin,
        xmax       = xmax,
        ymin       = ymin,
        ymax       = ymax,
        x_delta_pt = math.abs( ( xmax - xmin ) / f64( width * 2 ) ),
        y_delta_pt = math.abs( ( ymax - ymin ) / f64( height * 4 ) ),
        color_mode = color_mode,
        background = background,
        canvas     = canvas,
    }
}

destroy_canvas :: proc ( c : ^Canvas ) {
    
    for row in c.canvas {
        
        delete( row )
    }
    delete( c.canvas )
}

// Transform reference x coordinate to canvas coordinate
canvas_transform_x :: proc ( c : ^Canvas,
                             x : f64 ) -> 
                             int {
                                 
    return int( round_even( ( x - c.xmin ) / c.x_delta_pt ) )
}

// Transform reference y coordinate to canvas coordinate
// In terminal display : row 0 is at top ( ymax ), last row is at bottom ( ymin )
// So we need to invert : high Y values map to low row indices ( top of screen )
canvas_transform_y :: proc ( c : ^Canvas,
                             y : f64 ) -> 
                             int {
                                
    y_from_bottom := int( round_even( ( y - c.ymin ) / c.y_delta_pt ) )
    total_dots := c.height * 4
    return total_dots - 1 - y_from_bottom
}

// Set a dot at canvas coordinates (internal)
canvas_set :: proc ( c      : ^Canvas,
                     x_idx  : int,
                     y_idx  : int,
                     set    := true,
                     color  : Maybe( Color ) = nil, 
                     marker : Maybe( rune ) = nil ) {
    
    x_c := x_idx / 2
    x_p := x_idx % 2
    y_c := y_idx / 4
    y_p := y_idx % 4
    
    if x_c >= 0 && x_c < c.width && y_c >= 0 && y_c < c.height {
        
        dots_update( & c.canvas[ y_c ][ x_c ], x_p, y_p, set, marker )
        
        if col, ok := color.?; ok {
            
            if set {
                
                c.canvas[ y_c ][ x_c ].fg = col
            } else if fg, has_fg := c.canvas[ y_c ][ x_c ].fg.?; has_fg {
                
                // Only clear if color matches
                switch col_val in col {
                
                case Color_Name:
                
                    if fg_name, ok2 := fg.( Color_Name ); ok2 && fg_name == col_val {
                
                        c.canvas[ y_c ][ x_c ].fg = nil
                    }
                case u8:
                    
                    if fg_byte, ok2 := fg.( u8 ); ok2 && fg_byte == col_val {
                        
                        c.canvas[ y_c ][ x_c ].fg = nil
                    }
                case RGB_Color:
                    
                    if fg_rgb, ok2 := fg.( RGB_Color ); ok2 && 
                       fg_rgb.r == col_val.r && fg_rgb.g == col_val.g && fg_rgb.b == col_val.b {
                           
                        c.canvas[ y_c ][ x_c ].fg = nil
                    }
                }
            }
        }
    }
}

// Plot a point at reference coordinates
canvas_point :: proc ( c      : ^Canvas,
                       x      : f64,
                       y      : f64,
                       set    := true,
                       color  : Maybe( Color ) = nil, 
                       marker : Maybe( rune ) = nil ) {
                           
    x_idx := canvas_transform_x( c, x )
    y_idx := canvas_transform_y( c, y )
    canvas_set( c, x_idx, y_idx, set, color, marker )
}

// Plot a line between two points
canvas_line :: proc ( c     : ^Canvas,
                      x0    : f64,
                      y0    : f64,
                      x1    : f64,
                      y1    : f64,
                      set   := true,
                      color : Maybe( Color ) = nil ) {
                          
    x0_idx := canvas_transform_x( c, x0 )
    y0_idx := canvas_transform_y( c, y0 )
    canvas_set( c, x0_idx, y0_idx, set, color )
    
    x1_idx := canvas_transform_x( c, x1 )
    y1_idx := canvas_transform_y( c, y1 )
    canvas_set( c, x1_idx, y1_idx, set, color )
    
    // Bresenham-like line drawing
    x_diff := x1_idx - x0_idx
    y_diff := y1_idx - y0_idx
    steps := max( abs( x_diff ), abs( y_diff ) )
    
    for i in 1 ..< steps {
        
        xb := x0_idx + int( round_even( f64( x_diff ) / f64( steps ) * f64( i ) ) )
        yb := y0_idx + int( round_even( f64( y_diff ) / f64( steps ) * f64( i ) ) )
        canvas_set( c, xb, yb, set, color )
    }
}

// Plot a rectangle
canvas_rect :: proc ( c     : ^Canvas,
                      xmin  : f64,
                      ymin  : f64,
                      xmax  : f64,
                      ymax  : f64,
                      set   := true,
                      color : Maybe( Color ) = nil ) {
    
    assert( xmin <= xmax, "xmin must be <= xmax" )
    assert( ymin <= ymax, "ymin must be <= ymax" )
    
    canvas_line( c, xmin, ymin, xmin, ymax, set, color )
    canvas_line( c, xmin, ymax, xmax, ymax, set, color ) 
    canvas_line( c, xmax, ymax, xmax, ymin, set, color )
    canvas_line( c, xmax, ymin, xmin, ymin, set, color ) 
}

// Plot text at reference coordinates
canvas_text :: proc ( c     : ^Canvas,
                      x     : f64,
                      y     : f64,
                      text  : string,
                      set   := true,
                      color : Maybe( Color ) = nil ) {
                          
    x_idx := canvas_transform_x( c, x ) / 2
    y_idx := canvas_transform_y( c, y ) / 4
    
    for ch, idx in text {
        
        if x_idx + idx >= c.width {
            
            break
        }
        
        if set {
            
            c.canvas[ y_idx ][ x_idx + idx ].marker = ch
            if col, ok := color.?; ok {
            
                c.canvas[ y_idx ][ x_idx + idx ].fg = col
            }
        } else {
            
            c.canvas[ y_idx ][ x_idx + idx ].marker = nil
            if col, ok := color.?; ok {
                
                if fg, has_fg := c.canvas[ y_idx ][ x_idx + idx ].fg.?; has_fg {
                    
                    // Clear color if matches
                    c.canvas[ y_idx ][ x_idx + idx ].fg = nil
                }
            }
        }
    }
}

// Fill entire character at position
canvas_fill_char :: proc ( c   : ^Canvas,
                           x   : f64,
                           y   : f64,
                           set := true ) {
                               
    x_idx := canvas_transform_x( c, x )
    y_idx := canvas_transform_y( c, y )
    
    x_c := x_idx / 2
    y_c := y_idx / 4
    
    if x_c >= 0 && x_c < c.width && y_c >= 0 && y_c < c.height {
        
        if set {
            
            dots_fill( & c.canvas[ y_c ][ x_c ] )
        } else {
            
            dots_clear( & c.canvas[ y_c ][ x_c ] )
        }
    }
}

// Convert canvas to string for printing
canvas_plot :: proc( c         : ^Canvas,
                     linesep   := "\n",
                     allocator := context.allocator ) -> 
                     string {
    
    context.allocator = allocator
    
    builder := strings.builder_make( 0, c.height * ( c.width + len( linesep ) ) )
    
    for row in c.canvas {
        
        for dot in row {
            
            dot_str := dots_to_string( dot, context.temp_allocator )
            strings.write_string( & builder, dot_str )
        }
        strings.write_string( & builder, linesep )
    }
    
    return strings.to_string( builder )
}

// Clear the entire canvas
canvas_clear :: proc( c : ^Canvas ) {
    
    for row in c.canvas {
        
        for &dot in row {
            
            dots_clear( & dot )
        }
    }
}
