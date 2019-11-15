#************************************************************

create_clock -name "clk_fast_external" -period 20ns [get_ports {clk}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
#derive_clock_uncertainty
# Not supported for family Stratix

# clock uncertainty
set_clock_uncertainty -from [get_clocks {*}] -to [get_clocks {*}] 0.1


set_false_path -from [get_ports {HWreset_n_SW STOPP_n_SW START_n_SW}] 

set_false_path -to [get_ports {Warning_OK Antrieb_n LED Td_Expired Tw_Expired State_Aus State_Warnung State_Ein}] 















