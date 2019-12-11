-- Copyright (C) 1991-2011 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "02/21/2011 21:46:44"
                                                            
-- Vhdl Test Bench template for design  :  CA2_SPT
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                
--$A
USE ieee.numeric_std.all;                             
--$E

ENTITY CA2_SPT_vhd_tst IS
END CA2_SPT_vhd_tst;

ARCHITECTURE CA2_SPT_arch OF CA2_SPT_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL buttons : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL clk_fast : STD_LOGIC;
SIGNAL dot_seven_seg_h : STD_LOGIC;
SIGNAL dot_seven_seg_l : STD_LOGIC;
SIGNAL ETHER_ADSn : STD_LOGIC;
SIGNAL ETHER_DATACSn : STD_LOGIC;
SIGNAL EXT_A : STD_LOGIC_VECTOR(17 DOWNTO 0);
SIGNAL EXT_BEn : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL EXT_D : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL EXT_RDn : STD_LOGIC;
SIGNAL EXT_WRn : STD_LOGIC;
SIGNAL Flash_CEn : STD_LOGIC;
SIGNAL LCD_DB : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL LCD_E : STD_LOGIC;
SIGNAL LCD_RS : STD_LOGIC;
SIGNAL LCD_RW : STD_LOGIC;
SIGNAL leds : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL RAM_CEn : STD_LOGIC;
SIGNAL seven_segs : STD_LOGIC_VECTOR(13 DOWNTO 0);
--
--$A  Application Definitions
CONSTANT n_data: integer := 16;
CONSTANT n_adr:  integer := 18;
--
SIGNAL Reset: STD_LOGIC := '1';
--
--$E

COMPONENT CA2_SPT
      PORT (
      buttons : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      clk_fast : IN STD_LOGIC;
      dot_seven_seg_h : OUT STD_LOGIC;
      dot_seven_seg_l : OUT STD_LOGIC;
      ETHER_ADSn : OUT STD_LOGIC;
      ETHER_DATACSn : OUT STD_LOGIC;
      EXT_A : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
      EXT_BEn : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      EXT_D : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      EXT_RDn : OUT STD_LOGIC;
      EXT_WRn : OUT STD_LOGIC;
      Flash_CEn : OUT STD_LOGIC;
      LCD_DB : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      LCD_E : OUT STD_LOGIC;
      LCD_RS : OUT STD_LOGIC;
      LCD_RW : OUT STD_LOGIC;
      leds : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      RAM_CEn : OUT STD_LOGIC;
      seven_segs : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
      );
END COMPONENT;
BEGIN
      i1 : CA2_SPT
      PORT MAP (
-- list connections between master ports and signals
      buttons => buttons,
      clk_fast => clk_fast,
      dot_seven_seg_h => dot_seven_seg_h,
      dot_seven_seg_l => dot_seven_seg_l,
      ETHER_ADSn => ETHER_ADSn,
      ETHER_DATACSn => ETHER_DATACSn,
      EXT_A => EXT_A,
      EXT_BEn => EXT_BEn,
      EXT_D => EXT_D,
      EXT_RDn => EXT_RDn,
      EXT_WRn => EXT_WRn,
      Flash_CEn => Flash_CEn,
      LCD_DB => LCD_DB,
      LCD_E => LCD_E,
      LCD_RS => LCD_RS,
      LCD_RW => LCD_RW,
      leds => leds,
      RAM_CEn => RAM_CEn,
      seven_segs => seven_segs
      );

--$A
-- Testprozesse (Stimuli-Generierung)
--
-- Taktgenerator für Simulation
ClockGen: PROCESS                                                                                
BEGIN                                                         
   clk_fast <= '0';
   Wait for 10 ns;
   clk_fast <= '1';
   wait for 10 ns;                                                     
END PROCESS ClockGen; 
--
-- Resetgenerator
ResetGen: PROCESS
BEGIN   
   buttons <= "110";   -- Buttons[0] == reset_n
   wait for 100 ns;
   buttons(0) <= '1';  
   wait;                                                     
END PROCESS ResetGen; 

Reset <= NOT buttons(0);

-- Nachbildung des externen RAMs: Ohne Zeitüberwachung; unphysikalisches Initialisieren
--                                Ohne Byte-enables
ExtRAM: PROCESS (EXT_RDn, EXT_WRn, EXT_D, EXT_A, Reset)
  TYPE ExternalRAM_TYPE is array (0 TO (2**n_adr-1)) OF STD_LOGIC_VECTOR((n_data-1) downto 0);
  variable External_RAM : ExternalRAM_TYPE;
  variable ram_D_OE      : boolean; -- ram treibt Datenbus ja/nein
  variable ram_outbuffer : STD_LOGIC_VECTOR((n_data-1) downto 0); -- unresolved ram out
BEGIN
  ram_D_OE := false; -- init
  IF (Reset = '1') THEN
      -- Initialisierung der ersten 64K Adressen auf U
      for i in 0 to (2**16-1) loop
         External_RAM(i) := (others => 'U');
      end loop;
      -- Belegung einiger weniger Adressen mit vorgegebenen Werten
      -- dies ist unphysikalisch, aber in einer Testbench moeglich
      External_RAM(16#00000#) := X"1234"; 
      External_RAM(16#00001#) := X"A5A5";
      External_RAM(16#005AF#) := X"5713";
      External_RAM(16#00A00#) := X"C000";
      External_RAM(16#00A05#) := X"C0C0";
      External_RAM(16#00A08#) := X"EFFE";
      External_RAM(16#00A0F#) := X"7306";
      External_RAM(16#03FFF#) := X"AFFE";
      External_RAM(16#05a5a#) := X"ABBA";
      External_RAM(16#0aa55#) := X"FA0E";
      External_RAM(16#0c000#) := X"BABA";
      External_RAM(16#0c000#) := X"AFFE";
      External_RAM(16#3FFFF#) := X"5678";
  ELSIF ( RAM_CEn = '0' and EXT_RDn = '0' and EXT_WRn = '1' ) THEN  
      ram_D_OE := true;  --  Lesezugriff: Daten outputs niederohmig 
  ELSIF ( RAM_CEn = '0' and                   EXT_WRn = '0' ) THEN  
      External_RAM(to_integer(unsigned(EXT_A))) := EXT_D;  -- schreiben: EXT_D in Zellfeld übernehmen
  END IF;

  if(ram_D_OE) then
     ram_outbuffer := External_RAM(to_integer(unsigned(EXT_A)));
  else
     ram_outbuffer := "ZZZZZZZZZZZZZZZZ";
     -- Modellierung eines Fehlerfalls -> RAM treibt Datenbus immer -> möglicher Kurzschluss auf Datenbus 
     --ram_outbuffer := External_RAM(to_integer(unsigned(EXT_A)));
  end if;
  EXT_D <= ram_outbuffer after 2 ns;  -- Ausgabe auf resolved Datenleitungen
END PROCESS ExtRAM;

END CA2_SPT_arch;

