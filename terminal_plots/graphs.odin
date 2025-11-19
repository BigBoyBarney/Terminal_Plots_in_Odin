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

// Create a scatter plot
scatter :: proc( X          : [ ]f64,  
                 Y          : [ ]f64,
                 width      := 80,
                 height     := 40, 
                 x_label    := "X",
                 y_label    := "Y",
                 x_min      : Maybe( f64 ) = nil,
                 x_max      : Maybe( f64 ) = nil,
                 y_min      : Maybe( f64 ) = nil,
                 y_max      : Maybe( f64 ) = nil,
                 color      : Maybe( Color ) = nil,
                 background : Maybe( Color ) = nil,
                 color_mode := Color_Mode.Names,
                 origin     := true,
                 marker     : Maybe( rune ) = nil,
                 allocator  := context.allocator ) ->
                 string {
    
    context.allocator = allocator
    
    assert( len( X ) == len( Y ), "X and Y must have same length" )
    
    if len( X ) == 0 {
        
        return ""
    }
    
    // Determine limits
    x_min_val := x_min.? or_else min_slice( X )
    x_max_val := x_max.? or_else max_slice( X )
    y_min_val := y_min.? or_else min_slice( Y )
    y_max_val := y_max.? or_else max_slice( Y )
    
    // Handle case where all values are the same
    if x_min_val >= x_max_val {
        
        x_min_val -= 0.5
        x_max_val += 0.5
    }
    if y_min_val >= y_max_val {
        
        y_min_val -= 0.5
        y_max_val += 0.5
    }
    
    // Create canvas
    canvas := make_canvas( width, height,
                           x_min_val, y_min_val, x_max_val, y_max_val,
                           background, color_mode, context.temp_allocator )
    
    // Plot points
    for i in 0 ..< len( X ) {
        
        canvas_point( & canvas, X[ i ], Y[ i ], true, color, marker )
    }
    
    // Generate plot with axes
    return generate_plot( & canvas, x_label, y_label, origin )
}

// Create a line plot with interpolation
plot :: proc ( X          : [ ]f64,
               Y          : [ ]f64,
               width      := 80,
               height     := 40,
               x_label    := "X",
               y_label    := "Y",
               x_min      : Maybe( f64 ) = nil,
               x_max      : Maybe( f64 ) = nil,
               y_min      : Maybe( f64 ) = nil,
               y_max      : Maybe( f64 ) = nil,
               color      : Maybe( Color ) = nil,
               background : Maybe( Color ) = nil,
               color_mode := Color_Mode.Names, origin := true,
               marker     : Maybe( rune ) = nil,
               allocator  := context.allocator ) -> 
               string {
    
    context.allocator = allocator
    
    assert( len( X ) == len( Y ), "X and Y must have same length" )
    
    if len( X ) == 0 {
        
        return ""
    }
    
    // Determine limits
    x_min_val := x_min.? or_else min_slice( X )
    x_max_val := x_max.? or_else max_slice( X )
    y_min_val := y_min.? or_else min_slice( Y )
    y_max_val := y_max.? or_else max_slice( Y )
    
    // Handle case where all values are the same
    if x_min_val >= x_max_val {
        
        x_min_val -= 0.5
        x_max_val += 0.5
    }
    if y_min_val >= y_max_val {
        
        y_min_val -= 0.5
        y_max_val += 0.5
    }
    
    // Create canvas
    canvas := make_canvas( width, height,
                           x_min_val, y_min_val, x_max_val, y_max_val,
                           background, color_mode, context.temp_allocator )
    
    // Plot points with lines between them
    for i in 0 ..< len( X ) {
        
        if marker != nil {
            
            canvas_point( & canvas, X[ i ], Y[ i ], true, color, marker )
        }
        
        if i > 0 {
            
            canvas_line( &canvas, X[ i - 1 ], Y[ i - 1 ], X[ i ], Y[ i ], true, color )
        }
    }
    
    // Generate plot with axes
    return generate_plot( & canvas, x_label, y_label, origin )
}

