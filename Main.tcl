#========================================================================================================
#========================================================================================================
#
#
#
#                                         Delta-Live
#
#                                   Wolfgang Suppan (©2021)
#
#
#                         auto-write soundfile player for SuperCollider
#
#
#
#========================================================================================================
#========================================================================================================

package require Tk

#========================================================================================================
#
#
#
#                                         Global Vars
#
#
#
#========================================================================================================

set app_Dir0 [ file dirname [ file normalize [ info script ] ] ]
set app_Dir "$app_Dir0/"
set curr_Dir {}
set dirtail {}
set m_data [dict create]
set folder_List {}
set sf_data_List {}

#========================================================================================================
#
#
#
#                                             Proc
#
#
#
#========================================================================================================

# -validate key -validatecommand {TestEntry_onlyZahl %S}
proc TestEntry_onlyZahl {Zeichen} {
    return [string is digit $Zeichen]
    }

# -validate key -validatecommand {TestEntry_onlyZahlenliste %S}
proc TestEntry_onlyZahlenliste {Zeichen} {
    if {[string is digit $Zeichen] || $Zeichen == " "} {return 1} {return 0}
}

proc round_scaleval {val round} {   
    if {$round == 0} {expr round($val)} else {
            set roundx [expr 10 ** $round * 1.0] 
            expr {round($roundx*$val)/$roundx}} 
}


proc reset_sf_data_List {} {
  global folder_List
  global sf_data_List

  set rowx 0
  set sf_data_List {} 

  .lb_saved_path configure -text ""

  foreach pathx $folder_List {
    set sf_listx [lsort -dictionary -increasing -nocase [glob -directory $pathx -type f *{.wav,.WAV,.aif,.aiff,.AIF,.AIFF}*]]
    set row_name [file tail $pathx]
    set data_bag {}
    set posx 0

    .frame.tv insert {} end -id "row$rowx" -text $row_name

     foreach sfx $sf_listx {
      set short_name [file tail $sfx]
      set valuesx [list $rowx $posx $short_name 0.0]
      lappend data_bag [list $sfx 0.0]
      .frame.tv insert "row$rowx" end -values $valuesx 
      incr posx}

      lappend sf_data_List $data_bag
  incr rowx 
  }
}

proc open_new_dir {} {
  global curr_Dir
  global folder_List
  # delete existing treeview before
  set len [llength $folder_List]
  for {set x 0} {$x < $len} {incr x} { set Wert [.frame.tv delete "row$x"] }

  set upfile "/Users/wsuppan/Dropbox/2021/Apps/sfPlayerSC-0.1/sounds/A" ;#[file join ".." $curr_Dir]
  set all_new_sf {}
  set dir [tk_chooseDirectory -title "New Soundfile Directory" -initialdir $upfile]  
  if {$dir != ""} {
  set filename [glob -nocomplain -directory $dir -type f *{.wav,.WAV,.aif,.aiff,.AIF,.AIFF}*]
  if {$filename == ""} {set folder_List [lsort -dictionary -increasing -nocase [glob -directory $dir -type d *]]} else {
    set folder_List [list $dir]}
  set curr_Dir $dir
  set short_foldername [file tail $dir]
  wm title . [format "sf Dir: $dir/"]
  reset_sf_data_List 
  }
}

proc open_sound_folder {} {
  global curr_Dir
  exec open $curr_Dir
}

proc read_file {Path} {
  set path_test [file exist $Path]
  if {$path_test == 1} {  
    set fp [open $Path r]
    set str [read $fp]
    close $fp
    return $str}
}

proc write_file {str path} {
  set f [open $path w]
  puts $f $str
  close $f
}

proc get_sf_row_max {} {
  global sf_data_List
  set x {}
  foreach xx $sf_data_List {
    set lenx [llength $xx]
    if {$x == ""} {set x $lenx} else {
      if {$lenx > $x} {set x $lenx}
    }}  
  return $x
}

proc get_channel_list {} {
  global sf_data_List
  set bag {}
 foreach rowx $sf_data_List {
   foreach sfx $rowx {
    set pathx [lindex $sfx 0]
    set chanx [exec mdls -name kMDItemAudioChannelCount -raw $pathx] 
    lappend bag $chanx }}
  return $bag
}

