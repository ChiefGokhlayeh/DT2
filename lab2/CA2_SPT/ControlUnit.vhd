-- Hochschule Esslingen, Fakultaet IT
-- (C) 2013 R. Keller, W. Lindermeir, W. Zimmermann 

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.microprog_types.all;

--  Entity Declaration
ENTITY ControlUnit IS
GENERIC(IPTR_MAX : POSITIVE := IPTR_MAX);
      -- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
      PORT
      (
            clk : IN STD_LOGIC;
            reset_n : IN STD_LOGIC;
            OPCODE : IN STD_LOGIC_VECTOR(3 downto 0);
            OPERAND : IN STD_LOGIC_VECTOR(15 downto 0);
            EXT_A : OUT STD_LOGIC_VECTOR(17 downto 0);
            EXT_RDn : OUT STD_LOGIC;
            EXT_WRn : OUT STD_LOGIC;
            EXT_BEn : OUT STD_LOGIC_VECTOR(1 downto 0);
            TCnt_Display : OUT STD_LOGIC_VECTOR(2 downto 0);
            IP : OUT STD_LOGIC_VECTOR(7 downto 0);
            EXT_D : INOUT STD_LOGIC_VECTOR(15 downto 0)
      );
      -- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
END ControlUnit;

--  Architecture Body
ARCHITECTURE ControlUnit_architecture OF ControlUnit IS
  --
  -- Zaehler fuer Ablauf des Transfers
  CONSTANT TMAX : NATURAL := 4;
  SUBTYPE TrnCntType IS NATURAL RANGE 0 TO TMAX;
  SIGNAL  TrnCnt, NextTrnCnt: TrnCntType;
  
  -- Funktionale Register (frei Nutzbar für Applikation)
  signal ADR_D, ADR: std_logic_vector (17 downto 0);  -- Adressregister
  signal DAT_D, DAT: std_logic_vector (15 downto 0);  -- Datenregister
  signal RDn_D, RDn : std_logic;
  signal WRn_D, WRn : std_logic;
  signal OE_Dn_D,     OE_Dn     : std_logic;
  signal IP_int_D, IP_int: NATURAL RANGE 0 TO IPTR_MAX;

  -- Datenbus-Ausgang, wie er direkt vom Steuerwerk des FPGAs getrieben wird (unresolved!)
  SIGNAL EXT_D_internal : STD_LOGIC_VECTOR(15 downto 0); -- nur zum Ansehen in Modelsim
