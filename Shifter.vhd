
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY Shifter is
	GENERIC (n : INTEGER := 8;
			k : INTEGER := 3);
	port (
        Y   : in  std_logic_vector(n-1 downto 0); 
        X   : in  std_logic_vector(n-1 downto 0); 
		ALUFN: in std_logic_vector(2 downto 0);
        shifter_o : out std_logic_vector(n-1 downto 0);
		Cflag_Shifter: out std_logic);

END Shifter;
--------------------------------------------------------
ARCHITECTURE dataflow of Shifter is

    type stage_array is array (0 to k) of std_logic_vector(n-1 downto 0);
    signal left_stages  : stage_array; 
    signal right_stages : stage_array;     
    signal left_carry   : std_logic_vector(k downto 0);
    signal right_carry  : std_logic_vector(k downto 0);
    constant ZEROS      : std_logic_vector(n-1 downto 0) := (others => '0');
BEGIN

    left_stages(0)  <= Y;
    right_stages(0) <= Y;
    left_carry(0)   <= '0';
    right_carry(0)  <= '0';
	
    shl_gen: for i in 0 to k-1 generate
        left_stages(i+1) <= (left_stages(i)(n-(2**i)-1 downto 0) & ZEROS(2**i-1 downto 0)) when X(i) = '1' else left_stages(i);
        left_carry(i+1) <= left_stages(i)(n-(2**i)) when X(i) = '1' else left_carry(i);
    end generate;

    shr_gen: for i in 0 to k-1 generate
        right_stages(i+1) <= (ZEROS(2**i-1 downto 0) & right_stages(i)(n-1 downto 2**i)) when X(i) = '1' else right_stages(i);           
        right_carry(i+1) <= right_stages(i)(2**i-1) when X(i) = '1' else right_carry(i);
    end generate;
	
    shifter_o  <= left_stages(k)  when ALUFN = "000" else
			right_stages(k) when ALUFN = "001" else
			(others => '0');
    Cflag_Shifter <= left_carry(k) when ALUFN = "000" else
                     right_carry(k) when ALUFN = "001" else
                     '0';

END dataflow;