proc make_m_data {} {
  global single_play
  global device
  global memsize_power
  global out_name
  global row_font
  global row_font_size
  global sfx_font
  global sfx_font_size
  global row_dist_x
  global sfx_dist_y
  global button_x
  global button_y
  global rand_x
  global rand_y
  global open_scd
  global curr_Dir
  global folder_List
  global sf_data_List

  set data_pairs [list "single_play" $single_play "device" $device "memsize_power" $memsize_power "out_name" $out_name "row_font" $row_font "row_font_size" $row_font_size\
    "sfx_font" $sfx_font "sfx_font_size" $sfx_font_size "row_dist_x" $row_dist_x "sfx_dist_y" $sfx_dist_y "button_x" $button_x "button_y" $button_y "rand_x" $rand_x "rand_y" $rand_y\
    "open_scd" $open_scd "curr_Dir" $curr_Dir "folder_List" $folder_List "sf_data_List" $sf_data_List]

  return $data_pairs
}

proc update_m_data {data} {
  global single_play
  global device
  global memsize_power
  global out_name
  global row_font
  global row_font_size
  global sfx_font
  global sfx_font_size
  global row_dist_x
  global sfx_dist_y
  global button_x
  global button_y
  global rand_x
  global rand_y
  global open_scd
  global curr_Dir
  global folder_List
  global sf_data_List
  global m_data

  set m_data {}
  set m_data [dict create]
  set m_data $data
  set single_play [dict get $m_data single_play]
  set device [dict get $m_data device]
  set memsize_power [dict get $m_data memsize_power]
  set out_name [dict get $m_data out_name]
  set row_font [dict get $m_data row_font]
  set row_font_size [dict get $m_data row_font_size]
  set sfx_font [dict get $m_data sfx_font]
  set sfx_font_size [dict get $m_data sfx_font_size]
  set row_dist_x [dict get $m_data row_dist_x]
  set sfx_dist_y [dict get $m_data sfx_dist_y]
  set rand_x [dict get $m_data rand_x]
  set rand_y [dict get $m_data rand_y]
  set open_scd [dict get $m_data open_scd]
  set curr_Dir [dict get $m_data curr_Dir]

  wm title . [format "sf Dir: $curr_Dir/"]
  
  .lb_saved_path configure -text ""

  if {$folder_List > 0} {
     set len [llength $folder_List]
     for {set x 0} {$x < $len} {incr x} { set Wert [.frame.tv delete "row$x"] }
  }

  set folder_List [dict get $m_data folder_List]
  set sf_data_List [dict get $m_data sf_data_List]

  set rowx 0
  foreach pathx $folder_List sf_listx $sf_data_List {
        set row_name [file tail $pathx]
        set posx 0
        .frame.tv insert {} end -id "row$rowx" -text $row_name
         foreach sfx $sf_listx {
                  set path_long [lindex $sfx 0]
                  set mulx [lindex $sfx 1]
                  set short_name [file tail $path_long]
                  set valuesx [list $rowx $posx $short_name $mulx]
                  .frame.tv insert "row$rowx" end -values $valuesx 
                  incr posx}
        incr rowx}
    
}

proc save_m_data_dialog {} {
  global sf_data_List
  global out_name
  if {$sf_data_List != ""} {
  set name "$out_name-1"
   set file [tk_getSaveFile -title "Save Data" -parent . -defaultextension ".m_data" -initialfile $name]
   if { $file == "" } {
        return; # they clicked cancel
      } else { set m_data [make_m_data]
              write_file $m_data $file }
  } else { tk_messageBox -message "Select a soundfile directory first!" -icon warning -type ok }
 }

proc import_m_data_dialog {} {
  global sf_data_List

  set types {
    {{Text Files}       {.m_data}        }}

   set file [tk_getOpenFile -title "Open MixLive (*.m_data) Data" -parent . -filetypes $types ]
   if { $file == "" } {
        return; # they clicked cancel
      } else {
        set str [read_file $file]
        update_m_data $str
       }
 }

