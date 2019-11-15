###############################################################################
# modelsim_script.do for Modelsim Altera
#
#  Digitaltechnik 2
#  Labor 1, AUT
#  (c) 2013 W.Lindermeir, W.Zimmermann, R.Keller
#  Hochschule Esslingen
#  Letzte Änderung: 02/11
#
#  Mit diesem Script wird die Graphik-Ausgabe (Impulsdiagramme) gesteuert.
#  Es können Signale aus dem Design ausgewählt und entsprechend dargestellt werden.
#  Zudem kann die Simulationsdauer (run x us) festgelegt werden.
#
###############################################################################
#
# Hier: Default Waveforms
#
config wave -signalnamewidth 1

add wave -noupdate -divider {Takt und Power-Up-Reset}
add wave -noupdate -format Logic                /ca2_sm_vhd_tst/clk
add wave -noupdate -format Logic -color white   /ca2_sm_vhd_tst/i1/b2v_PUReset_Generator_Inst/PUReset_n
#
run 300 ns
wave zoomfull
# end of simulation waveform generation