// Create a plot with explicit limits
plot_with_limits :: proc ( X          : [ ]f64,
                           Y          : [ ]f64,
                           width      := 80,
                           height     := 40,
                           x_label    := "",
                           y_label    := "",
                           x_min      : f64,
                           x_max      : f64,
                           y_min      : f64,
                           y_max      : f64,
                           color      : Maybe( Color ) = nil,
                           marker     : Maybe( rune ) = nil,
                           background : Maybe( Color ) = nil,
                           color_mode := Color_Mode.Names,
                           origin     := true ) -> 
                           string {
    
    // Create canvas with specified limits
    canvas := make_canvas( width, height,
                           x_min, y_min, x_max, y_max,
                           background, color_mode, context.temp_allocator )
    
    // Plot points with lines between them
    for i in 0 ..< len( X ) {
        
        if marker != nil {
            
            canvas_point( & canvas, X[ i ], Y[ i ], true, color, marker )
        }
        
        if i > 0 {
            
            canvas_line( & canvas, X[ i - 1 ], Y[ i - 1 ], X[ i ], Y[ i ], true, color )
        }
    }
    
    // Generate plot with axes
    return generate_plot( & canvas, x_label, y_label, origin )
}

// Create a histogram (vertical orientation)
histogram :: proc ( X          : [ ]f64,
                    bins       := 160,
                    width      := 80,
                    height     := 40,
                    x_label    := "X",
                    y_label    := "Counts",
                    x_min      : Maybe( f64 ) = nil,
                    x_max      : Maybe( f64 ) = nil,
                    y_min      : Maybe( f64 ) = nil,
                    y_max      : Maybe( f64 ) = nil,
                    color      : Maybe( Color ) = nil,
                    background : Maybe( Color ) = nil,
                    color_mode := Color_Mode.Names,
                    allocator  := context.allocator ) -> 
                    string {
    
    context.allocator = allocator
    
    if len( X ) == 0 {
        
        return ""
    }
    
    // Compute histogram  
    counts, bin_edges := histogram_data( X, bins, allocator )
    defer delete( counts, allocator )
    defer delete( bin_edges, allocator )
    
    // Determine x limits
    x_min_val := x_min.? or_else bin_edges[ 0 ]
    x_max_val := x_max.? or_else bin_edges[ len( bin_edges ) - 1 ]
    
    // Determine y limits
    max_count := max_slice_int( counts )
    y_min_val := y_min.? or_else 0.0
    y_max_val := y_max.? or_else f64( max_count )
    
    if y_max_val <= y_min_val {
        
        y_max_val = y_min_val + 1.0
    }
    
    // Create canvas
    canvas := make_canvas( width, height,
                           x_min_val, y_min_val, x_max_val, y_max_val,
                           background, color_mode, context.temp_allocator )
    
    // Plot histogram bars
    for i in 0 ..< len( counts ) {
        
        if counts[ i ] > 0 {
            
            x_center := ( bin_edges[ i ] + bin_edges[ i + 1 ] ) / 2.0
            // Draw vertical line from 0 to count
            canvas_line( & canvas, x_center, 0, x_center, f64( counts[ i ] ), true, color )
        }
    }
    
    return generate_plot( & canvas, x_label, y_label, true )
}

// Create horizontal histogram
hist :: proc ( X          : [ ]f64,
               bins       := 40,
               width      := 80, 
               log_scale  := false,
               color      : Maybe( Color ) = nil,
               background : Maybe( Color ) = nil,
               color_mode := Color_Mode.Names,
               allocator  := context.allocator ) -> 
               string {
    
    context.allocator = allocator
    
    if len( X ) == 0 {
        
        return ""
    }
    
    // Compute histogram with main allocator
    counts, bin_edges := histogram_data( X, bins, allocator )
    defer delete( counts, allocator )
    defer delete( bin_edges, allocator )
    
    return hist_aggregated( counts, bin_edges, width, log_scale,
                            color, background, color_mode, allocator)
}