set help_text "Delta-Live help

--------------------
1. key-commands:
--------------------

cmd-E -> eval and write the patch for SuperCollider (*.scd)
cmd-N -> choose new directory (soundfiles)

after choosung one or more folders with soundfiles: 
each folder becomes a row in the SuperCollider window
(ie. one folder -> one single row)

cmd-S -> save all data ('*.m_data') to a new file
cmd-I -> import all data ('*.m_data') 

cmd-Q -> Quit


--------------------------
2. Possible Treatments:
--------------------------

change/edit volume manually by select and key-command '+'/'-'
set volume to 0.0 dB by select and key-command '0'

--------------------------
3. Parameter:
--------------------------

single_play? -> in concert situations and deselect when rehearsing (allow multiple starts) 

device -> Audio Interface (print ServerOptions.devices; in SuperCollider)

memsize_power -> The number of kilobytes of real time memory allocated to the server. 
Setting this too low is a common cause of 'exception in real time: alloc failed' errors. 
The default is 2**13 (8192).

out_name -> name of the Patch (*.scd)

"

set counter1 0

proc mk_Help_Win {} {
    # Make a unique widget name
  global help_text
    set w .gui[incr counter1]
    # Make the toplevel
    toplevel $w
    wm title $w "Help"
  wm geometry $w "580x730+250+50"
  wm resizable $w 0 0
    # Put a GUI in it
  place [label $w.text1 -text $help_text -justify left -fg blue] -x 20 -y 35 
    place [button $w.ok -text OK -command [list destroy $w]] -x 510 -y 690
}

#========================================================================================================
#
#
#
#                                         Main Window
#
#
#
#========================================================================================================

set geometry_start "820x720+250+50"

wm title . [format "soundfile Dir: ~/$dirtail/"]
wm resizable . 0 0
wm geometry . $geometry_start

option add *Menu.tearOff 0
. configure -menu .mbar

#============================================================================
# menu 0

menu .mbar
.mbar add cascade -label "File" -menu .mbar.file
.mbar add cascade -label "Edit" -menu .mbar.edit
.mbar add cascade -label "Window" -menu .mbar.window

#============================================================================
# menu1 File

menu .mbar.file
.mbar.file add command -label "Open soundfile Dir in Finder" -accelerator Command-O -command { open_sound_folder }
.mbar.file add command -label "New soundfile Dir (PWD)" -accelerator Command-N -command { open_new_dir }
.mbar.file add separator
.mbar.file add command -label "Save" -accelerator Command-S -command { open_new_dir }
.mbar.file add command -label "Import" -accelerator Command-I -command { open_new_dir }

bind . <Command-o> { open_sound_folder }
bind . <Command-n> { open_new_dir }
bind . <Command-s> { save_m_data_dialog }
bind . <Command-i> { import_m_data_dialog }

#============================================================================
# men2 Window

menu .mbar.edit
.mbar.edit add command -label "Eval out.scd" -accelerator Command-E -command { save_SC_file }

bind . <Command-e> { save_SC_file }

#============================================================================
# menu3 Window

menu .mbar.window
.mbar.window add command -label "Open Delta-Live Help"  -accelerator h -command { mk_Help_Win }

bind . <KeyPress-h> { mk_Help_Win }


#========================================================================================================
#
#
#
#                                         buttons, textentry, treview,...
#
#
#
#========================================================================================================

ttk::frame .frame 

ttk::treeview .frame.tv -columns {row pos Name Volume} -height 31 -display {Name Volume} -yscrollcommand {.frame.sbY set} 

.frame.tv heading #0 -text "Folder"
.frame.tv heading Name -text "Name"
.frame.tv heading Volume -text "dB"
.frame.tv column #0 -minwidth 30 -width 70 -stretch 1 -anchor nw
.frame.tv column Name -width 300  -anchor nw
.frame.tv column Volume -width 40  -anchor ne

ttk::scrollbar .frame.sbY -command {.frame.tv yview}

pack .frame.sbY -side right -fill y
pack .frame.tv -side left

place .frame -x 30 -y 30

#------------------------
set x1_line 500
set x2_line 640
set y_dist 37
#------------------------

