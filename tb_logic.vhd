library IEEE;
use ieee.std_logic_1164.all;

entity tb_logic is
	constant n : integer := 8;
end tb_logic;

architecture behavior of tb_logic is
    component Logic is
        GENERIC (n : INTEGER := 8);
        port (
            Y   : in  std_logic_vector(n-1 downto 0); 
            X   : in  std_logic_vector(n-1 downto 0);
            ALUFN: in std_logic_vector(2 downto 0);	
            logic_o : out std_logic_vector(n-1 downto 0));
    end component;

	SIGNAL Y, X       : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL ALUFN      : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL logic_o    : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	
	-- Flags
	SIGNAL Zflag, Nflag : STD_LOGIC;

begin
	DUT : Logic generic map (n => n) 
                  port map (Y => Y, X => X, ALUFN => ALUFN, logic_o => logic_o);
				   
	-- Derive N and Z flags
	Nflag <= logic_o(n-1);
	Zflag <= '1' when (logic_o = (logic_o'range => '0')) else '0';

	tb_stimulus : process
	begin
		---------------------------------------------------
		-- 1. Test NOT Y (ALUFN = "000")
		---------------------------------------------------
		ALUFN <= "000";
		Y <= "10101010"; X <= "11111111"; wait for 50 ns; 
		Y <= "11111111"; X <= "00000000"; wait for 50 ns; 
		
		---------------------------------------------------
		-- 2. Test Y OR X (ALUFN = "001")
		---------------------------------------------------
		ALUFN <= "001";
		Y <= "10101010"; X <= "01010101"; wait for 50 ns; 
		Y <= "00001111"; X <= "00000000"; wait for 50 ns; 
		
		---------------------------------------------------
		-- 3. Test Y AND X (ALUFN = "010")
		---------------------------------------------------
		ALUFN <= "010";
		Y <= "10101010"; X <= "01010101"; wait for 50 ns; 
		Y <= "11110000"; X <= "10101010"; wait for 50 ns; 
		
		---------------------------------------------------
		-- 4. Test Y XOR X (ALUFN = "011")
		---------------------------------------------------
		ALUFN <= "011";
		Y <= "11111111"; X <= "11111111"; wait for 50 ns; 
		Y <= "11001100"; X <= "10101010"; wait for 50 ns; 
		
		---------------------------------------------------
		-- 5. Test Y NOR X (ALUFN = "100")
		---------------------------------------------------
		ALUFN <= "100";
		Y <= "00000000"; X <= "00000000"; wait for 50 ns; 
		Y <= "11111111"; X <= "00000000"; wait for 50 ns; 
		
		---------------------------------------------------
		-- 6. Test Y NAND X (ALUFN = "101")
		---------------------------------------------------
		ALUFN <= "101";
		Y <= "11111111"; X <= "11111111"; wait for 50 ns; 
		Y <= "10101010"; X <= "01010101"; wait for 50 ns; 
		
		---------------------------------------------------
		-- 7. Test Y XNOR X (ALUFN = "110")
		---------------------------------------------------
		ALUFN <= "110";
		Y <= "10101010"; X <= "10101010"; wait for 50 ns; 
		Y <= "11001100"; X <= "10101010"; wait for 50 ns; 
		
		---------------------------------------------------
		-- 8. Test Undefined Commands ("111")
		-- Instruction: Output 0 and flags accordingly.
		---------------------------------------------------
		ALUFN <= "111"; 
		Y <= "11111111"; X <= "11111111"; wait for 50 ns; 

		wait;
	end process;
end behavior;
