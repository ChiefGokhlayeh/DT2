LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Copyright R. Keller, W. Lindermeir und W. Zimmermann 2013

package microprog_types is
  -- Maximale Adresse des Mikroprogramm-Speichers
  constant IPTR_MAX     : POSITIVE := 255;

  -- Codierungen für Opcodes
  constant MICRO_NOP    : std_logic_vector(3 downto 0)  := X"0";
  constant MICRO_MVI    : std_logic_vector(3 downto 0)  := X"1";
  constant MICRO_MVO    : std_logic_vector(3 downto 0)  := X"2";
  constant MICRO_LDA    : std_logic_vector(3 downto 0)  := X"A";
  constant MICRO_LDD    : std_logic_vector(3 downto 0)  := X"D";
  constant MICRO_STP    : std_logic_vector(3 downto 0)  := X"C";
  constant MICRO_JMP    : std_logic_vector(3 downto 0)  := X"F";

  -- Tag für nicht benutzten Operanden eines Mikrobefehls
  constant OPERAND_NONE : Std_Logic_Vector(15 downto 0) := (others => 'U');
end package microprog_types;
 
 
 
 
 
 
