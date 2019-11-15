###############################################################################
# modelsim_script.do for Modelsim Altera
#
#  Digitaltechnik 2
#  Labor 1, AUT
#  (c) 2013 W.Lindermeir, W.Zimmermann, R.Keller
#  Hochschule Esslingen
#  Letzte Änderung: 02/11
#
###############################################################################

# compile generated vhdl from source bdf (in case of error type in tcl console of quartus "source bdf2vhd.tcl"
vcom -93 -work work {../../CA2_SM.vhd}

# test bench compile
vcom -93 -work work {CA2_SM.vht}

# start simulation
vsim -t 1ns -novopt -L work ca2_sm_vhd_tst

# create graphical output (waveforms)
do CA2_SM_SimWF.do

# end of project specific script
