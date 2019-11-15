LIBRARY ieee;
USE ieee.std_logic_1164.all;

--  Digitaltechnik 2
--  (c) 2013 W. Zimmermann, W. Lindermeir, R. Keller

ENTITY PUReset_Generator IS
      -- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE! 
      GENERIC(DIV_PUR : INTEGER);
      PORT
      (
            clk : IN STD_LOGIC;
            PUReset_n : OUT STD_LOGIC
      );
      -- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
BEGIN
    ASSERT (DIV_PUR > 0) REPORT "Es muss gelten: DIV_PUR > 0" severity failure;
END PUReset_Generator;


--  Architecture Body
ARCHITECTURE PUReset_Generator_architecture OF PUReset_Generator IS
  -- Hinweis: Das initialisieren von Signalen geht so nur bei programmierbaren Bausteinen
  SIGNAL RCnt, RCntnext: integer range 0 to DIV_PUR := 0; 
BEGIN

-- Generieren PUReset_n (Power-Up-Reset)
-- PUReset is active low and applicable only once after power up
comb: process(RCnt) 
  variable PUR: std_logic;
begin
     -- next state
     If (RCnt < DIV_PUR) then
        Rcntnext <= RCnt + 1;
     else
        Rcntnext <= DIV_PUR;
     end if;
     -- output
     If (RCnt < DIV_PUR) then
        PUR := '0';
     else
        PUR := '1';
     end if;
     -- Zuweisung des Ausgangssignals
     PUReset_n <= PUR;
end process comb;

trigger: PROCESS (clk)
BEGIN
  If (clk'EVENT AND clk = '1') then
     RCnt <= Rcntnext;
  end if;
END PROCESS trigger;

END PUReset_Generator_architecture;
