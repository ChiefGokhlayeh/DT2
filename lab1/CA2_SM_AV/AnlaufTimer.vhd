LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ca2_sm_package.all;

--  Entity Declaration
--  Digitaltechnik 2
--  (c) 2013 W. Zimmermann, W. Lindermeir, R. Keller

ENTITY AnlaufTimer IS
      -- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
      GENERIC(MOD_AT          : INTEGER;
              Tw_min          : INTEGER;
              Tw_max          : INTEGER;
              Td_max          : INTEGER;
              BlinkHalfPeriod : INTEGER    );
      PORT
      (
            clk : IN STD_LOGIC;
            HW_Reset : IN STD_LOGIC;
            LED_blink_flag : IN STD_LOGIC;
            TimersResetStart : IN STD_LOGIC;
            START : IN STD_LOGIC;
            Warning_OK : OUT STD_LOGIC;
            Tw_Expired : OUT STD_LOGIC;
            Td_Expired : OUT STD_LOGIC;
            LED_blink_state : OUT STD_LOGIC
      );
      -- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
begin
   assert ((Tw_max > Tw_min)) REPORT "Es muss gelten: Tw_max > Tw_min" severity failure;
   assert ((BlinkHalfPeriod > 0)) REPORT "Es muss gelten: BlinkHalfPeriod > 0" severity failure;
end AnlaufTimer;
--
--  Architecture Body
--
ARCHITECTURE AnlaufTimer_architecture OF AnlaufTimer IS

   signal  FF_Enable: STD_LOGIC;

   -- Typen und Signale für Timer Tw
   subtype TwCntType    IS integer range 0 TO Tw_max-1;
   signal  TwCnt, NextTwCnt : TwCntType;

   -- Typen und Signale für Timer Td
   TYPE    TdStateType IS (Stopped, Running);
   signal  TdState, NextTdState: TdStateType;
   subtype TdCntType    IS integer range 0 TO Td_max-1;
   signal  TdCnt, NextTdCnt : TdCntType;

   -- Typen und Signale für Blinken der LED
   subtype cntBlinkType IS integer range 0 TO 2*BlinkHalfPeriod-1;
   signal  CntBlink, NextCntBlink : cntBlinkType;

   Signal HW_Reset_n : std_logic; -- unser Mod_Counter braucht Reset negiert
begin

-- Takt-Gating
HW_Reset_n <= not HW_Reset;
MOD_CLK_inst: entity work.Mod_Counter
              generic map(n => MOD_AT)
              port map (clk => clk, PUReset_n => HW_Reset_n, OVF => FF_Enable);  

--------------------------------
-- Implementierung des Timers Tw
--------------------------------
-- Dieser Timer wird mit dem Signal TimersResetStart=1 auf 0 gesetzt. 
-- Der Timer läuft immer bis zu seinem höchsten Zählerstand (Tw_max-1) und hält dann an.
-- Er kann auch bevor er den Endstand erreichthat durch TimersResetStart=1 wieder auf 0 gesetzt werden. 
-- Man sagt, der Timer ist "re-triggerbar"
-- Hinweis: Der Timer wird nicht gestoppt, d.h. z.B. Tw_Expired wird im Fall dass der Antrieb erfolgreich
--          eingeschaltet wird irgendwann später aktiviert, wenn der Antrieb schon läuft. 
Tw_Comb: process (TwCnt, TimersResetStart) is
begin
   -- Übergangsfunktion des Zählers des Timers Tw
   if (TimersResetStart = '1' ) then
      NextTwCnt <= 0;
   else
      if(TwCnt >= Tw_max - 1) then
         NextTwCnt <= Tw_max - 1; -- auf Endstand stoppen
      else
         NextTwCnt <= TwCnt + 1;  -- inkrementieren
      end if;
   end if;

   -- output
   if( TwCnt >= (Tw_max - 1)) then
      Warning_OK <= '0';
      Tw_Expired <= not TimersResetStart;-- Tw hier immer abgelaufen, außer wenn gerade retriggert wird 
   elsif ( TwCnt >= (Tw_min - 1)) then    
      Warning_OK <= not TimersResetStart;-- Warnung hier immer OK, außer wenn gerade retriggert wird 
      Tw_Expired <= '0';
   else
      Warning_OK <= '0';
      Tw_Expired <= '0';
   end if;
