library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_shifter is
	constant n : integer := 8;
	constant k : integer := 3;
end tb_shifter;

architecture behavior of tb_shifter is
    component Shifter is
        GENERIC (n : INTEGER := 8; k : INTEGER := 3);
        port (
            Y   : in  std_logic_vector(n-1 downto 0); 
            X   : in  std_logic_vector(n-1 downto 0); 
            ALUFN: in std_logic_vector(2 downto 0);
            shifter_o : out std_logic_vector(n-1 downto 0);
            Cflag_Shifter: out std_logic);
    end component;

	SIGNAL Y, X       : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL ALUFN      : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL shifter_o  : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	
	-- Flags
	SIGNAL Cflag, Zflag, Nflag : STD_LOGIC;

begin
	-- Instantiate the module under test directly (Shifter)
	DUT : Shifter generic map (n => n, k => k) 
                  port map (Y => Y, X => X, ALUFN => ALUFN, shifter_o => shifter_o, Cflag_Shifter => Cflag);
				   
	-- Derive N and Z flags
	Nflag <= shifter_o(n-1);
	Zflag <= '1' when (shifter_o = (shifter_o'range => '0')) else '0';

	tb_stimulus : process
	begin
		---------------------------------------------------
		-- 1. Test Shift Left (ALUFN = "000")
		---------------------------------------------------
		ALUFN <= "000";
		
		-- Shift by 0
		Y <= "10101010"; X <= "00000000"; wait for 50 ns; 
		
		-- Shift by 1
		Y <= "10101011"; X <= "00000001"; wait for 50 ns; -- Exp: 01010110, C=1
		
		-- Shift by 3
		Y <= "00011111"; X <= "00000011"; wait for 50 ns; -- Exp: 11111000, C=0
		
		-- Shift by max (7)
		Y <= "00000011"; X <= "00000111"; wait for 50 ns; -- Exp: 10000000, C=0, N=1
		
		---------------------------------------------------
		-- 2. Test Shift Right (ALUFN = "001")
		---------------------------------------------------
		ALUFN <= "001";
		
		-- Shift by 0
		Y <= "10101010"; X <= "00000000"; wait for 50 ns; 
		
		-- Shift by 1
		Y <= "11010101"; X <= "00000001"; wait for 50 ns; -- Exp: 01101010, C=1
		
		-- Shift by 3
		Y <= "11111000"; X <= "00000011"; wait for 50 ns; -- Exp: 00011111, C=0
		
		-- Shift by max (7)
		Y <= "11000000"; X <= "00000111"; wait for 50 ns; -- Exp: 00000001, C=1
		
		---------------------------------------------------
		-- 3. Test Undefined Commands ("010" to "111")
		-- Instruction: Output 0 and flags accordingly.
		---------------------------------------------------
		Y <= "11111111";  -- Some junk data to ensure it is cleanly ignored
		X <= "11111111";
		
		ALUFN <= "010"; wait for 50 ns; -- Expected: shifter_o=0, Z=1, N=0, C=0
		ALUFN <= "011"; wait for 50 ns; -- Expected: shifter_o=0, Z=1, N=0, C=0
		ALUFN <= "100"; wait for 50 ns; -- Expected: shifter_o=0, Z=1, N=0, C=0
		ALUFN <= "101"; wait for 50 ns; -- Expected: shifter_o=0, Z=1, N=0, C=0
		ALUFN <= "110"; wait for 50 ns; -- Expected: shifter_o=0, Z=1, N=0, C=0
		ALUFN <= "111"; wait for 50 ns; -- Expected: shifter_o=0, Z=1, N=0, C=0

		wait;
	end process;
end behavior;
