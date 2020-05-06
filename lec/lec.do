// STEP 0: (completed) The dofile must be in 'tclmode'
tclmode

// STEP 1: Set the log file. This is helpful to debug the setup.
set_log_file logging2 -Replace

// STEP 2: Set the undefined cells as black boxes for both golden and revised designs.
set_undefined_cell Black_box -Both

// STEP 3: Load the libraries
read_library -Both -Replace  -sensitive -Statetable -Liberty ./../synth/lib/gscl45nm.lib -nooptimize

// STEP 4: Load the golden design.
source rtl.list

add_search_path ./../src/ -Design -Golden -Recursive

read_design $RTL_LIST -Verilog -Golden -sensitive -nokeep_unreach -nosupply

// STEP 5: Load the revised design: 
read_design ./../synth/fft_64p_16b_top.gatelevel.v -Verilog -Revised -sensitive -continuousassignment Bidirectional -nokeep_unreach -nosupply


// STEP 6: Add the pin constraints
//add_pin_constraints 0 scan_clk scan_en scan_cg_en scan_mode -Both


// STEP 7: (completed) Setting the options for analysis
set_flatten_model -seq_constant -seq_constant_x_to 0
set_flatten_model -gated_clock
set_analyze_option -auto

// STEP 8: Set the system mode to lec
set_system_mode lec


// STEP 10: Add the compared points and compare
add_compared_points -all
compare

// If the script is correctly written, the code below will display 
// zero diff, abort and unknown points.
puts "Num of compare points = [get_compare_points -count]"
puts "Num of diff points    = [get_compare_points -NONequivalent -count]"
puts "Num of abort points   = [get_compare_points -abort -count]"
puts "Num of unknown points = [get_compare_points -unknown -count]"
