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

add wave -noupdate -divider {ControlUnit}
add wave -noupdate -format Literal -color Green  -radix hex  /ca2_spt_vhd_tst/i1/b2v_rdrv01/TrnCnt

run 800 ns
wave zoomfull
# end of simulation waveform generation

