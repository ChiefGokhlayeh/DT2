LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.NUMERIC_STD.all;

--  Digitaltechnik 2
--  (c) 2013 W. Zimmermann, W. Lindermeir, R. Keller

ENTITY Einzelentpreller IS
   GENERIC(Min_Button_Pressed  : positive ; 
           Min_Out_Active      : positive );
   PORT
   ( clk         : IN  STD_LOGIC;
     FF_Enable   : IN  STD_LOGIC;
     Reset_n     : IN  STD_LOGIC;
     in_sig      : IN  STD_LOGIC;   -- active low
     out_sig     : OUT STD_LOGIC);  -- active high
END Einzelentpreller;

ARCHITECTURE Entwurf OF Einzelentpreller IS
   TYPE   StateType IS (wait_for_b_release, wait_for_b_press, Out_Active);
   SIGNAL Z, Z_Next: StateType;
   
   SIGNAL  CntIn,  NextCntIn  : INTEGER RANGE 0 TO Min_Button_Pressed;
   SIGNAL  CntOut, NextCntOut : INTEGER RANGE 0 TO Min_Out_Active;
BEGIN

comb: process(Z, CntIn, CntOut, in_sig) is
begin
   Z_Next    <= Z;      -- Init default assignments
   NextCntIn <= CntIn;
   NextCntOut <= CntOut;
   case Z is
      when wait_for_b_release => if( in_sig = '1' ) then    -- button released
                                     Z_Next <= wait_for_b_press;
                                     NextCntIn <= 0;
                                 end if;
      when wait_for_b_press   => if( in_sig = '1') then -- button released
                                     NextCntIn <= 0;
                                 else                   -- button pressed
                                     if( CntIn < Min_Button_Pressed ) then
                                                        -- not yet long enough
                                        NextCntIn <= CntIn + 1;
                                     else               -- long enough
                                        Z_Next <= Out_Active;
                                        NextCntOut <= 0;
                                     end if;
                                 end if;
      when Out_Active         => if( CntOut < Min_Out_Active ) then 
                                    -- activate output for Min_Out_Active cycles
                                    NextCntOut <= CntOut + 1;
                                 elsif( in_sig = '1' ) then  
                                    -- button released
                                    Z_Next <= wait_for_b_press;
                                    NextCntIn <= 0;
                                    -- if button still pressed, keep on waiting for its release
                                 end if;
   end case;

   case Z is
      when wait_for_b_release => out_sig <= '0';  
      when wait_for_b_press   => out_sig <= '0';
      when Out_Active         => out_sig <= '1';
   end case;
end process comb;

trigger: process(Reset_n, clk) is 
begin
  if( Reset_n = '0') then
      Z      <= wait_for_b_release;
      CntIn  <= 0;
      CntOut <= 0;
  elsif (rising_edge(clk)) then
      if( FF_Enable = '1' ) then
         Z      <= Z_Next;
         CntIn  <= NextCntIn;
         CntOut <= NextCntOut;
      end if;
  end if;
end process trigger;
 
END Entwurf;

--
-- Entpreller fuer alle Tasten
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ca2_sm_package.all;

ENTITY Tastenentpreller IS
      -- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
      GENERIC(Min_Button_Pressed : INTEGER;
              Min_Out_Active     : INTEGER;
              MOD_TP             : INTEGER );
      PORT
      (
            clk : IN STD_LOGIC;
            PUReset_n : IN STD_LOGIC;
            HWreset_n_SW : IN STD_LOGIC;
            STOPP_n_SW : IN STD_LOGIC;
            START_n_SW : IN STD_LOGIC;
            RESET_n_SW : IN STD_LOGIC;
            STOPP : OUT STD_LOGIC;
            START : OUT STD_LOGIC;
            RESET : OUT STD_LOGIC;
            HW_Reset : OUT STD_LOGIC
      );
      -- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
END Tastenentpreller;

--  Architecture Body
ARCHITECTURE Tastenentpreller_architecture OF Tastenentpreller IS
  SIGNAL HWR_n: STD_LOGIC;
  SIGNAL FF_Enable: STD_LOGIC;
  SIGNAL HW_Reset_i  : STD_LOGIC;
BEGIN

-- Takt-Gating fuer die Entpreller
MOD_CLK_inst: entity work.Mod_Counter
              generic map(n => MOD_TP)
              port map (clk => clk, PUReset_n => PUReset_n, OVF => FF_Enable);

-- Entprellung der Taster
TP_START: entity work.Einzelentpreller
          generic map (Min_Button_Pressed => Min_Button_Pressed, Min_Out_Active => Min_Out_Active)
          port map (FF_Enable => FF_Enable, Reset_n => HWR_n, in_sig => START_n_SW,
                    out_sig => START, clk => clk);
TP_STOPP: entity work.Einzelentpreller
          generic map (Min_Button_Pressed => Min_Button_Pressed, Min_Out_Active => Min_Out_Active)
          port map (FF_Enable => FF_Enable, Reset_n => HWR_n, in_sig => STOPP_n_SW,
                    out_sig => STOPP, clk => clk);
TP_RESET: entity work.Einzelentpreller
          generic map (Min_Button_Pressed => Min_Button_Pressed, Min_Out_Active => Min_Out_Active)
          port map (FF_Enable => FF_Enable, Reset_n => HWR_n, in_sig => RESET_n_SW,
                    out_sig => RESET, clk => clk);
TP_HWRES: entity work.Einzelentpreller
          generic map (Min_Button_Pressed => Min_Button_Pressed, Min_Out_Active => Min_Out_Active)
          port map (FF_Enable => FF_Enable, Reset_n => PUReset_n, in_sig => HWreset_n_SW,
                    out_sig => HW_Reset_i, clk => clk);

-- Reset entweder von Taster oder von Power-Up-Reset Schaltung
HWR_n <= (not HW_Reset_i) AND PUReset_n;

-- Synchronisation des Reset-Signals
Sync_Reset: PROCESS (clk)
BEGIN
   IF (rising_edge(clk))THEN
      HW_Reset   <= NOT HWR_n;
   END IF;
END PROCESS Sync_Reset;

END Tastenentpreller_architecture;
