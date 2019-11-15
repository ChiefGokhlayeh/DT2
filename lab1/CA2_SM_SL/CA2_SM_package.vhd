LIBRARY ieee;
USE ieee.std_logic_1164.all;

--  Digitaltechnik 2
--  (c) 2013 W. Zimmermann, W. Lindermeir, R. Keller

package ca2_sm_package is

  component Mod_Counter 
    GENERIC(n : integer);
    PORT ( clk, PUReset_n :  IN  STD_LOGIC;
           OVF            :  OUT STD_LOGIC );
  end component;

end ca2_sm_package;



LIBRARY ieee;
USE ieee.std_logic_1164.all;
--  Mod_Counter: Zaehler modulo n, der beim wrap-around OVF fuer einen clk-cycle auf 1 setzt
ENTITY Mod_Counter IS
  GENERIC(n : integer);
  PORT ( clk, PUReset_n :  IN  STD_LOGIC;
         OVF          :  OUT STD_LOGIC -- Overflow
  );
BEGIN
    ASSERT (n > 1) REPORT "Es muss gelten: n > 1" severity failure;
END Mod_Counter;

ARCHITECTURE Mod_Counter_Arch OF Mod_Counter IS
  SUBTYPE Cntmax IS INTEGER RANGE 0 TO (n-1);
  SIGNAL  Cnt, NextCnt : Cntmax;
BEGIN
  comb: PROCESS (Cnt)
  BEGIN
     -- Next state
     IF (Cnt < (n - 1)) THEN
        NextCnt <= Cnt + 1; 
     ELSE
        NextCnt <= 0; -- Zaehler MOD n
     END IF;
  
     -- Ausgangsfunktion
     IF (Cnt < (n-1)) THEN
        OVF <= '0';
     ELSE
        OVF <= '1';   -- Overflow fuer einen Takt
     END IF;
  END PROCESS comb;
  
  Trigger: PROCESS (clk, PUReset_n)
  BEGIN
     IF (PUReset_n = '0') THEN
        Cnt <= 0;
     ELSIF (clk'event AND clk = '1') THEN
        Cnt <= NextCnt;
     END IF;
  END PROCESS Trigger;
END Mod_Counter_Arch;