ttk::label .lb_appname -text "Delta-Live v0.12"  -font "menlo 24" 
place .lb_appname -x $x1_line -y 25

#------------------------

ttk::label .lb_single_play -text "single_play?:" -foreground #1c79d9
place .lb_single_play -x $x1_line -y [expr $y_dist * 2]

set single_play 0
ttk::checkbutton .check_single_play  -text "" -variable single_play
place .check_single_play -x $x2_line -y [expr $y_dist * 2]

#------------------------

ttk::label .lb_device -text "device:" -foreground #1c79d9
place .lb_device -x $x1_line -y [expr $y_dist * 3]

set device {}
ttk::entry .enText_device  -textvariable device -width 15
place .enText_device -x $x2_line -y [expr ($y_dist * 3) - 2]

#------------------------

ttk::label .lb_memsize_power -text "memsize_power:" -foreground #1c79d9
place .lb_memsize_power -x $x1_line -y [expr $y_dist * 4]

set memsize_power 18
ttk::entry .enText_memsize_power  -textvariable memsize_power -width 5 -validate key -validatecommand {TestEntry_onlyZahl %S}
place .enText_memsize_power -x $x2_line -y [expr ($y_dist * 4) - 2]

#------------------------

ttk::label .lb_out_name -text "out_name:" -foreground #1c79d9
place .lb_out_name -x $x1_line -y [expr $y_dist * 5]

set out_name "sfPlayer"
ttk::entry .enText_out_name  -textvariable out_name -width 15
place .enText_out_name -x $x2_line -y [expr ($y_dist * 5) - 2]

#------------------------

ttk::label .lb_row_font -text "row_font:" -foreground gray
place .lb_row_font -x $x1_line -y [expr $y_dist * 7]

set row_font "Arial"
ttk::entry .enText_row_font  -textvariable row_font -width 15
place .enText_row_font -x $x2_line -y [expr ($y_dist * 7) - 2]

ttk::label .lb_row_font_size -text "row_font_size:" -foreground gray
place .lb_row_font_size -x $x1_line -y [expr $y_dist * 8]

set row_font_size 24
ttk::entry .enText_row_font_size  -textvariable row_font_size -width 5  -validate key -validatecommand {TestEntry_onlyZahl %S}
place .enText_row_font_size -x $x2_line -y [expr ($y_dist * 8) - 2]

#------------------------

ttk::label .lb_sfx_font -text "sfx_font:" -foreground gray
place .lb_sfx_font -x $x1_line -y [expr $y_dist * 9]

set sfx_font "Courir"
ttk::entry .enText_sfx_font  -textvariable sfx_font -width 15
place .enText_sfx_font -x $x2_line -y [expr ($y_dist * 9) - 2]

ttk::label .lb_sfx_font_size -text "sfx_font_size:" -foreground gray
place .lb_sfx_font_size -x $x1_line -y [expr $y_dist * 10]

set sfx_font_size 12
ttk::entry .enText_sfx_font_size  -textvariable sfx_font_size -width 5  -validate key -validatecommand {TestEntry_onlyZahl %S}
place .enText_sfx_font_size -x $x2_line -y [expr ($y_dist * 10) - 2]

#------------------------

ttk::label .lb_row_dist_x -text "row_dist_x:" -foreground gray
place .lb_row_dist_x -x $x1_line -y [expr $y_dist * 11]

set row_dist_x 200
ttk::entry .enText_row_dist_x  -textvariable row_dist_x -width 5 -validate key -validatecommand {TestEntry_onlyZahl %S}
place .enText_row_dist_x -x $x2_line -y [expr ($y_dist * 11) - 2]

#------------------------

ttk::label .lb_sfx_dist_y -text "sfx_dist_y:" -foreground gray
place .lb_sfx_dist_y -x $x1_line -y [expr $y_dist * 12]

set sfx_dist_y 50
ttk::entry .enText_sfx_dist_y  -textvariable sfx_dist_y -width 5 -validate key -validatecommand {TestEntry_onlyZahl %S}
place .enText_sfx_dist_y -x $x2_line -y [expr ($y_dist * 12) - 2]
#------------------------

