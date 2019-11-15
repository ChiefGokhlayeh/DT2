#************************************************************

create_clock -name "clk_fast_external" -period 20ns [get_ports {clk}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
#derive_clock_uncertainty
# Not supported for family Stratix

# clock uncertainty
set_clock_uncertainty -from [get_clocks {*}] -to [get_clocks {*}] 0.1

set_false_path -from [get_ports {HWreset_n_SW RESET_n_SW STOPP_n_SW START_n_SW \
                                 LCD_DB[0] LCD_DB[1] LCD_DB[2] LCD_DB[3] LCD_DB[4] LCD_DB[5] LCD_DB[6] LCD_DB[7]}] 

set_false_path -to [get_ports {LCD_DB[0] LCD_DB[1] LCD_DB[2] LCD_DB[3] LCD_DB[4] LCD_DB[5] LCD_DB[6] LCD_DB[7]\
                               RUN ZERO seven_segs[6] seven_segs[5] seven_segs[4] \
                               seven_segs[3] seven_segs[2] seven_segs[1] seven_segs[0] LCD_RW LCD_RS LCD_e}] 












