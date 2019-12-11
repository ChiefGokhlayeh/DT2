###############################################################################
# pin_assign.tcl
#
#
# Autor:           Prof. Walter Lindermeir  08/2004
# Letzte Änderung: Prof. R. Keller          04/2010
#
#
# You can run this script from Quartus by observing the following steps:
# 1. Place this TCL script in your project directory
# 2. Open your project
# 3. Go to the View Menu and Auxilary Windows -> TCL console
# 4. In the TCL console type:
#						source pin_assign.tcl
# 5. The script will assign pins and return an "assignment made" message.
###############################################################################
puts "Assigning pins to project ...."

########## Set the pin location variables ############
### Control Pins
set clk K17
set reset_n AC9

### PIOs
set button_0 W5
set button_1 W6
set button_2 AB2
set button_3 AB1

set seven_seg_1_a   B18
set seven_seg_1_b   B20
set seven_seg_1_c   A20
set seven_seg_1_d   C20
set seven_seg_1_e   A21
set seven_seg_1_f   B21
set seven_seg_1_g   C21
set seven_seg_1_dot D21

set seven_seg_10_a   A18
set seven_seg_10_b   C18
set seven_seg_10_c   D18
set seven_seg_10_d   A19
set seven_seg_10_e   B19
set seven_seg_10_f   C19
set seven_seg_10_g   E19
set seven_seg_10_dot D19

set led_0 H27
set led_1 H28
set led_2 L23
set led_3 L24
set led_4 J25
set led_5 J26
set led_6 L20
set led_7 L19

# prototype connector J12 for LCD-Display
set lcd_rw   M8
set lcd_rs   M7
set lcd_e    K3
set lcd_db_0 H3
set lcd_db_1 L7
set lcd_db_2 L8
set lcd_db_3 H2
set lcd_db_4 H1
set lcd_db_5 L6
set lcd_db_6 L5
set lcd_db_7 J4

# altes Board (ES)
# SRAM Address
set SRAM_A0    B3
set SRAM_A1    B5
set SRAM_A2    B4
set SRAM_A3    C4
set SRAM_A4    A5
set SRAM_A5    C5 
set SRAM_A6    D5
set SRAM_A7    E6
set SRAM_A8    A6
set SRAM_A9    B7
set SRAM_A10   D6
set SRAM_A11   A7
set SRAM_A12   D7
set SRAM_A13   C6
set SRAM_A14   C7
set SRAM_A15   B6
set SRAM_A16   D8
set SRAM_A17   C8

# SRAM data U35
set SRAM_D0    H12
set SRAM_D1    F12
set SRAM_D2    J12
set SRAM_D3    M12
set SRAM_D4    H17
set SRAM_D5    K18
set SRAM_D6    H18
set SRAM_D7    G18
set SRAM_D8    B8
set SRAM_D9    A8
set SRAM_D10   A9
set SRAM_D11   C9
set SRAM_D12   E10
set SRAM_D13   A10
set SRAM_D14   C10
set SRAM_D15   B10

# SRAM control lines U35
set SRAM_BE1_n F17
set SRAM_BE0_n M18
set SRAM_CS_n  B24
set SRAM_OE_n  B26
set SRAM_WE_n  C24

# other chip enables on shared bus
set FLASH_CEn      K19
set ETHER_ADSn     V25
set ETHER_DATACSn  T20


