-- Hochschule Esslingen, Fakultaet IT
-- (C) 2013 R. Keller, W. Lindermeir, W. Zimmermann 

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.microprog_types.all;
--
--  Entity Declaration
ENTITY MicroProgram IS
GENERIC(IPTR_Max : POSITIVE := 255);
      -- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
      PORT
      (
            IP : IN STD_LOGIC_VECTOR(7 downto 0);
            OPCODE : OUT STD_LOGIC_VECTOR(3 downto 0);
            OPERAND : OUT STD_LOGIC_VECTOR(15 downto 0)
      );
      -- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
BEGIN
          ASSERT (IPTR_Max < 256) REPORT "Es muss gelten: IPTR_Max < 256" severity failure;
END MicroProgram;


-- Beginn der Architekturbeschreibung
ARCHITECTURE MicroProgram_architecture OF MicroProgram IS
  -- Lokale Definitionen
  TYPE Instruction_Type IS 
       RECORD 
         OPCODE:  Std_Logic_Vector( 3 downto 0);
         OPERAND: Std_Logic_Vector(15 downto 0);
       END RECORD Instruction_Type;
  TYPE Instruction_Array_Type is ARRAY (natural range <>) of Instruction_Type;
  CONSTANT Instruction_Array: Instruction_Array_Type := 
   ( --- Ab nächster Zeile: Mikroprogramm hinzufügen
    -- Syntax Konstantenfeld
    -- <Feldnr> <= (<Konstante 1>, <Konstante2>),      
    16#000# => (OPCODE => MICRO_LDA, OPERAND => X"A00E"     ), 
    16#001# => (OPCODE => MICRO_LDD, OPERAND => X"CABA"     ),
    16#002# => (OPCODE => MICRO_MVO, OPERAND => OPERAND_NONE),
    16#003# => (OPCODE => MICRO_NOP, OPERAND => OPERAND_NONE),
    16#004# => (OPCODE => MICRO_STP, OPERAND => OPERAND_NONE),
    16#005# => (OPCODE => MICRO_STP, OPERAND => OPERAND_NONE),
    16#006# => (OPCODE => MICRO_STP, OPERAND => OPERAND_NONE),
    16#007# => (OPCODE => MICRO_JMP, OPERAND => OPERAND_NONE)
   );--- ENDE des Mikroprogramms

  -- Interner Intruction_Pointer (Programmzähler)
  SIGNAL  IPTR: NATURAL RANGE 0 TO IPTR_MAX;
BEGIN

  -- Prüfung der Länge des Mikroprogramms beim Compilieren
  ASSERT Instruction_Array'high <= IPTR_MAX
    REPORT "Fehler mit Mikroprogramm: Zu viele Programmschritte!"
    SEVERITY Failure;

  -- Instruction Pointer auf Index-Bereich des Arrays beschraenken
  Get_Pointer: PROCESS (IP)
    Variable  IP_Num: NATURAL RANGE 0 TO IPTR_MAX;
  BEGIN
    IP_Num := to_integer(unsigned(IP));
    IF ( IP_Num <= Instruction_Array'high ) THEN
        IPTR <= IP_Num; -- an letztem Befehl festhalten
    ELSE
        IPTR <= 0;
    END IF;
  END PROCESS Get_Pointer;

  -- betreffendes Feldelement ausgeben
  OPCODE  <= Instruction_Array(IPTR).OPCODE;    
  OPERAND <= Instruction_Array(IPTR).OPERAND;
  
END MicroProgram_architecture;
