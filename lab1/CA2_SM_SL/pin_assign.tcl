###############################################################################
# pin_assign.tcl
#
#
# Autor: Prof. Walter Lindermeir
#
# You can run this script from Quartus by observing the following steps:
# 1. Place this TCL script in your project directory
# 2. Open your project
# 3. Go to the View Menu and Auxilary Windows -> TCL console
# 4. In the TCL console type:
#						source pin_assign.tcl
# 5. The script will assign pins and return an "assignment made" message.
###############################################################################

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

# prototype connector J12
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

set J11_3  P3
set J11_4  N10
# Takt
set_location -to clk    "PIN_$clk"

# Taster
set_location -to "HWreset_n_SW" "Pin_$button_3" 
set_location -to "RESET_n_SW"   "Pin_$button_2" 
set_location -to "STOPP_n_SW"   "Pin_$button_1" 
set_location -to "START_n_SW"   "Pin_$button_0" 

set_location -to "RUN"        "PIN_$led_0"
set_location -to "ZERO"       "PIN_$led_1"

# 7-Segment-Displays
set_location -to "seven_segs\[6\]"   "PIN_$seven_seg_1_a"
set_location -to "seven_segs\[5\]"   "PIN_$seven_seg_1_b"
set_location -to "seven_segs\[4\]"   "PIN_$seven_seg_1_c"
set_location -to "seven_segs\[3\]"   "PIN_$seven_seg_1_d"
set_location -to "seven_segs\[2\]"   "PIN_$seven_seg_1_e"
set_location -to "seven_segs\[1\]"   "PIN_$seven_seg_1_f"
set_location -to "seven_segs\[0\]"   "PIN_$seven_seg_1_g"

# LC Display
set_location -to "LCD_RW"            "Pin_$lcd_rw"
set_location -to "LCD_RS"            "Pin_$lcd_rs"
set_location -to "LCD_e"             "Pin_$lcd_e"
set_location -to "LCD_DB\[0\]"       "Pin_$lcd_db_0"
set_location -to "LCD_DB\[1\]"       "Pin_$lcd_db_1"
set_location -to "LCD_DB\[2\]"       "Pin_$lcd_db_2"
set_location -to "LCD_DB\[3\]"       "Pin_$lcd_db_3"
set_location -to "LCD_DB\[4\]"       "Pin_$lcd_db_4"
set_location -to "LCD_DB\[5\]"       "Pin_$lcd_db_5"
set_location -to "LCD_DB\[6\]"       "Pin_$lcd_db_6"
set_location -to "LCD_DB\[7\]"       "Pin_$lcd_db_7"
# enable bus hold circitry
set_instance_assignment -name ENABLE_BUS_HOLD_CIRCUITRY ON -to LCD_DB

puts "end of pin assignment"