BEGIN
  -- Zaehler TrnCnt:
  Comb_TrnCnt: PROCESS (TrnCnt)
  BEGIN
    IF (TrnCnt < TMAX) THEN
      NextTrnCnt <= TrnCnt + 1;
    ELSE
      NextTrnCnt <= 0;
    END IF;
  END PROCESS;
  
  Trigger_TrnCnt: PROCESS (clk, reset_n)
  BEGIN
    IF (reset_n = '0') THEN
      TrnCnt <= 0;
    ELSIF (clk'event AND clk = '1') THEN
      TrnCnt <= NextTrnCnt;
    END IF;
  END PROCESS;


Ctrl_comb: process(TrnCnt, OPCODE, OPERAND, EXT_D, RDn, WRn, OE_Dn, IP_int, DAT, ADR)
  begin
       -- Default Zuweisungen (alle Signale zunaechst unveraendert)
       RDn_D       <=  RDn;
       WRn_D       <=  WRn;
       OE_Dn_D     <=  OE_Dn;    
       IP_int_D    <=  IP_int;     
       DAT_D       <=  DAT;      
       ADR_D       <=  ADR;      

       CASE (TrnCnt) IS
          WHEN 0 => -- Hier wird der aktuelle Befehl aus dem Mikroprogramm (OPCODE), auf den IP zeigt, 
                    -- untersucht (dekodiert). Da der OPCODE während des ganzen Zyklus anliegt,
                    -- muss die Information was zu tun ist, nicht gespeichert werden, weil sie ja 
                    -- im OPCODE schon gespeichert ist.
                    -- * Nur die Befehle LDA, LDD werden sofort ausgefuehrt.
                    -- * Die Befehle MVI und MVO weden über den Zyklus von TrnCnt verteilt ausgeführt.
                    -- * Die Befehle wie STP, JMP, die den nachfolgenden Microprogrammbefehl bestimmen,
                    --       werden erst im letzten Zyklus von TrnCnt ausgeführt.

                    -- Initialisierungen: alle Signale auf inaktiv setzen
                    RDn_D        <= '1';
                    WRn_D        <= '1';
                    OE_Dn_D      <= '1';
                    CASE (OPCODE) IS
                       WHEN MICRO_LDA => -- Es koennen nur 16 Adressleitungen gesetzt werden,
                                         -- d.h. A17 u. A16 sind immer = 0
                                         ADR_D(15 downto  0)  <= OPERAND;
                                         ADR_D(17 downto 16)  <= "00";
                       WHEN MICRO_LDD => DAT_D  <= OPERAND;
                       WHEN OTHERS    => --- Illegal Instruction, ignorieren
                                         --- Hier Fehlerflag setzen
                                         --- Sonst: Funktion wie NOP
                    END CASE;
          WHEN 1 => -- Ausfuehren der Transfer-Befehle
                    IF (OPCODE = MICRO_MVI) THEN
                        RDn_D <= '0';  -- Lesesignal aktivieren
                    ELSIF (OPCODE = MICRO_MVO) THEN
                        WRn_D <= '0';  -- Schreibsignal aktivieren
                    END IF;
          WHEN 2 => -- Bei WR Daten niederohmig
                    IF (OPCODE = MICRO_MVO) THEN
                       OE_Dn_D  <= '0';   -- FPGA treibt den Datenbus
                    END IF;
          WHEN 3 => -- Bei RD Daten einlesen
                    IF (OPCODE = MICRO_MVI) THEN
                       DAT_D <= EXT_D;  -- Daten vom Datenbus auf D-Eingang von DAT-Register schalten
                    END IF;
                    -- WRn und RDn inaktiv schalten
                    WRn_D <= '1';
                    RDn_D <= '1';
          WHEN 4 => OE_Dn_D     <= '1'; -- Datenbus hochohmig schalten

                    -- Letzte Phase der Befehlsausfuehrung: 
                    -- IP (IP_int) fuer den nachfolgenden Befehl ermitteln
                    CASE (OPCODE) IS  
                       WHEN MICRO_STP => IP_int_D <= IP_int;  -- naechsten IP nicht aendern
                       WHEN MICRO_JMP => IP_int_D <= 0;     -- naechsten IP = 0 setzen
                       WHEN OTHERS    => -- normaler Befehl: IP Inkrementieren (modulo)
                                         IF (IP_int < IPTR_MAX) THEN
                                            IP_int_D <= IP_int + 1;
                                         ELSE
                                            IP_int_D <= 0;
                                         END IF;
                    END CASE;
          WHEN OTHERS =>  -- Kein Register und kein Signal aendern.
       END CASE;
  END PROCESS Ctrl_comb;
  
  FFs_Ausgaenge: PROCESS (clk, reset_n)
  BEGIN   
    -- Hier wird fuer jedes Signal ein D-FF bzw. fuer jedes Signalbuendel ein Register beschrieben
    -- Dies ist kein Automat im engeren Sinne, sondern nur Speicher fuer die benoetigten Signale
    IF reset_n = '0' THEN 
       RDn       <= '1';     -- Lese- und Schreibsignal inaktiv
       WRn       <= '1';
       OE_Dn     <= '1';     -- Datenbustreiber deaktivieren
       IP_int    <=  0;
       DAT       <= X"0000";
       ADR       <= X"FFFF"&"11";
    ELSIF (clk'event AND clk = '1') THEN
       RDn       <= RDn_D;
       WRn       <= WRn_D;
       OE_Dn     <= OE_Dn_D;    
       IP_int    <= IP_int_D;     
       DAT       <= DAT_D;      
       ADR       <= ADR_D;      
    END IF;
  END PROCESS FFs_Ausgaenge;


  -- Ausgaenge Zuweisen

  -- Mikroprogramm-Interface
  IP <= std_logic_vector(to_unsigned(IP_int, 8));

  -- Speicherinterface
  -- EXT_D ist das Signal auf dem Datenbus: wird resolved mit dem Signal, das der Speicher treibt
  EXT_D   <=  EXT_D_internal;
  EXT_A   <= ADR;
  EXT_BEn <= "00";
  EXT_WRn <= WRn;
  EXT_RDn <= RDn;
  --
  -- Diagnose-OutPut: Internen Zaehler TrnCnt nach aussen geben (fuer Anzeigen)
  TCnt_Display    <= std_logic_vector(to_unsigned(TrnCnt, 3));
  -- EXT\_D\_internal: zur Diagnose: dieses Signal schreibt die ControlUnit auf den Datenbus
  EXT_D_internal <= "ZZZZZZZZZZZZZZZZ" WHEN (OE_Dn = '1') ELSE DAT; 
  
END ControlUnit_architecture;
