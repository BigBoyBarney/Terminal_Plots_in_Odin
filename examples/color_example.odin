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
import "core:os"
import plot "../terminal_plots"

main :: proc ( ) {
    
    fmt.println( "=== Color Examples ===\n" )
    
    // No color
    text := plot.apply_color( "Do not print colors, if no_color is set to True", 
                              plot.Color_Name.Red, nil, .Names, true )
    fmt.println( text )
    
    // Foreground color
    text = plot.apply_color( "You can set a foreground", plot.Color_Name.Red )
    fmt.println( text )
    
    // Background color
    text = plot.apply_color( "and a background.", nil, plot.Color_Name.Red )
    fmt.println( text )
    
    // Both
    text = plot.apply_color( "Or both.", plot.Color_Name.Black, plot.Color_Name.Cyan )
    fmt.println( text )
    
    fmt.println( )
    
    // Named colors
    text = plot.apply_color( "Aside from 4-bit / name colors", plot.Color_Name.Green, nil, .Names )
    fmt.println( text )
    
    // 8-bit colors
    text = plot.apply_color( "you can also set 8-bit colors / 256-color lookup tables", 
                             u8( 126 ), u8( 87 ), .Byte )
    fmt.println( text )
    
    // RGB colors
    rgb_fg := plot.RGB_Color{ 50, 50, 50 }
    rgb_bg := plot.RGB_Color{ 166, 237, 240 }
    text = plot.apply_color( "or go with full 24-bit rgb colors", rgb_fg, rgb_bg, .RGB )
    fmt.println( text )
    
    fmt.println( )
    
    // NO_COLOR environment variable test
    old_no_color := os.get_env( "NO_COLOR" )
    os.set_env( "NO_COLOR", "1" )
    text = plot.apply_color( "The Environment variable NO_COLOR will always strip colors.", 
                             plot.Color_Name.Red )
    fmt.println( text )
    
    // Restore NO_COLOR
    if old_no_color != "" {
        
        os.set_env( "NO_COLOR", old_no_color )
    } else {
        
        os.unset_env( "NO_COLOR" )
    }
    
    // FORCE_COLOR tests
    old_force := os.get_env( "FORCE_COLOR" )
    os.set_env( "FORCE_COLOR", "1" )
    text = plot.apply_color( "The Environment variable FORCE_COLOR allows to toggle colors,", 
                             plot.Color_Name.Blue )
    fmt.println( text )
    
    os.set_env( "FORCE_COLOR", "0" )
    text = plot.apply_color( "setting it to 0, none or false, strips color codes", 
                             plot.Color_Name.Magenta )
    fmt.println( text )
    
    os.set_env( "FORCE_COLOR", "1" )
    text = plot.apply_color( "everything else forces color codes", plot.Color_Name.Green )
    fmt.println( text )
    
    // Restore FORCE_COLOR
    if old_force != "" {
        
        os.set_env( "FORCE_COLOR", old_force )
    } else {
        
        os.unset_env( "FORCE_COLOR" )
    }
}
