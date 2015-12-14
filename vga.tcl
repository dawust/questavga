proc rgb2 {r g b} {format #%02x%02x%02x $r $g $b}
proc vga {{xsize 640} {ysize 480} {sig tb_top/uut/vga_inst/buf/fb1/RAM}} {
    set maxvalue 15
    set factor [expr 255 / $maxvalue]
    destroy .vga
    toplevel .vga
    canvas .vga.canvas -width $xsize -height $ysize -bg white
    image create photo .data
    for {set y 0} {$y<$ysize} {incr y} {
                #vga module starts with address 1
               set start [expr ($y*$xsize) + 1]
               set end [expr ($y+1)*$xsize]
               set row [eval "examine -radix unsigned { $sig ($end downto $start) }" ]
               for {set x 0} {$x<$xsize} {incr x} {
                    set value [lindex {*}$row [expr $xsize - 1 - $x]]
                    if {$value eq "X"} {                 
                    .data put [rgb2 255 0 0] -to $x $y
                    } {
                    set r [expr (($value >> 8) & 15) * $factor]
                    set g [expr (($value >> 4) & 15) * $factor]
                    set b [expr (($value >> 0) & 15) * $factor]
                    .data put [rgb2 $r $g $b] -to $x $y
                    }
               }
    }
    .vga.canvas create image 0 0 -anchor nw -image .data
    pack .vga.canvas
}
