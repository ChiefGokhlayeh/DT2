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
-- Generated on "02/17/2011 12:10:35"

-- Vhdl Test Bench template for design  :  CA2_SM
--
-- Simulation tool : ModelSim-Altera (VHDL)
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY CA2_SM_vhd_tst IS
END CA2_SM_vhd_tst;
ARCHITECTURE CA2_SM_arch OF CA2_SM_vhd_tst IS
-- constants
-- signals
SIGNAL LED : STD_LOGIC;
SIGNAL Antrieb_n : STD_LOGIC;
SIGNAL clk : STD_LOGIC;
SIGNAL HWreset_n_SW : STD_LOGIC;
SIGNAL START_n_SW : STD_LOGIC;
SIGNAL STOPP_n_SW : STD_LOGIC;
SIGNAL Tw_Expired : STD_LOGIC;
SIGNAL Td_Expired : STD_LOGIC;
SIGNAL Warning_OK : STD_LOGIC;
--$A
signal  INP: std_logic_vector(2 DOWNTO 0);
--$E
COMPONENT CA2_SM
	PORT (
	LED : OUT STD_LOGIC;
	Antrieb_n : OUT STD_LOGIC;
	clk : IN STD_LOGIC;
	HWreset_n_SW : IN STD_LOGIC;
	START_n_SW : IN STD_LOGIC;
	STOPP_n_SW : IN STD_LOGIC;
	Tw_Expired : OUT STD_LOGIC;
	Td_Expired : OUT STD_LOGIC;
	Warning_OK : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : CA2_SM
	PORT MAP (
-- list connections between master ports and signals
	LED => LED,
	Antrieb_n => Antrieb_n,
	clk => clk,
	HWreset_n_SW => HWreset_n_SW,
	START_n_SW => START_n_SW,
	STOPP_n_SW => STOPP_n_SW,
	Tw_Expired => Tw_Expired,
	Td_Expired => Td_Expired,
	Warning_OK => Warning_OK
	);
--$A
-- Testprozesse für Anlaufsteuerung
--
-- Taktgenerator für Simulation
ClockGen: PROCESS
BEGIN
        clk <= '0';
        Wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
END PROCESS ClockGen;
--
-- Input Signal Generator
InputGen : PROCESS
BEGIN
  -- INP-Vector: "111"(HWreset_n_SW, STOPP_n_SW, START_n_SW) : keiner der Buttons betätigt
  -- All Buttons are active low
  -- $$ Zeitlicher Ablauf der Eingangssignale:
  --  Reset
      INP <= "111";    wait for  30 ns;
      INP <= "011";    wait for  40 ns; -- Reset
      INP <= "111";    wait for 230 ns; -- Summe: 300 ns
  -- ==========================================================
  -- $$ Spezifischer Teil des zeitlichen Ablaufs
  -- $$ Teilaufgabe xxxx
      INP <= "111";    wait for  1 us;
      INP <= "110";    wait for 10 us;
      INP <= "111";    wait for 12 us;
      INP <= "110";    wait for  2 us;
      INP <= "111";    wait for 10 us;
      INP <= "101";    wait for 500 ns;
      INP <= "111";    wait for   1 us;
      INP <= "111";    wait for 500 ns;
  -- $$$ Ende spezifischer Teil
  -- ==========================================================
END PROCESS InputGen;

  HWreset_n_SW  <= INP(2);
  STOPP_n_SW    <= INP(1);
  START_n_SW    <= INP(0);
--
-- Ende Testprozesse für Anlaufsteuerung
--$E
END CA2_SM_arch;
