LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Hochschule Esslingen, Fakultaet IT
-- (C) 2013 R. Keller, W. Lindermeir, W. Zimmermann 

ENTITY LCD_data_prep IS
      -- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
      PORT
      (
            reset_n : IN STD_LOGIC;
            clk_lcd : IN STD_LOGIC;
            LCD_ready : IN STD_LOGIC;
            EXT_D : IN STD_LOGIC_VECTOR(15 downto 0);
            EXT_A : IN STD_LOGIC_VECTOR(17 downto 0);
            EXT_RDn : IN STD_LOGIC;
            EXT_WRn : IN STD_LOGIC;
            EXT_BEn : IN STD_LOGIC_VECTOR(1 downto 0);
            TCnt_Display : IN STD_LOGIC_VECTOR(2 downto 0);
            OPCODE : IN STD_LOGIC_VECTOR(3 downto 0);
            refresh : OUT STD_LOGIC;
            LCD_data : OUT STD_LOGIC_VECTOR(255 downto 0);
            leds : OUT STD_LOGIC_VECTOR(7 downto 0)
      );
      -- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
END LCD_data_prep;

ARCHITECTURE LCD_data_prep_architecture OF LCD_data_prep IS

  pure function char2ascii ( char : in character ) return std_logic_vector is
  begin
    return std_logic_vector( to_unsigned(character'pos(char), 8));
  end function char2ascii;
  
  pure function hex2ascii (nibble : in std_logic_vector(3 downto 0) ) return std_logic_vector is
    variable ret : std_logic_vector(7 downto 0);
  begin
    case nibble is
       when "0000" => ret := char2ascii('0');
       when "0001" => ret := char2ascii('1');
       when "0010" => ret := char2ascii('2');
       when "0011" => ret := char2ascii('3');
       when "0100" => ret := char2ascii('4');
       when "0101" => ret := char2ascii('5');
       when "0110" => ret := char2ascii('6');
       when "0111" => ret := char2ascii('7');
       when "1000" => ret := char2ascii('8');
       when "1001" => ret := char2ascii('9');
       when "1010" => ret := char2ascii('A');
       when "1011" => ret := char2ascii('b');
       when "1100" => ret := char2ascii('C');
       when "1101" => ret := char2ascii('d');
       when "1110" => ret := char2ascii('E');
       when "1111" => ret := char2ascii('F');
       when others => ret := char2ascii('F');
    end case;
    return ret;
  end function hex2ascii;
        
  pure function bit2ascii (input_bit : in std_logic) return std_logic_vector is
    variable ret : std_logic_vector(7 downto 0);
  begin
    case input_bit is
       when '0' => ret := char2ascii('0');
       when '1' => ret := char2ascii('1');
       when others => ret := char2ascii('1');
    end case;
    return ret;
  end function bit2ascii;
  
  -- interne Signale
  signal LCD_data_D : std_logic_vector(255 downto 24);
  signal q : character;

BEGIN

  refresh <= '1';

  -- output the number of the cyle 0 to 7 on the leds
  leds <= "00000001" when TCnt_Display = "000" else
          "00000011" when TCnt_Display = "001" else
          "00000111" when TCnt_Display = "010" else
          "00001111" when TCnt_Display = "011" else
          "00011111" when TCnt_Display = "100" else
          "00111111" when TCnt_Display = "101" else
          "01111111" when TCnt_Display = "110" else
          "11111111" when TCnt_Display = "111" else
          "11111111";

  -- obere Zeile: Z.B.   "A:xxxx D:xxxx Tq"   T steht fuer Treiber: folgende Moeglichkeiten fuer q: 
  --                                                                q = '-' Bus ist hochohmig
  --                                                                q = 'R' Bus ist von SRAM getrieben
  --                                                                q = 'W' Bus ist von FPGA getrieben
  --                                                                q = 'C' Contention auf Bus
  --                                                                
  q <= '-' when EXT_RDn = '1' and EXT_WRn = '1' else
       'R' when EXT_RDn = '0' and EXT_WRn = '1' else	--'S'
       'W' when EXT_RDn = '1' and EXT_WRn = '0' else	--'F'
       'C';

  LCD_data_D(255 downto 128) <= 
     -- Adresse
     char2ascii('A') & char2ascii(':') & 
          hex2ascii(EXT_A(15 downto 12)) & hex2ascii(EXT_A(11 downto 8)) & hex2ascii(EXT_A(7 downto 4)) & hex2ascii(EXT_A(3 downto 0)) &   
          char2ascii(' ') & 
     -- Daten
     char2ascii('D') & char2ascii(':') & 
          hex2ascii(EXT_D(15 downto 12)) & hex2ascii(EXT_D(11 downto 8)) & hex2ascii(EXT_D(7 downto 4)) & hex2ascii(EXT_D(3 downto 0)) &   
          char2ascii(' ') & 
     -- Treiber q
     char2ascii('T') & char2ascii(q);
  
  -- untere Zeile: Z.B.  "RDn:x WRn:x  OPC" -- RDx    
  --                                           WRx    
  --                                           opc  Opcode der Instruktion
  
  LCD_data_D(127 downto 24) <= 
     -- Read-Strobe
     char2ascii('R') & char2ascii('D') & char2ascii('n') & char2ascii(':') & bit2ascii(EXT_RDn) & char2ascii(' ') & 
     -- Write-Strobe
     char2ascii('W') & char2ascii('R') & char2ascii('n') & char2ascii(':') & bit2ascii(EXT_WRn) & char2ascii(' ') & 
     char2ascii(' ');


  data_ff: process(clk_lcd) is
  begin
    if( clk_lcd'event and clk_lcd = '1' )then
      LCD_data(255 downto 24) <= LCD_data_D(255 downto 24);
    end if;
  end process data_ff;

  OPCODE_Display: Process (clk_lcd) is
    Begin
      IF (rising_edge(clk_lcd)) then
         if( TCnt_Display = "000" ) THEN
           CASE (OPCODE) IS
             WHEN X"0" => LCD_data(23 downto 0) <= char2ascii('N') & char2ascii('O') & char2ascii('P');
             WHEN X"1" => LCD_data(23 downto 0) <= char2ascii('M') & char2ascii('V') & char2ascii('I');
             WHEN X"2" => LCD_data(23 downto 0) <= char2ascii('M') & char2ascii('V') & char2ascii('O');
             WHEN X"A" => LCD_data(23 downto 0) <= char2ascii('L') & char2ascii('D') & char2ascii('A');
             WHEN X"D" => LCD_data(23 downto 0) <= char2ascii('L') & char2ascii('D') & char2ascii('D');
             WHEN X"C" => LCD_data(23 downto 0) <= char2ascii('S') & char2ascii('T') & char2ascii('P');
             WHEN X"F" => LCD_data(23 downto 0) <= char2ascii('J') & char2ascii('M') & char2ascii('P');
           WHEN OTHERS => LCD_data(23 downto 0) <= char2ascii('E') & char2ascii('R') & char2ascii('R');
           END CASE;
         END IF;
      END IF;
    End Process OPCODE_Display;
END LCD_data_prep_architecture;
