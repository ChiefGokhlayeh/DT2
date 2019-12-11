#************************************************************

create_clock -name "clk_fast_external" -period 20ns [get_ports {clk_fast}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Derived clock
create_generated_clock -divide_by 2 -multiply_by 1  \
                       -source [get_ports {clk_fast}] \
                       -name {environment:environment_inst|clk_drv} \
                       {environment:environment_inst|clk_drv}


# Automatically calculate clock uncertainty to jitter and other effects.
#derive_clock_uncertainty
# Not supported for family Stratix

# clock uncertainty
set_clock_uncertainty -from [get_clocks {*}] -to [get_clocks {*}] 0.1


set_false_path -from [get_ports {buttons[*] LCD_DB[*] EXT_D[*]  }] 

set_false_path -to [get_ports {LCD_DB[*] EXT_D[*] seven_segs[*] EXT_A[*] EXT_BEn[*] leds[*] \
                               dot_seven_seg_l dot_seven_seg_h RAM_CEn EXT_RDn EXT_WRn Flash_CEn \
                               ETHER_ADSn ETHER_DATACSn LCD_RW LCD_RS LCD_E }] 

