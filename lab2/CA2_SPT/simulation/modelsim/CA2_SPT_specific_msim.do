###############################################################################
# modelsim_script.do for Modelsim Altera
#
#  Digitaltechnik 2
#  Labor 2, SPT
#  (C) 2013 R.Keller, W.Lindermeir, W.Zimmermann
#  Hochschule Esslingen
#
###############################################################################


# compile generated vhdl from source bdf
vcom -93 -work work {../../CA2_SPT.vhd}
vcom -93 -work work {../../environment.vhd}
vcom -93 -work work {../../disp.vhd}

# test bench compile
vcom -93 -work work {CA2_SPT.vht}

# start simulation
vsim -t 1ns -novopt -L work ca2_spt_vhd_tst

# create graphical output (waveforms)
do CA2_SPT_SimWF.do

# end of project specific script