// Create histogram from pre-aggregated data
hist_aggregated :: proc ( counts     : [ ]int,
                          bins       : [ ]f64,
                          width      := 80,
                          log_scale  := false,
                          color      : Maybe( Color ) = nil,
                          background : Maybe( Color ) = nil,
                          color_mode := Color_Mode.Names,
                          allocator  := context.allocator ) -> 
                          string {
    
    context.allocator = allocator
    
    assert( len( bins ) == len( counts ) + 1, "bins must have len( counts ) + 1 elements" )
    
    scale :: proc ( a         : int,
                    log_scale : bool ) -> 
                    f64 {
                        
        if log_scale && a > 0 {
            
            return math.ln( f64( a ) )
        }
        return f64( a )
    }
    
    max_count := max_slice_int( counts )
    h_max := scale( max_count, log_scale )
    if h_max == 0 {
        
        h_max = 1
    }
    
    delta := bins[ len( bins ) - 1 ] - bins[ 0 ]
    
    builder := strings.builder_make( allocator )
    
    // Header
    strings.write_string( & builder, "        bucket       | " )
    strings.write_rune( & builder, '_' )
    for i in 1 ..< width {
        
        strings.write_rune( & builder, '_' )
    }
    strings.write_string( & builder, " Total Counts\n" )
    
    // Braille characters for partial fills
    lasts := [ ]rune{ ' ', '⠂', '⠆', '⠇', '⡇', '⡗', '⡷', '⣿' }
    
    // Plot each bin
    for i in 0 ..< len( counts ) {
        
        height := int( f64( width * 8 ) * scale( counts[ i ], log_scale ) / h_max )
        
        // Format bin range
        bin_start := format_number( bins[ i ], 8 )
        bin_end   := format_number( bins[ i + 1 ], 8 )
        
        strings.write_string( & builder, fmt.tprintf( "[%s, %s) | ", bin_start, bin_end ) )
        
        // Draw bar
        full_chars := height / 8
        remainder := height % 8
        
        // Full braille characters
        bar_text := strings.builder_make( context.temp_allocator )
        for j in 0 ..< full_chars {
            
            strings.write_rune( & bar_text, '⣿' )
        }
        
        // Partial character
        if remainder > 0 && full_chars < width {
            
            strings.write_rune( & bar_text, lasts[ remainder ] )
        }
        
        // Empty space
        empty_count := width - full_chars
        if remainder > 0 {
            
            empty_count -= 1
        }
        for j in 0 ..< empty_count {
            
            strings.write_rune( & bar_text, '⠀' )
        }
        
        bar_str := strings.to_string( bar_text )
        colored_bar := apply_color( bar_str, color, background, color_mode )
        strings.write_string( & builder, colored_bar )
        
        strings.write_string( & builder, fmt.tprintf( " %d\n", counts[ i ] ) )
    }
    
    // Footer
    for i in 0 ..< ( 2 * 8 + 2 + 3 + width + 12 ) {
        strings.write_rune( & builder, '‾' )
    }
    strings.write_rune( & builder, '\n' )
    
    return strings.to_string( builder )
}

// Helper to generate plot with axes
// Format a number for tick display
format_tick :: proc ( value : f64,
                      delta : f64,
                      chars := 10,
                      left  := false ) -> 
                      string {
                          
    abs_delta := abs( delta )
    
    // Choose appropriate decimal places based on range
    decimals := 2
    if abs_delta > 0 {
        
        if abs_delta >= 100 {
        
            decimals = 0
        } else if abs_delta >= 10 {
        
            decimals = 1
        } else if abs_delta >= 1 {
        
            decimals = 2
        } else if abs_delta >= 0.01 {
        
            decimals = 4
        } else {
        
            decimals = 6
        }
    }
    
    // Format number with proper precision
    formatted := fmt.tprintf( "%.*f", decimals, value )
    
    // Pad to the specified width
    if left {
        
        // Left-aligned: pad on the right
        for len( formatted ) < chars {
            
            formatted = strings.concatenate( { formatted, " " } )
        }
    } else {
        
        // Right-aligned: pad on the left
        for len( formatted ) < chars {
            
            formatted = strings.concatenate( { " ", formatted } )
        }
    }
    
    return formatted
}