# neues Board
#          # SRAM Address
#          set SRAM_A0    D5
#          set SRAM_A1    D6
#          set SRAM_A2    C5
#          set SRAM_A3    B5
#          set SRAM_A4    C2
#          set SRAM_A5    D2 
#          set SRAM_A6    D4
#          set SRAM_A7    D1
#          set SRAM_A8    E4
#          set SRAM_A9    E5
#          set SRAM_A10   F3
#          set SRAM_A11   E3
#          set SRAM_A12   E2
#          set SRAM_A13   F4
#          set SRAM_A14   F5
#          set SRAM_A15   F2
#          set SRAM_A16   F1
#          set SRAM_A17   F6
#          
#          # SRAM data U35
#          set SRAM_D0    C6
#          set SRAM_D1    E6
#          set SRAM_D2    B6
#          set SRAM_D3    A6
#          set SRAM_D4    F7
#          set SRAM_D5    E7
#          set SRAM_D6    B7
#          set SRAM_D7    A7
#          set SRAM_D8    D7
#          set SRAM_D9    C7
#          set SRAM_D10   F8
#          set SRAM_D11   E8
#          set SRAM_D12   B8
#          set SRAM_D13   A8
#          set SRAM_D14   D8
#          set SRAM_D15   C8
#          
#          # SRAM control lines U35
#          set SRAM_BE1_n V17
#          set SRAM_BE0_n V16
#          set SRAM_CS_n  W17
#          set SRAM_OE_n  Y17
#          set SRAM_WE_n  U16
#
#
#          # other chip enables on shared bus
#          set FLASH_CEn      A12
#          set ETHER_ADSn     A14
#          set ETHER_DATACSn  C15


################################################
#### Make the clock and reset_n signal assignments
set_location -to clk_fast "Pin_$clk"

#################################
#### Make the PIO pin assignments
set_location -to "buttons\[0\]" "Pin_$button_0" 
set_location -to "buttons\[1\]" "Pin_$button_1" 
set_location -to "buttons\[2\]" "Pin_$button_2" 

#################################
#### Make the LED pin assignments
set_location -to "leds\[0\]" "Pin_$led_0" 
set_location -to "leds\[1\]" "Pin_$led_1" 
set_location -to "leds\[2\]" "Pin_$led_2" 
set_location -to "leds\[3\]" "Pin_$led_3" 
set_location -to "leds\[4\]" "Pin_$led_4" 
set_location -to "leds\[5\]" "Pin_$led_5" 
set_location -to "leds\[6\]" "Pin_$led_6" 
set_location -to "leds\[7\]" "Pin_$led_7" 

#################################
#### Make the LCD pin assignments

set_location -to "LCD_RW"      "Pin_$lcd_rw" 
set_location -to "LCD_RS"      "Pin_$lcd_rs" 
set_location -to "LCD_E"       "Pin_$lcd_e" 
set_location -to "LCD_DB\[0\]" "Pin_$lcd_db_0" 
set_location -to "LCD_DB\[1\]" "Pin_$lcd_db_1" 
set_location -to "LCD_DB\[2\]" "Pin_$lcd_db_2" 
set_location -to "LCD_DB\[3\]" "Pin_$lcd_db_3" 
set_location -to "LCD_DB\[4\]" "Pin_$lcd_db_4" 
set_location -to "LCD_DB\[5\]" "Pin_$lcd_db_5" 
set_location -to "LCD_DB\[6\]" "Pin_$lcd_db_6" 
set_location -to "LCD_DB\[7\]" "Pin_$lcd_db_7" 
# enable bus hold circitry
set_instance_assignment -name ENABLE_BUS_HOLD_CIRCUITRY ON -to LCD_DB

#################################
#### Make the dual seven segment pin assignments

set_location -to "seven_segs\[0\]" "Pin_$seven_seg_1_g" 
set_location -to "seven_segs\[1\]" "Pin_$seven_seg_1_f" 
set_location -to "seven_segs\[2\]" "Pin_$seven_seg_1_e" 
set_location -to "seven_segs\[3\]" "Pin_$seven_seg_1_d" 
set_location -to "seven_segs\[4\]" "Pin_$seven_seg_1_c" 
set_location -to "seven_segs\[5\]" "Pin_$seven_seg_1_b" 
set_location -to "seven_segs\[6\]" "Pin_$seven_seg_1_a" 

set_location -to "seven_segs\[7\]" "Pin_$seven_seg_10_g"  
set_location -to "seven_segs\[8\]" "Pin_$seven_seg_10_f"  
set_location -to "seven_segs\[9\]" "Pin_$seven_seg_10_e"  
set_location -to "seven_segs\[10\]" "Pin_$seven_seg_10_d"  
set_location -to "seven_segs\[11\]" "Pin_$seven_seg_10_c"  
set_location -to "seven_segs\[12\]" "Pin_$seven_seg_10_b"  
set_location -to "seven_segs\[13\]" "Pin_$seven_seg_10_a"  

