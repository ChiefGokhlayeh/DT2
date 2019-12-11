-- Hochschule Esslingen, Fakultaet IT
-- (C) 2013 R. Keller, W. Lindermeir, W. Zimmermann 

-- Seven Segment Decoder
--         a
--       f   b
--         g
--       e   c
--         d

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Seven_seg_dec IS
  PORT ( state : IN STD_LOGIC_VECTOR(3 downto 0);
         seven_segs : OUT STD_LOGIC_VECTOR(6 downto 0));
END Seven_seg_dec;

ARCHITECTURE Seven_seg_dec_architecture OF Seven_seg_dec IS
  signal result : std_logic_vector(6 downto 0);
BEGIN
  comb: process (state)
  begin
    case state is            ---abcdefg
      when "0000"  => result <= "1111110";
      when "0001"  => result <= "0110000";
      when "0010"  => result <= "1101101";
      when "0011"  => result <= "1111001";
      when "0100"  => result <= "0110011";
      when "0101"  => result <= "1011011";
      when "0110"  => result <= "1011111";
      when "0111"  => result <= "1110000";
      when "1000"  => result <= "1111111";
      when "1001"  => result <= "1110011";
      when "1010"  => result <= "1110111";
      when "1011"  => result <= "0011111";
      when "1100"  => result <= "1001110";
      when "1101"  => result <= "0111101";
      when "1110"  => result <= "1001111";
      when "1111"  => result <= "1000111";
      when others  => result <= "1001001";
    end case;
  end process;

  seven_segs <= NOT result;

END Seven_seg_dec_architecture;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Hochschule Esslingen, Fakultaet IT
-- (C) 2012 R. Keller, W. Lindermeir, W. Zimmermann 

ENTITY Dual_Seven_seg_dec IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	PORT
	(
		clk_lcd : IN STD_LOGIC;
		IP : IN STD_LOGIC_VECTOR(7 downto 0);
		TCnt_Display : IN STD_LOGIC_VECTOR(2 downto 0);
		seven_segs : OUT STD_LOGIC_VECTOR(13 downto 0)
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
END Dual_Seven_seg_dec;

--  Architecture Body
ARCHITECTURE Dual_Seven_seg_dec_architecture OF Dual_Seven_seg_dec IS
  signal IP_reg : STD_LOGIC_VECTOR(7 downto 0);
BEGIN

  dec_lsb: entity work.Seven_seg_dec
           port map(state => IP_reg(3 downto 0), seven_segs => seven_segs(6 downto 0));

  dec_msb: entity work.Seven_seg_dec
           port map(state => IP_reg(7 downto 4), seven_segs => seven_segs(13 downto 7));

  Take_TCnt: Process (clk_lcd) is
  Begin
    IF (rising_edge(clk_lcd)) then
      if( TCnt_Display = "000") THEN
         IP_reg <= IP;
      END IF;
    END IF;
  End Process Take_TCnt;

END Dual_Seven_seg_dec_architecture;