generate_plot :: proc ( canvas : ^Canvas,
                        x_label : string,
                        y_label : string,
                        origin  : bool ) ->
                        string {
    
    builder := strings.builder_make( context.allocator )
    
    // Get canvas plot
    plot_str := canvas_plot( canvas, "\n", context.temp_allocator )
    plot_lines := strings.split( plot_str, "\n", context.temp_allocator )
    
    // Generate Y-axis ticks
    ymin := canvas.ymin
    ymax := canvas.ymax
    delta_y := abs( ymax - ymin )
    y_delta := delta_y / f64( canvas.height )
    
    // Create Y-axis tick labels ( bottom to top )
    y_ticks := make( [ ]string, canvas.height + 1, context.temp_allocator )
    for i in 0 ..= canvas.height {
        
        value := f64( i ) * y_delta + ymin
        y_ticks[ i ] = format_tick( value, delta_y )
    }
    
    // Reverse to match plot order ( top to bottom )
    y_ticks_reversed := make( [ ]string, len( y_ticks ), context.temp_allocator )
    for i in 0 ..< len( y_ticks ) {
        
        y_ticks_reversed[ i ] = y_ticks[ len( y_ticks ) - 1 - i ]
    }
    
    // Add y-axis label at top
    y_label_str := fmt.tprintf( "(%s)", y_label if len( y_label ) > 0 else "Y" )
    y_label_left := ( 10 - len( y_label_str ) ) / 2
    y_label_right := y_label_left + len( y_label_str ) % 2
    
    // Write Y-label line with arrow
    strings.write_string( & builder, strings.repeat( " ", y_label_left ) )
    strings.write_string( & builder, y_label_str)
    strings.write_string( & builder, strings.repeat( " ", y_label_right ) )
    strings.write_string( & builder, " ^\n" )
    
    // Write max value line
    if len( y_ticks_reversed ) > 0 {
        
        strings.write_string( & builder, fmt.tprintf( "%s |\n", y_ticks_reversed[ 0 ] ) )
    }
    
    // Write canvas lines with Y-ticks
    // for i in 0 ..< len( plot_lines ) {
    for i in 0 ..< len( plot_lines ) - 1 {
        tick_idx := i + 1
        if tick_idx < len( y_ticks_reversed ) {
            
            strings.write_string( & builder, fmt.tprintf( "%s | %s\n", y_ticks_reversed[ tick_idx ], plot_lines[ i ] ) )
        } else {
            
            strings.write_string( & builder, plot_lines[ i ] )
            strings.write_string( & builder, "\n" )
        }
    }
    
    // Add x-axis with ticks
    if origin {
        
        // Create X-axis line like Python: "-----------|-" + "|---------|" * ( width // 10 ) + ...
        strings.write_string( & builder, "-----------|-" )
        
        // Add full 10-char blocks
        for i in 0 ..< canvas.width / 10 {
            
            // strings.write_string( & builder, "|---------|" )
            strings.write_string( & builder, "|---------" )
        }
        
        // Add remaining chars
        if canvas.width % 10 > 0 {
            
            strings.write_string( & builder, "|" )
            strings.write_string( & builder, strings.repeat( "-", canvas.width % 10 ) )
        }
        
        x_label_str := fmt.tprintf( "-> (%s)", x_label if len( x_label ) > 0 else "X" )
        strings.write_string( & builder, x_label_str )
        strings.write_string( & builder, "\n" )
        
        // Create X-axis tick values
        delta_x := abs( canvas.xmax - canvas.xmin )
        x_delta := delta_x / f64( canvas.width )
        
        strings.write_string( & builder, "           | " )
        for i in 0 ..= canvas.width / 10 {
            
            value    := f64( i * 10 ) * x_delta + canvas.xmin
            tick_str := format_tick( value, delta_x, 9, true )
            strings.write_string(&builder, tick_str)
            if i < canvas.width / 10 {
                
                strings.write_string( & builder, " " )
            }
        }
        strings.write_string( & builder, "\n" )
    }
    
    return strings.to_string( builder )
}

// Helper functions
min_slice :: proc ( s : [ ]f64 ) -> 
                    f64 {
                       
    if len( s ) == 0 do return 0
    m := s[ 0 ]
    for v in s[ 1 : ] {
        
        m = min( m, v )
    }
    return m
}

max_slice :: proc ( s : [ ]f64 ) ->
                    f64 {
                       
    if len( s ) == 0 do return 1
    m := s[ 0 ]
    for v in s[ 1 : ] {
        
        m = max( m, v )
    }
    // return m
    // return m * 1.05
    return m * 1.02
}

max_slice_int :: proc ( s : [ ]int ) ->
                        int {
                            
    if len( s ) == 0 do return 0
    m := s[ 0 ]
    for v in s[ 1 : ] {
        
        m = max( m, v )
    }
    return m
}
