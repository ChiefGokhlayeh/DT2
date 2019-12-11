-- WARNING: Do NOT edit the input and output ports in this file in a text
-- editor if you plan to continue editing the block that represents it in
-- the Block Editor! File corruption is VERY likely to occur.

-- Copyright (C) 1991-2005 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic       
-- functions, and any output files any of the foregoing           
-- (including device programming or simulation files), and any    
-- associated documentation or information are expressly subject  
-- to the terms and conditions of the Altera Program License      
-- Subscription Agreement, Altera MegaCore Function License       
-- Agreement, or other applicable license agreement, including,   
-- without limitation, that your use is for the sole purpose of   
-- programming logic devices manufactured by Altera and sold by   
-- Altera or its authorized distributors.  Please refer to the    
-- applicable agreement for further details.


-- Generated by Quartus II Version 5.0 (Build Build 168 06/22/2005)
-- Created on Sat Nov 19 15:16:15 2005

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Hochschule Esslingen, Fakultaet IT
-- (C) 2013 R. Keller, W. Lindermeir, W. Zimmermann 

ENTITY ADEC IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		Ext_A : IN STD_LOGIC_VECTOR(17 downto 0);
		RAM_CEn : OUT STD_LOGIC;
		Flash_CEn : OUT STD_LOGIC;
		ETHER_ADSn : OUT STD_LOGIC;
		ETHER_DATACSn : OUT STD_LOGIC
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
	
END ADEC;


--  Architecture Body

ARCHITECTURE ADEC_architecture OF ADEC IS

	
BEGIN
  -- Nur RAM adressiert, immer
  RAM_CEn       <= '0';
  -- Alle anderen sind nie adressiert
  Flash_CEn     <= '1';
  ETHER_ADSn    <= '1';
  ETHER_DATACSn <= '1';
END ADEC_architecture;