ttk::label .lb_button_x -text "button_x:" -foreground gray
place .lb_button_x -x $x1_line -y [expr $y_dist * 13]

set button_x 140
ttk::entry .enText_button_x  -textvariable button_x -width 5 -validate key -validatecommand {TestEntry_onlyZahl %S}
place .enText_button_x -x $x2_line -y [expr ($y_dist * 13) - 2]

#------------------------

ttk::label .lb_button_y -text "button_y:" -foreground gray
place .lb_button_y -x $x1_line -y [expr $y_dist * 14]

set button_y 36
ttk::entry .enText_button_y  -textvariable button_y -width 5 -validate key -validatecommand {TestEntry_onlyZahl %S}
place .enText_button_y -x $x2_line -y [expr ($y_dist * 14) - 2]

#------------------------

ttk::label .lb_rand_x -text "rand_x:" -foreground gray
place .lb_rand_x -x $x1_line -y [expr $y_dist * 15]

set rand_x 40
ttk::entry .enText_rand_x  -textvariable rand_x -width 5 -validate key -validatecommand {TestEntry_onlyZahl %S}
place .enText_rand_x -x $x2_line -y [expr ($y_dist * 15) - 2]

#------------------------

ttk::label .lb_rand_y -text "rand_y:" -foreground gray
place .lb_rand_y -x $x1_line -y [expr $y_dist * 16]

set rand_y 36
ttk::entry .enText_rand_y  -textvariable rand_y -width 5 -validate key -validatecommand {TestEntry_onlyZahl %S}
place .enText_rand_y -x $x2_line -y [expr ($y_dist * 16) - 2]

#------------------------

ttk::button .bt -text "NEW Dir" -command { open_new_dir }
place .bt -x 30 -y 650

ttk::button .btest -text "Eval" -command { save_SC_file }
place .btest -x 160 -y 650

set open_scd 1
ttk::checkbutton .check_open_scd  -text "open in SC?" -variable open_scd
place .check_open_scd -x 280 -y 657


ttk::button .b_save_m_data -text "Save" -command { save_m_data_dialog }
place .b_save_m_data -x 500 -y 650

ttk::button .b_import_m_data -text "Import" -command { import_m_data_dialog }
place .b_import_m_data -x 640 -y 650

ttk::label .lb_info_key -text "press h -> opens help window"  -font "menlo 11" -foreground gray
place .lb_info_key -x 30 -y 625

set saved_path {}
ttk::label .lb_saved_path -text $saved_path  -font "menlo 10" -foreground gray
place .lb_saved_path -x 30 -y 690



#========================================================================================================
#
#
#
#                                         bindings
#
#
#
#========================================================================================================

bind . <KeyPress-0> {
  set Auswahl [.frame.tv selection]
  set test [lsearch $Auswahl row*]
  if {$test < 0} {
  foreach Element $Auswahl {
    set Wert [.frame.tv item $Element -value]
    #puts $Wert
    set rowx [lindex $Wert 0] 
    set posx [lindex $Wert 1] 
    set path_short [lindex $Wert 2] 
    set old_rowx [lindex $sf_data_List $rowx]
    set old_elemx [lindex $old_rowx $posx]
    set path_long [lindex $old_elemx 0]
    set new_elemx [list $path_long 0.0]
    set new_rowx [lreplace $old_rowx $posx $posx $new_elemx]
    set sf_data_List [lreplace $sf_data_List $rowx $rowx $new_rowx]
    .frame.tv item $Element -value [list $rowx $posx $path_short 0.0]
    }
  }
}

bind . <KeyPress-KP_0> {
  set Auswahl [.frame.tv selection]
  set test [lsearch $Auswahl row*]
  if {$test < 0} {
  foreach Element $Auswahl {
    set Wert [.frame.tv item $Element -value]
    #puts $Wert
    set rowx [lindex $Wert 0] 
    set posx [lindex $Wert 1] 
    set path_short [lindex $Wert 2] 
    set old_rowx [lindex $sf_data_List $rowx]
    set old_elemx [lindex $old_rowx $posx]
    set path_long [lindex $old_elemx 0]
    set new_elemx [list $path_long 0.0]
    set new_rowx [lreplace $old_rowx $posx $posx $new_elemx]
    set sf_data_List [lreplace $sf_data_List $rowx $rowx $new_rowx]
    .frame.tv item $Element -value [list $rowx $posx $path_short 0.0]
    }
  }
}