end process Tw_Comb;

Tw_Trigger: process (HW_Reset, clk) IS
begin
   if(HW_Reset = '1') then
      TwCnt   <= Tw_max-1;   -- init auf Endstand, damit der Timer nicht gleich losläuft
   elsif(rising_edge(clk) ) then
      if( FF_Enable = '1') then 
          TwCnt <= NextTwCnt;
      end if;
   end if;
end process Tw_Trigger;
--------------------------------
-- Ende Implementierung Timer Tw
--------------------------------

--------------------------------
-- Implementierung des Timers Td
--------------------------------
-- Dieser Timer wird mit dem Signal TimersResetStart=1 auf 0 gesetzt und gestartet.
-- Der Timer läuft solange START == 1 ist, d.h. solange die Start-Taste gedrueckt ist
-- Wenn die START == 0 wird, wird der Timer gestoppt. Er kann dann erst wieder mit TimersResetStart=1 anlaufen.
-- Im Gegensatz zum Timer Tw muss hier verhindert werden, dass der Timer weiter bis zu seinem 
-- Endstand läuft, weil sonst immer Td_Expired gesetzt wird, was in unserer Applikation nicht sein darf.
Td_Comb: process (TdCnt, TdState, TimersResetStart, START) is
begin
   -- Übergangsfunktion für Automat TdState, der den Timer Td steuert
   if( START = '0' ) then -- Achtung: hier impliziete Priorisierung Start=0 und TimersResetStart=1
      NextTdState <= Stopped; 
   elsif (TimersResetStart = '1' ) then
      NextTdState <= Running; 
   else
      NextTdState <= TdState;
   end if; 

   -- Übergangsfunktion des eigentlichen Zählers des Timers Td
   if (TimersResetStart = '1' ) then
      NextTdCnt <= 0;
   elsif (TdState = Running) then
      -- Timer Td inkrementieren
      if(TdCnt >= (Td_max - 1)) then
         NextTdCnt <= Td_max - 1;
      else
         NextTdCnt <= TdCnt + 1;
      end if;
   else
      NextTdCnt <= TdCnt;
   end if;

   -- output
   if( TimersResetStart = '0' and TdCnt >= (Td_max - 1)) then
          Td_Expired <= '1';
   else
          Td_Expired <= '0';
   end if;
end process Td_Comb;

Td_Trigger: process (HW_Reset, clk) IS
begin
   if(HW_Reset = '1') then
      TdCnt   <= 0;
      TdState <= Stopped;
   elsif(rising_edge(clk) ) then
      if( FF_Enable = '1') then 
          TdCnt   <= NextTdCnt;
          TdState <= NextTdState;
      end if;
   end if;
end process Td_Trigger;
--------------------------------
-- Ende Implementierung Timer Td
--------------------------------

----------
-- Blinker
----------
Blinker_Comb: process (CntBlink, LED_blink_flag) is
begin
    -- next state
    if( LED_blink_flag = '0' ) then                  -- disable blink function
       NextCntBlink <= BlinkHalfPeriod-1;
    else
       if(CntBlink >= 2*BlinkHalfPeriod - 1) then 
          NextCntBlink <= 0;                  -- counter wrap-around
       else                                
          NextCntBlink <= CntBlink + 1;
       end if;
    end if;

    -- output
    if( CntBlink <= BlinkHalfPeriod-1 ) then
       LED_blink_state <= '0';    -- LED toggeln
    else
       LED_blink_state <= '1';    -- LED toggeln
    end if;
end process Blinker_Comb;

Blinker_Trigger: process (HW_Reset, clk) IS
begin
   if(HW_Reset = '1') then 
      CntBlink <= BlinkHalfPeriod-1;
   elsif(rising_edge(clk)) then
      if( FF_Enable = '1') then
          CntBlink <= NextCntBlink;
      end if;
   end if;
end process Blinker_Trigger;

end AnlaufTimer_architecture;
