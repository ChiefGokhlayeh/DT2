###############################################################################
# modelsim_script.do for Modelsim Altera
#
#  Digitaltechnik 2
#  Labor 2, SPT
#  (C) 2013 R.Keller, W.Lindermeir, W.Zimmermann
#  Hochschule Esslingen
#
#  Mit diesem Script wird die Graphik-Ausgabe (Impulsdiagramme) gesteuert.
#  Es koennen Signale aus dem Design ausgewaehlt und entsprechend dargestellt werden.
#  Zudem kann die Simulationsdauer (run x us) festgelegt werden.
#
###############################################################################
#
config wave -signalnamewidth 1

add wave -noupdate -divider {Takteingang und Reset}
add wave -noupdate -format Logic                /ca2_spt_vhd_tst/buttons(0)
add wave -noupdate -format Logic -color yellow  /ca2_spt_vhd_tst/i1/b2v_environment_inst/reset_n
add wave -noupdate -format Logic                /ca2_spt_vhd_tst/i1/b2v_environment_inst/clk

add wave -noupdate -divider {Mikroprogramm}
add wave -noupdate -format Literal -color blue    -radix hex  /ca2_spt_vhd_tst/i1/b2v_MPrg1/IP
add wave -noupdate -format Literal -color blue    -radix hex  /ca2_spt_vhd_tst/i1/b2v_MPrg1/OPCODE
add wave -noupdate -format Literal -color blue    -radix hex  /ca2_spt_vhd_tst/i1/b2v_MPrg1/OPERAND

add wave -noupdate -divider {ControlUnit}
add wave -noupdate -format Literal -color Green  -radix hex  /ca2_spt_vhd_tst/i1/b2v_rdrv01/TrnCnt

add wave -noupdate -divider {ControlUnit Register}
add wave -noupdate -format Literal -color blue -radix hex  /ca2_spt_vhd_tst/i1/b2v_rdrv01/Adr
add wave -noupdate -format Literal -color blue -radix hex  /ca2_spt_vhd_tst/i1/b2v_rdrv01/Dat

add wave -noupdate -divider {ControlUnit Memory-Bus Ansteuerung}
add wave -noupdate -format Literal -color yellow -radix hex  /ca2_spt_vhd_tst/i1/b2v_rdrv01/EXT_D_internal
add wave -noupdate -format Logic   -color Yellow             /ca2_spt_vhd_tst/i1/b2v_rdrv01/OE_Dn

add wave -noupdate -divider {External RAM Bus Ansteuerung}
add wave -noupdate -format Literal -color Green  -radix hex  /ca2_spt_vhd_tst/ExtRAM/ram_outbuffer
add wave -noupdate -format Literal -color Green              /ca2_spt_vhd_tst/ExtRAM/ram_D_OE

add wave -noupdate -divider {Auf Speicherbus}
add wave -noupdate -format Literal -color blue -radix hex  /ca2_spt_vhd_tst/i1/Ext_D
add wave -noupdate -format Literal -color blue -radix hex  /ca2_spt_vhd_tst/i1/Ext_A
add wave -noupdate -format Logic   -color blue             /ca2_spt_vhd_tst/i1/Ext_RDn
add wave -noupdate -format Logic   -color blue             /ca2_spt_vhd_tst/i1/Ext_WRn

run 3000 ns
wave zoomfull
# end of simulation waveform generation

