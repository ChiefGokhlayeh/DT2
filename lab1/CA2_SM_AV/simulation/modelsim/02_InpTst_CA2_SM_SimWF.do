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
# Hier: Test des Entprellers
#
config wave -signalnamewidth 1

add wave -noupdate -divider {Takt und Power-Up-Reset}
add wave -noupdate -format Logic                /ca2_sm_vhd_tst/clk
add wave -noupdate -format Logic -color white   /ca2_sm_vhd_tst/i1/b2v_PUReset_Generator_Inst/PUReset_n

add wave -noupdate -divider {Entprellter Reset}
add wave -noupdate -format Logic -color white   /ca2_sm_vhd_tst/i1/b2v_TP_1/HW_Reset

add wave -noupdate -divider {Eingangssignale}
add wave -noupdate -format Logic                /ca2_sm_vhd_tst/HWreset_n_SW
add wave -noupdate -format Logic                /ca2_sm_vhd_tst/START_n_SW

add wave -noupdate -divider {Innereien START-Entpreller}
add wave -noupdate -format Logic    -color Red  /ca2_sm_vhd_tst/i1/b2v_tp_1/FF_Enable
add wave -noupdate -format Literal  -color Red  /ca2_sm_vhd_tst/i1/b2v_tp_1/TP_START/Z
add wave -noupdate -format Literal  -color Red  /ca2_sm_vhd_tst/i1/b2v_tp_1/TP_START/CntIn
add wave -noupdate -format Literal  -color Red  /ca2_sm_vhd_tst/i1/b2v_tp_1/TP_START/CntOut

add wave -noupdate -divider {Entprellter START-Taster}
add wave -noupdate -format Logic                /ca2_sm_vhd_tst/i1/b2v_TP_1/START

run 2500 ns
wave zoomfull
# end of simulation waveform generation
