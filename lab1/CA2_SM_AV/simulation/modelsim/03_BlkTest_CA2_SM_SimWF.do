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
# Hier: Test der Blinkfunktion
#
config wave -signalnamewidth 1


add wave -noupdate -divider {Takt und Reset}
add wave -noupdate -format Logic                  /ca2_sm_vhd_tst/clk
add wave -noupdate -format Logic -color white   /ca2_sm_vhd_tst/i1/b2v_PUReset_Generator_Inst/PUReset_n

add wave -noupdate -divider {Eingangssignale}
add wave -noupdate -format Logic -color white     /ca2_sm_vhd_tst/HWreset_n_SW
add wave -noupdate -format Logic                  /ca2_sm_vhd_tst/START_n_SW
add wave -noupdate -format Logic                  /ca2_sm_vhd_tst/STOPP_n_SW

add wave -noupdate -divider {Entprellte Eingangssignale}
add wave -noupdate -format Logic -color Blue      /ca2_sm_vhd_tst/i1/b2v_TP_1/START
add wave -noupdate -format Logic -color Blue      /ca2_sm_vhd_tst/i1/b2v_TP_1/STOPP

add wave -noupdate -divider {Anlaufsteuerung}
add wave -noupdate -format Literal -color Yellow  /ca2_sm_vhd_tst/i1/b2v_anlst/ActState
add wave -noupdate -format Logic   -color Red     /ca2_sm_vhd_tst/Antrieb_n
add wave -noupdate -format Logic   -color Red     /ca2_sm_vhd_tst/i1/b2v_AnlSt/LED_On_Off
add wave -noupdate -format Logic   -color Red     /ca2_sm_vhd_tst/i1/b2v_AnlSt/LED_blink_flag

add wave -noupdate -divider {Anlauftimer-Blinkfunktion}
add wave -noupdate -format Logic                  /ca2_sm_vhd_tst/i1/b2v_timergruppe/FF_Enable
add wave -noupdate -format Logic                  /ca2_sm_vhd_tst/i1/b2v_timergruppe/LED_blink_flag
add wave -noupdate -format Literal                /ca2_sm_vhd_tst/i1/b2v_timergruppe/CntBlink
add wave -noupdate -format Logic                  /ca2_sm_vhd_tst/i1/b2v_timergruppe/LED_blink_state

add wave -noupdate -divider {Ausgang-LED-Signal}
add wave -noupdate -format Logic   -color Blue    /ca2_sm_vhd_tst/LED
run 27 us
wave zoomfull
# end of simulation waveform generation
