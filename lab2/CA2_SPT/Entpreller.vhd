LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.NUMERIC_bit.all;

-- Hochschule Esslingen, Fakultaet IT
-- (C) 2013 R. Keller, W. Lindermeir, W. Zimmermann 

ENTITY DEBOUNCE IS
  GENERIC(width : natural := 1 );
  PORT (
    clk       : IN STD_LOGIC;
    orig      : IN STD_LOGIC;  -- active low
    debounced : OUT STD_LOGIC);
END DEBOUNCE;

ARCHITECTURE arch OF DEBOUNCE IS

-- Funktion des Entprellers:
-- das Signal orig kommt von einem Taster
--          Taster nicht gedrueckt: orig = '1'
--          Tasster gedrueckt:      orig = '0'
-- Falls der Taster gedrueckt wird, wird fuer die Dauer eines
-- Taktzyklus von clk das Signal debounced auf '0' gesetzt.
-- Stationaer ist das Signal debounced immer auf '1'

subtype counttype_std is STD_LOGIC_VECTOR (width DOWNTO 0);
SIGNAL cnt : counttype_std;
subtype counttype_bit is BIT_VECTOR (width DOWNTO 0);
constant one_before_end : counttype_bit := (0 => '0', others => '1');

BEGIN
PROCESS (clk)
  constant all_zeros : counttype_bit := (others => '0');
  constant all_ones  : counttype_bit := (others => '1');
  variable cnt_bit : counttype_bit;
BEGIN
  IF (clk'EVENT AND Clk = '1') THEN
    IF (orig = '1') THEN   -- inactive
      cnt_bit := all_zeros;
    ELSIF (cnt_bit /= all_ones) THEN
      cnt_bit := bit_vector(UNSIGNED(cnt_bit) + 1);
    END IF;
  END IF;
  cnt <= To_StdLogicVector(cnt_bit);
END PROCESS;

-- output
PROCESS (cnt)
BEGIN
  IF (cnt = to_stdlogicvector(one_before_end)) THEN
    debounced <= '0';
  ELSE
    debounced <= '1';
  END IF;
END PROCESS;
END arch;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Hochschule Esslingen, Fakultaet IT
-- (C) 2012 R. Keller, W. Lindermeir, W. Zimmermann 

ENTITY Entpreller IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
	GENERIC(width : integer:= 1 );
	PORT
	(
		clk_fast : IN STD_LOGIC;
		buttons : IN STD_LOGIC_VECTOR(2 downto 0);
		reset_n : OUT STD_LOGIC;
		clk_single : OUT STD_LOGIC;
		toggle_clk_gen : OUT STD_LOGIC
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
	
END Entpreller;

--  Architecture Body

ARCHITECTURE Entpreller_architecture OF Entpreller IS
  signal reset_n_D : std_logic;	
  signal clk_single_D : std_logic;
BEGIN

  deb0: entity work.DEBOUNCE
        generic map(width => width)
        port map(clk => clk_fast, orig => buttons(0), debounced => reset_n_D);

  -- synchronize reset signal
  sync_reset:
  process( clk_fast ) is
  begin
    if falling_edge(clk_fast) then
      reset_n <= reset_n_D;
    end if;
  end process sync_reset;
  
  deb1: entity work.DEBOUNCE
        generic map(width => width)
        port map(clk => clk_fast, orig => buttons(1), debounced => clk_single_D);
  
  sync_clk_single:
  process( clk_fast ) is
  begin
    if rising_edge(clk_fast) then
      clk_single <= clk_single_D;
    end if;
  end process sync_clk_single;
  
    
  deb2: entity work.DEBOUNCE
        generic map(width => width)
        port map(clk => clk_fast, orig => buttons(2), debounced => toggle_clk_gen);

END Entpreller_architecture;






