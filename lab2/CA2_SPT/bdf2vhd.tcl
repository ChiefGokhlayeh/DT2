###############################################################################
# bdf2vhd.tcl
#
#  Digitaltechnik 2
#  (c) 2013 R.Keller, W.Lindermeir, W.Zimmermann
#  Hochschule Esslingen
#  Author:  Walter Lindermeir, 4.12.2009
#
###############################################################################

package require ::quartus::flow

puts "Executing quartus_map for CA2_SPT.vhd generation ...."
execute_module -tool map -args "--read_settings_files=on --write_settings_files=off --convert_bdf_to_vhdl=CA2_SPT.bdf"

puts "Executing quartus_map for disp.vhd generation ...."
execute_module -tool map -args "--read_settings_files=on --write_settings_files=off --convert_bdf_to_vhdl=disp.bdf"

puts "Executing quartus_map for environment.vhd generation ...."
execute_module -tool map -args "--read_settings_files=on --write_settings_files=off --convert_bdf_to_vhdl=environment.bdf"

