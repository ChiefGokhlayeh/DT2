LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.NUMERIC_STD.all;
USE ieee.std_logic_arith.all;
use work.ca2_sm_package.all;
--
--  Entity Declaration
--  (C) 2013 R. Keller, W. Lindermeir und W. Zimmermann

ENTITY Uhrenmodul is
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	GENERIC(MOD_UM : INTEGER := 50000);
	PORT
	(
		clk : IN STD_LOGIC;
		HW_Reset : IN STD_LOGIC;
		RUN : IN STD_LOGIC;
		ZERO : IN STD_LOGIC;
		Tim_msec : OUT STD_LOGIC_VECTOR(9 downto 0);
		Tim_sec : OUT STD_LOGIC_VECTOR(5 downto 0);
		Tim_min : OUT STD_LOGIC_VECTOR(5 downto 0);
		Tim_hour : OUT STD_LOGIC_VECTOR(9 downto 0)
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
END Uhrenmodul;


--  Architecture Body
ARCHITECTURE Uhrenmodul_architecture of Uhrenmodul is
  subtype Cnt60Type    is natural range 0 TO 59;
  subtype Cnt1000Type  is natural range 0 TO 999;

  signal  C_msec, C_msec_next : Cnt1000Type;
  signal  C_hour, C_hour_next : Cnt1000Type;
  signal  C_min,  C_min_next  : Cnt60Type;
  signal  C_sec,  C_sec_next  : Cnt60Type;

  signal  HW_Reset_n, FF_Enable : std_logic; 
begin

  -- Takt-Gating fuer Uhrenmodul
  -- muss fuer richtige Uhr aus dem 50MHz Takt clk Periodendauer von 1 msec erzeugen
  -- d.h. 50.000
  HW_Reset_n <= not HW_Reset;
  MOD_CLK_inst: entity work.Mod_Counter
                generic map(n => MOD_UM)
                port map (clk => clk, PUReset_n => HW_Reset_n, OVF => FF_Enable);

  ClockComb: process (RUN, ZERO, C_msec, C_sec, C_min, C_hour)
  begin
      -- Default: Uhr bleibt stehen
      C_msec_next <= C_msec;
      C_sec_next  <= C_sec;
      C_min_next  <= C_min;
      C_hour_next <= C_hour;
      if (RUN = '0' AND ZERO = '1') then
         -- Uhr rücksetzen
         C_msec_next <= 0;
         C_sec_next  <= 0;
         C_min_next  <= 0;
         C_hour_next <= 0;
      elsif (RUN = '1') then
         -- Millisekunde inkrementieren
         if (C_msec < 999) then
            C_msec_next <= C_msec + 1;
         else
            -- wrap-around bei Millisekunden
            C_msec_next <= 0;
            -- Sekunde inkrementieren
            if (C_sec < 59) then
               C_sec_next <= C_sec + 1;
            else
               -- wrap-around bei Sekunde
               C_sec_next <= 0;
               -- Minute inkrementieren
               if (C_min < 59) then
                  C_min_next <= C_min + 1;
               else
                  -- wrap-around bei Minute
                  C_min_next <= 0;
                  -- Stunde inkrementieren
                  if (C_hour < 999) then
                     C_hour_next <= C_hour + 1;
                  else
                     -- wrap-around bei Stunde (nach 1000 h): wir beginnen wieder bei Stunde 0
                     C_hour_next <= 0;
                  end if;
               end if;
            end if;
         end if;
      end if;
  end process ClockComb;

  ClockTrigger: process (clk, HW_Reset)
  begin
    if (HW_Reset = '1') then
       C_msec <= 0;
       C_sec  <= 0;
       C_min  <= 0;
       C_hour <= 0;
    elsif (rising_edge(clk)) then
       if (FF_Enable = '1') then
          C_msec <= C_msec_next;
          C_sec  <= C_sec_next;
          C_min  <= C_min_next;
          C_hour <= C_hour_next;
       end if;
    end if;
  end process ClockTrigger;

  -- Nebenlaeufe Zuweisung der Integer-Zaehler an die Ausgangssignale: Umwandlung integer nach std_logic_vector
  Tim_msec <= CONV_STD_LOGIC_VECTOR(C_msec, 10);
  Tim_sec  <= CONV_STD_LOGIC_VECTOR(C_sec, 6);
  Tim_min  <= CONV_STD_LOGIC_VECTOR(C_min, 6);
  Tim_hour <= CONV_STD_LOGIC_VECTOR(C_hour, 10);
END Uhrenmodul_architecture;
