LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.ca2_sm_package.all;

--  Digitaltechnik 2
--  (c) 2013 W. Zimmermann, W. Lindermeir, R. Keller

ENTITY AnlaufSteuerung IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	GENERIC(MOD_SM : INTEGER := 50);
	PORT
	(
		clk : IN STD_LOGIC;
		HW_Reset : IN STD_LOGIC;
		START : IN STD_LOGIC;
		STOPP : IN STD_LOGIC;
		Warning_OK : IN STD_LOGIC;
		Tw_Expired : IN STD_LOGIC;
		Td_Expired : IN STD_LOGIC;
		Antrieb_n : OUT STD_LOGIC;
		LED_On_Off : OUT STD_LOGIC;
		LED_blink_flag : OUT STD_LOGIC;
		TimersResetStart : OUT STD_LOGIC;
		State_Aus : OUT STD_LOGIC;
		State_Warnung : OUT STD_LOGIC;
		State_Ein : OUT STD_LOGIC
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
end AnlaufSteuerung;

--  Architecture Body
ARCHITECTURE AnlaufSteuerung_architecture OF AnlaufSteuerung IS
   signal FF_Enable: std_logic;
   -- Automat zur Flankenerkennung
   Type   EdgeDetectType is (Init, Flanke_geloescht, Flanke_erkannt);
   signal EdgeState, NextEdgeState : EdgeDetectType;

   -- Automat der Anlaufsteuerung
   Type StateType is (AntriebAUS, AntriebEIN, Anlaufwarnung);
   signal ActState, NextState: StateType;
   -- D-FF für transtion_action
   signal TimersResetStartReg : std_logic;

   -- Interface-Signale der beiden Automaten
   signal StartRisingEdge : std_logic;
   signal Ack: std_logic;

   signal HW_Reset_n    : std_logic;
begin

-- Takt-Gating
HW_Reset_n <= not HW_Reset;
MOD_CLK_inst: entity work.Mod_Counter
              generic map(n => MOD_SM)
              port map (clk => clk, PUReset_n => HW_Reset_n, OVF => FF_Enable);

-- Verdrahtung des D-FFs mit Ausgang
TimersResetStart <= TimersResetStartReg;

-------------------------------
-- Automat der Flankenerkennung
-------------------------------
CombFlanke: process (START, EdgeState, Ack) IS
begin
   -- Übergangsfunktion
   NextEdgeState <= EdgeState; -- default Ringpfeil
   case EdgeState IS
       when Init             => if (START = '0' and Ack = '0') THEN
                                   NextEdgeState <= Flanke_geloescht;
                                end if;
       when Flanke_geloescht => if (Ack = '1') then
                                   NextEdgeState <= Init;
                                elsif( START = '1') then
                                   NextEdgeState <= Flanke_erkannt;
                                end if;
       when Flanke_erkannt   => if (Ack = '1') THEN
                                   NextEdgeState <= Init;
                                end if;
   end case;
   -- Ausgangsfunktion des Mealy-Automaten
   case EdgeState IS
       when Init             => StartRisingEdge <= '0';
       when Flanke_geloescht => StartRisingEdge <= START;
       when Flanke_erkannt   => StartRisingEdge <= not Ack;
   end case;
end process CombFlanke;

-- Trigger des Automaten
TriggerFlanke: process (HW_Reset, clk) IS
begin
   if (HW_Reset = '1') THEN
      EdgeState <= Init;
   elsif (rising_edge(clk)) then
      if( FF_Enable = '1') THEN
         EdgeState <= NextEdgeState;
      end if;
   end if;
end process TriggerFlanke;

------------------------------
-- Automat der Anlaufsteuerung
------------------------------
CombAnlauf: process (START, STOPP, Warning_OK, Tw_Expired, Td_Expired, ActState, StartRisingEdge) IS
begin
   -- Übergangsfunktion
   NextState <= ActState;    -- default Ringpfeil
   case ActState IS
       when AntriebAUS    => if (STOPP = '0' and StartRisingEdge = '1') THEN
                                NextState <= AnlaufWarnung;  -- Übergang T1
                             end if;
       when Anlaufwarnung => if (STOPP = '1' OR Tw_Expired = '1' OR Td_Expired ='1') THEN
                                NextState <= AntriebAUS;     -- Übergang T4
                             elsif (StartRisingEdge = '1' and Warning_OK = '1') then
                                NextState <= AntriebEIN;     -- Übergang T2
                             end if;
       when AntriebEIN    => if (STOPP = '1') THEN
                                NextState <= AntriebAUS;     -- Übergang T3
                             end if;
   end case;
   -- Actions: Signale "halten"
   -- Ausgangsfunktion eines Moore-Automaten
   case ActState IS
      when AntriebAUS    => LED_On_Off      <= '0';
                            Antrieb_n       <= '1';  -- Active Low
                            LED_blink_flag  <= '0';
		                    State_Aus       <= '0'; -- debug output low active
		                    State_Warnung   <= '1'; -- debug output low active
		                    State_Ein       <= '1'; -- debug output low active
      when Anlaufwarnung => LED_On_Off      <= '0';
                            Antrieb_n       <= '1';  -- Active Low
                            LED_blink_flag  <= '1';
		                    State_Aus       <= '1'; -- debug output low active
		                    State_Warnung   <= '0'; -- debug output low active
		                    State_Ein       <= '1'; -- debug output low active
      when AntriebEIN    => LED_On_Off      <= '1';
                            Antrieb_n       <= '0';  -- Active Low
                            LED_blink_flag  <= '0';
		                    State_Aus       <= '1'; -- debug output low active
		                    State_Warnung   <= '1'; -- debug output low active
		                    State_Ein       <= '0'; -- debug output low active
   end case;
end process CombAnlauf;

-- Trigger des Automaten
TriggerAnlauf: process (HW_Reset, clk) IS
begin
   if (HW_Reset = '1') THEN
      ActState  <= AntriebAUS;
      TimersResetStartReg <= '0';
      Ack <= '0';
   elsif (rising_edge(clk)) then
      if( FF_Enable = '1') THEN
         ActState  <= NextState;
         -- Implementierung der transtion_action
         if(ActState = AntriebAUS and NextState = Anlaufwarnung)then
             TimersResetStartReg <= '1';  -- Übergang T1
         else
             TimersResetStartReg <= '0';
         end if;
         -- Flanke immer sofort als Erkannt zurücksetzen, wenn eine Flanke erkannt worden ist. 
         -- Kein Speichern einer erkannten Flanke
         if(StartRisingEdge = '1') then
            Ack <= '1';
         else
            Ack <= '0';
         end if;
      end if;
   end if;
end process TriggerAnlauf;

end AnlaufSteuerung_architecture;