bind . <KeyPress-plus> {
  set Auswahl [.frame.tv selection]
  set test [lsearch $Auswahl row*]
  if {$test < 0} {
  foreach Element $Auswahl {
    set Wert [.frame.tv item $Element -value]
    #puts $Wert
    set rowx [lindex $Wert 0] 
    set posx [lindex $Wert 1] 
    set path_short [lindex $Wert 2] 
    set mulx [lindex $Wert 3]
    if {$mulx < 0 } { set old_rowx [lindex $sf_data_List $rowx]
                      set old_elemx [lindex $old_rowx $posx]
                      set path_long [lindex $old_elemx 0]
                      set new_elemx [list $path_long [expr $mulx + 1.0]]
                      set new_rowx [lreplace $old_rowx $posx $posx $new_elemx]
                      .frame.tv item $Element -value [list $rowx $posx $path_short [expr $mulx + 1.0]]
                      set sf_data_List [lreplace $sf_data_List $rowx $rowx $new_rowx] 
                      } { bell }
    }
  }
}

bind . <KeyPress-minus> {
  set Auswahl [.frame.tv selection]
  set test [lsearch $Auswahl row*]
  if {$test < 0} {
  foreach Element $Auswahl {
    set Wert [.frame.tv item $Element -value]
    #puts $Wert
    set rowx [lindex $Wert 0] 
    set posx [lindex $Wert 1] 
    set path_short [lindex $Wert 2] 
    set mulx [lindex $Wert 3]
    set old_rowx [lindex $sf_data_List $rowx]
    set old_elemx [lindex $old_rowx $posx]
    set path_long [lindex $old_elemx 0]
    set new_elemx [list $path_long [expr $mulx - 1.0]]
    set new_rowx [lreplace $old_rowx $posx $posx $new_elemx]
    set sf_data_List [lreplace $sf_data_List $rowx $rowx $new_rowx]
    .frame.tv item $Element -value [list $rowx $posx $path_short [expr $mulx - 1.0]]
    }
  }
}

bind . <Key-KP_Add> {
  set Auswahl [.frame.tv selection]
  set test [lsearch $Auswahl row*]
  if {$test < 0} {
  foreach Element $Auswahl {
    set Wert [.frame.tv item $Element -value]
    #puts $Wert
    set rowx [lindex $Wert 0] 
    set posx [lindex $Wert 1] 
    set path_short [lindex $Wert 2] 
    set mulx [lindex $Wert 3]
    if {$mulx < 0 } { set old_rowx [lindex $sf_data_List $rowx]
                      set old_elemx [lindex $old_rowx $posx]
                      set path_long [lindex $old_elemx 0]
                      set new_elemx [list $path_long [expr $mulx + 1.0]]
                      set new_rowx [lreplace $old_rowx $posx $posx $new_elemx]
                      .frame.tv item $Element -value [list $rowx $posx $path_short [expr $mulx + 1.0]]
                      set sf_data_List [lreplace $sf_data_List $rowx $rowx $new_rowx] 
                      } { bell }
    }
  }
}

bind . <Key-KP_Subtract> {
  set Auswahl [.frame.tv selection]
  set test [lsearch $Auswahl row*]
  if {$test < 0} {
  foreach Element $Auswahl {
    set Wert [.frame.tv item $Element -value]
    #puts $Wert
    set rowx [lindex $Wert 0] 
    set posx [lindex $Wert 1] 
    set path_short [lindex $Wert 2] 
    set mulx [lindex $Wert 3]
    set old_rowx [lindex $sf_data_List $rowx]
    set old_elemx [lindex $old_rowx $posx]
    set path_long [lindex $old_elemx 0]
    set new_elemx [list $path_long [expr $mulx - 1.0]]
    set new_rowx [lreplace $old_rowx $posx $posx $new_elemx]
    set sf_data_List [lreplace $sf_data_List $rowx $rowx $new_rowx]
    .frame.tv item $Element -value [list $rowx $posx $path_short [expr $mulx - 1.0]]
    }
  }
}

