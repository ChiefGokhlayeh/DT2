###############################################################################
# pin_assign.tcl
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

#################################
# Takt
set_location -to "clk" "PIN_$clk"

# Taster
set_location -to "HWreset_n_SW" "Pin_$button_3" 
set_location -to "STOPP_n_SW"   "Pin_$button_1" 
set_location -to "START_n_SW"   "Pin_$button_0" 

#LEDs
set_location -to "Td_Expired" "PIN_$led_0"
set_location -to "Warning_OK" "PIN_$led_1"
set_location -to "Tw_Expired" "PIN_$led_2"

# 7-Segment-Displays
set_location -to "Antrieb_n"  "PIN_$seven_seg_1_a"
set_location -to "LED" "PIN_$seven_seg_1_d"

set_location -to "State_Aus"      "PIN_$seven_seg_10_a"
set_location -to "State_Warnung"  "PIN_$seven_seg_10_g"
set_location -to "State_Ein"      "PIN_$seven_seg_10_d"

puts "Assigning pins finished"