set_location -to "dot_seven_seg_l" "Pin_$seven_seg_1_dot"  
set_location -to "dot_seven_seg_h" "Pin_$seven_seg_10_dot"  

#################################
#### Make the SRAM pin assignments
# SRAM Address
set_location -to "EXT_A\[0\]"  "Pin_$SRAM_A0"  
set_location -to "EXT_A\[1\]"  "Pin_$SRAM_A1"  
set_location -to "EXT_A\[2\]"  "Pin_$SRAM_A2"  
set_location -to "EXT_A\[3\]"  "Pin_$SRAM_A3"  
set_location -to "EXT_A\[4\]"  "Pin_$SRAM_A4"  
set_location -to "EXT_A\[5\]"  "Pin_$SRAM_A5"  
set_location -to "EXT_A\[6\]"  "Pin_$SRAM_A6"  
set_location -to "EXT_A\[7\]"  "Pin_$SRAM_A7"  
set_location -to "EXT_A\[8\]"  "Pin_$SRAM_A8"  
set_location -to "EXT_A\[9\]"  "Pin_$SRAM_A9"  
set_location -to "EXT_A\[10\]" "Pin_$SRAM_A10"  
set_location -to "EXT_A\[11\]" "Pin_$SRAM_A11"  
set_location -to "EXT_A\[12\]" "Pin_$SRAM_A12"  
set_location -to "EXT_A\[13\]" "Pin_$SRAM_A13"  
set_location -to "EXT_A\[14\]" "Pin_$SRAM_A14"  
set_location -to "EXT_A\[15\]" "Pin_$SRAM_A15"  
set_location -to "EXT_A\[16\]" "Pin_$SRAM_A16"  
set_location -to "EXT_A\[17\]" "Pin_$SRAM_A17"  

# SRAM data U35
set_location -to "EXT_D\[0\]"  "Pin_$SRAM_D0"  
set_location -to "EXT_D\[1\]"  "Pin_$SRAM_D1"  
set_location -to "EXT_D\[2\]"  "Pin_$SRAM_D2"  
set_location -to "EXT_D\[3\]"  "Pin_$SRAM_D3"  
set_location -to "EXT_D\[4\]"  "Pin_$SRAM_D4"  
set_location -to "EXT_D\[5\]"  "Pin_$SRAM_D5"  
set_location -to "EXT_D\[6\]"  "Pin_$SRAM_D6"  
set_location -to "EXT_D\[7\]"  "Pin_$SRAM_D7"  
set_location -to "EXT_D\[8\]"  "Pin_$SRAM_D8"  
set_location -to "EXT_D\[9\]"  "Pin_$SRAM_D9"  
set_location -to "EXT_D\[10\]" "Pin_$SRAM_D10"  
set_location -to "EXT_D\[11\]" "Pin_$SRAM_D11"  
set_location -to "EXT_D\[12\]" "Pin_$SRAM_D12"  
set_location -to "EXT_D\[13\]" "Pin_$SRAM_D13"  
set_location -to "EXT_D\[14\]" "Pin_$SRAM_D14"  
set_location -to "EXT_D\[15\]" "Pin_$SRAM_D15"  
# enable bus hold circitry
set_instance_assignment -name ENABLE_BUS_HOLD_CIRCUITRY ON -to EXT_D

# SRAM control lines U35
set_location -to "EXT_BEn\[1\]" "Pin_$SRAM_BE1_n"  
set_location -to "EXT_BEn\[0\]" "Pin_$SRAM_BE0_n"  
set_location -to "RAM_CEn"      "Pin_$SRAM_CS_n"  
set_location -to "EXT_RDn"      "Pin_$SRAM_OE_n"  
set_location -to "EXT_WRn"      "Pin_$SRAM_WE_n"  


# control lines for other drivers on the shared bus
set_location -to "Flash_CEn"     "Pin_$FLASH_CEn"  
set_location -to "ETHER_ADSn"    "Pin_$ETHER_ADSn"  
set_location -to "ETHER_DATACSn" "Pin_$ETHER_DATACSn"  

puts "Assigning pins finished"
