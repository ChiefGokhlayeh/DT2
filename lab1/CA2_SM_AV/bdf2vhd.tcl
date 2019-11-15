###############################################################################
# bdf2vhd.tcl
#
#  Digitaltechnik 2
#  (c) 2013 R.Keller, W.Lindermeir, W.Zimmermann
#  Hochschule Esslingen
#  Author:  Reinhard Keller, 4.04.2010
#
###############################################################################

package require ::quartus::flow

puts "Executing quartus_map for CA2_SM.vhd generation ...."
execute_module -tool map -args "--read_settings_files=on --write_settings_files=off --convert_bdf_to_vhdl=CA2_SM.bdf"

