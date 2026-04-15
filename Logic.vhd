LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY Logic is
	GENERIC (n : INTEGER := 8);
	port (
        Y   : in  std_logic_vector(n-1 downto 0); 
        X   : in  std_logic_vector(n-1 downto 0);
		ALUFN: in std_logic_vector(2 downto 0);	
        logic_o : out std_logic_vector(n-1 downto 0));
END Logic;
--------------------------------------------------------
ARCHITECTURE dataflow of Logic is
BEGIN 
	logic_o <= not Y when ALUFN = "000" else
			Y or X when ALUFN = "001" else
			Y and X when ALUFN = "010" else
			Y xor X when ALUFN = "011" else
			Y nor X when ALUFN = "100" else
			Y nand X when ALUFN = "101" else
			Y xnor X when ALUFN = "110" else
			(others => '0');
END dataflow;