#========================================================================================================
#
#
#
#                                         SuperCollider
#
#
#
#========================================================================================================

proc write_SC_string {} {
  global sf_data_List
  global folder_List
  global memsize_power
  global device
  global curr_Dir
  global out_name
  global row_dist_x
  global rand_x
  global sfx_dist_y
  global rand_y
  global single_play
  global button_x
  global button_y
  global row_font
  global row_font_size
  global sfx_font
  global sfx_font_size

  set chan_list [get_channel_list]
  set len [llength $chan_list]
  set str1 {}
  set str2 {}
  set str3 {}
  set str4 {}
  if {$device != ""} {set str5 [format "s.options.device = \"%s\";    //ServerOptions.devices;" $device] } else { 
                      set str5 [format "//s.options.device = \"Fireface 400 (F0C)\";    //ServerOptions.devices;"]}
  set str6 $memsize_power
  set str7 [expr 2 ** $memsize_power]
  set str8 {}
  set str9 [format "sfPath0  = \"%s/\";" $curr_Dir]
  set str10 {}
  set str11 {}
  set str12 $out_name
  set n_rows [llength $folder_List]
  set win_x [expr round(($row_dist_x * $n_rows) + ($rand_x * 1.5))]
  if {$win_x > 700} {set str13 $win_x } else { set str13 700 }
  set win_y  [expr round(($sfx_dist_y * [get_sf_row_max]) + ($rand_y * 2.0))]
  set str14 $win_y
  set str15 [expr $win_y -30]
  if {$single_play == 1} {set str16 [format "- single-play-modus is on!"]} else {set str16 [format "- replay: reselect and press space twice!"]}
  set str17 {}
  set chan_list_no_dups [lsort -unique -integer $chan_list]
  set str18 {}
  foreach chanx $chan_list_no_dups {
    append str18 [format "    SynthDef(\\Play%schan,{|bufnum, gain=1 ,mul=1|
        Out.ar(0, VDiskIn.ar( %s, bufnum, rate: 1.0 ) * mul );
        }).send(s);

" $chanx  $chanx]}

  set str19 {}
  set str20 {}
  set str21 {}

  set posx 0
  set row_posx 0
  foreach rowx $sf_data_List foldernamex $folder_List {
      set short_foldernamex [file tail $foldernamex]
      append str8 [format "    //%s:\n" $short_foldernamex]
      set x0 [expr $rand_x + ($row_dist_x * $row_posx)]
      set x0b [expr round($x0 - ($rand_x / 4.0))]
      set x1 [expr $button_x + $rand_x]
      append str17 [format "    StaticText(w, Rect(%s,10,%s,30)).string_(\"%s\").font_(Font(\"%s\", %s, true)).stringColor_(Color.black).align_(\\center);\n" $x0b $x1 $short_foldernamex $row_font $row_font_size]
      set posy 0
             foreach sfx $rowx {
             set posx2 [expr $posx + 1]
             append str1 [format "\nvar b%s,button_sf%s,synth_sf%s;" $posx2 $posx2 $posx2]
             if {$posx > 0} { append str2 [format ",dBsf%s" $posx2]}
             if {$posx > 0} { append str3 [format ",dBtext%s" $posx2]}
             append str4 [format ",sfPath%s" $posx2]
             set mulx [lindex $sfx 1]
             append str8 [format "    dBsf%s%4s%8.1f;\n" $posx2 "=" $mulx]
             set pathx [lindex $sfx 0]
             set short_sfx [file tail $pathx]
             if {$n_rows == 1} { append str10 [format "    sfPath%s  = sfPath0 ++ \"%s\";\n" $posx2 $short_sfx] } else {
                                  append str10 [format "    sfPath%s  = sfPath0 ++ \"%s/%s\";\n" $posx2 $short_foldernamex $short_sfx] }
             set chanx [exec mdls -name kMDItemAudioChannelCount -raw $pathx] 
             append str11 [format "    b%s  = Buffer.cueSoundFile(s,sfPath%s  ,0 ,%s);\n" $posx2 $posx2 $chanx]
             set xdB [expr ($button_x + $x0) - 15]
             set y0 [expr round(($rand_y * 1.2) + ($sfx_dist_y * $posy))]
             set ydB [expr $y0 + 5]
             if {$single_play == 1} { set str19b [format "synth_sf%s.free;" $posx2]} else { set str19b [format "b%s = Buffer.cueSoundFile(s,sfPath%s,0,%s);" $posx2 $posx2 $chanx] }
             if { $posx2 < $len} { set str19c [format "button_sf%s.focus(true);" [expr $posx2 + 1]] } else { set str19c [format "button_sf%s.focus(false);" $posx2]}
             append str18 [format "    //SF-%s button
    dBtext%s = StaticText(w, Rect(%s,%s,80,20)).string_(dBsf%s.asString++\" dB\").font_(Font(\"Arial\", 12)).stringColor_(Color.gray).align_(\\center);
    button_sf%s = Button(w, Rect(%s,%s,%s,%s))
    .font_(Font(\"%s\",%s))
    .states_(\[\[\"%s\", Color.black\],\[\"%s\",Color.white, Color.gray\]\])
    .action_({ arg butt, mod;
                   if (button_sf%s.value == 0, {
                       %s
                       },{synth_sf%s = Synth.new(\\Play%schan,\[\\bufnum,b%s,\\mul, dBsf%s.dbamp\]);%s
                                         })});
" $posx2 $posx2 $xdB $ydB $posx2 $posx2 $x0 $y0 $button_x $button_y $sfx_font $sfx_font_size $short_sfx $short_sfx $posx2 $str19b $posx2 $chanx $posx2 $posx2 $str19c]

             append str20 [format "    button_sf%s.focusColor  = Color.red(val: 1.0, alpha: 0.8);\n" $posx2]
             append str21 [format "b%s.free;" $posx2]
             incr posx
             incr posy }
      incr row_posx
  }

  set str_res [format "//=============================================
// sfPlayerSC
//=============================================

// choose \"Evaluate File\" form the menu,
// or press cmd-a (select all)  + cmd-return

// single-play?=nil
// t   -> \"performance-mode\": every sf can be played only once
// nil -> \"rehearse-mode\": every sf can be restarted

(%s
var button_dump;
var dBsf1%s;
var dBtext1%s;
var sfPath0%s;

    s = Server.local;
    %s
    s.options.memSize = 2**%s;   //-> %s kilobytes (default: 2**13 -> 8192)
    s.boot;
    s.latency = 0;

s.waitForBoot(\{
    //dB-levels:
%s
    //Soundfile paths:
    %s
%s
    //Buffer
%s
    //Win
    w = Window(\"%s\", Rect(130,100,%s,%s)).front;
    w.view.background = Color.white;
    StaticText(w, Rect(30,%s,700,40)).string_(\"Press space to start a SF (SC selected and cmd-m opens the levelmeter window...) %s\")
    .font_(Font(\"Arial\", 12)).stringColor_(Color.gray).align_(\\left);
%s

    //SynthDef
%s

%s
    //Focus
    button_sf1.focus(true);

    //Set focus color
%s
    //Close
    w.onClose = {
    %s
    s.freeAll;
    s.quit;
                \};
});
)"  $str1 $str2 $str3 $str4 $str5 $str6 $str7 $str8 $str9 $str10 $str11 $str12 $str13 $str14 $str15 $str16 $str17 $str18 $str19 $str20 $str21]
  return $str_res }


proc save_SC_file {} {
  global curr_Dir
  global out_name
  global sf_data_List
  global open_scd

  set temp_scd_path [file join "$curr_Dir/" "$out_name.scd"]

  if {$sf_data_List != ""} {
        set temp_str [write_SC_string]
        write_file $temp_str $temp_scd_path
        if {$open_scd == 1} { exec open $temp_scd_path }
        .lb_saved_path configure -text "saved: $temp_scd_path"
      } else {bell}
}

#=====
# EOF
#=====