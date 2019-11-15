LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ca2_sm_package.all;
--
--  Entity Declaration
--  (C) 2013 R. Keller, W. Lindermeir und W. Zimmermann

ENTITY StoppuhrSteuerung IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	GENERIC(MOD_SM : INTEGER);
	PORT
	(
		clk : IN STD_LOGIC;
		HW_Reset : IN STD_LOGIC;
		START : IN STD_LOGIC;
		STOPP : IN STD_LOGIC;
		RESET : IN STD_LOGIC;
		RUN : OUT STD_LOGIC;
		ZERO : OUT STD_LOGIC;
		seven_segs : OUT STD_LOGIC_VECTOR(6 downto 0)
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
END StoppuhrSteuerung;

--  Architecture Body
ARCHITECTURE StoppuhrSteuerung_architecture OF StoppuhrSteuerung IS
  SIGNAL HWRn: STD_LOGIC;        -- Invertierter Reset
  SIGNAL FF_Enable: STD_LOGIC;   -- Clock-Gating Automat
BEGIN

  -- Default-Implementierung der Stoppuhrsteuerung als kombinatorische Schaltung
  RUN  <= '0' WHEN HW_Reset = '1' ELSE (START AND (NOT STOPP) AND (NOT RESET));
  ZERO <= '0' WHEN HW_Reset = '1' ELSE (RESET AND (NOT STOPP) AND (NOT START));
  seven_segs <= "0000001" WHEN HW_Reset = '1' ELSE "1111110";
  --
  -- Ergibt nicht die geforderte Funktion!
  --
  -- Sie benötigen für eine korrekte Funktion eine sequentielle Schaltung
  -- Führen Sie den geforderten ANFANGSTEST durch, ohne diese Datei zu modifizieren.
  -- Löschen Sie danach die oberen 3 nebenläufigen Signalzuweisungen und implementieren
  -- Sie den Automaten nach Ihrem Entwurf analog dem VHDL-Automaten der Vorlesung





  -- Die nachfolgenden Anweisungen werden erst für die Implementierung des Lauflichts benötigt.
  -- Sie spielen für die Stoppuhr zunächst keine Rolle.
  -- Takt-Gating fuer Lauflicht, damit die Geschwindigkeit des Lauflichts eingestellt werden kann
  HWRn <= NOT HW_Reset ;
  Clki_inst: entity work.Mod_Counter
             generic map(n => MOD_SM)
             port map (clk => clk, PUReset_n => HWRn, OVF => FF_Enable);

END StoppuhrSteuerung_architecture;
