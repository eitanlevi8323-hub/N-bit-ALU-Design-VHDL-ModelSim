library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity tb_adder_sub is
	constant n : integer := 8;
end tb_adder_sub;

architecture behavior of tb_adder_sub is
	SIGNAL Y, X     : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL ALUFN    : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL adder_o  : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	
	-- Flags
	SIGNAL Cflag, Vflag, Zflag, Nflag : STD_LOGIC;

begin
	-- Instantiate the module under test directly (AdderSub)
	DUT : AdderSub generic map (n => n) 
                   port map (Y => Y, X => X, ALUFN => ALUFN, adder_o => adder_o, Cflag_Adder => Cflag, overflow => Vflag);
				   
	-- Derive N and Z flags (similar to the logic in top.vhd) to verify "activate flags accordingly"
	-- Since AdderSub doesn't output Z and N directly, we simulate top's handling of them here.
	Nflag <= adder_o(n-1);
	Zflag <= '1' when (adder_o = (adder_o'range => '0')) else '0';

	tb_stimulus : process
	begin
		---------------------------------------------------
		-- 1. Test Simple addition Y+X (ALUFN = "000")
		---------------------------------------------------
		ALUFN <= "000";
		Y <= "00010000"; -- 16
		X <= "00000101"; -- 5
		wait for 50 ns; -- Expected: 21 (x"15")
		
		-- Test carry out
		Y <= "11111111"; -- 255
		X <= "00000010"; -- 2
		wait for 50 ns; -- Expected: 1 (x"01"), C=1
		
		---------------------------------------------------
		-- 2. Test Subtraction Y-X (ALUFN = "001")
		---------------------------------------------------
		ALUFN <= "001";
		Y <= "00010000"; -- 16
		X <= "00000101"; -- 5
		wait for 50 ns; -- Expected: 11 (x"0B")
		
		-- Test negative result
		Y <= "00000101"; -- 5
		X <= "00010000"; -- 16
		wait for 50 ns; -- Expected: -11 (x"F5"), N=1
		
		-- Test Zero result
		Y <= "00100000";
		X <= "00100000";
		wait for 50 ns; -- Expected: 0, Z=1

		---------------------------------------------------
		-- 3. Test 2's Complement -X (ALUFN = "010")
		---------------------------------------------------
		ALUFN <= "010";
		Y <= "10101010"; -- Y is ignored
		X <= "00000101"; -- 5
		wait for 50 ns; -- Expected: -5 (x"FB")
		
		---------------------------------------------------
		-- 4. Test Double increment Y+2 (ALUFN = "011")
		---------------------------------------------------
		ALUFN <= "011";
		Y <= "00010000"; -- 16
		X <= "10101010"; -- X is ignored
		wait for 50 ns; -- Expected: 18 (x"12")
		
		-- Test Overflow (Positive + Positive = Negative)
		Y <= "01111110"; -- 126
		wait for 50 ns; -- Expected: 128 (x"80"), V=1, N=1
		
		---------------------------------------------------
		-- 5. Test Double decrement Y-2 (ALUFN = "100")
		---------------------------------------------------
		ALUFN <= "100";
		Y <= "00010000"; -- 16
		X <= "10101010"; -- X is ignored
		wait for 50 ns; -- Expected: 14 (x"0E")
		
		-- Test Overflow (Negative - Positive = Positive)
		Y <= "10000001"; -- -127
		wait for 50 ns; -- Expected: 127 (x"7F"), V=1
		
		---------------------------------------------------
		-- 6. Test Undefined Commands ("101", "110", "111")
		-- Instruction: Output 0 and flags accordingly.
		---------------------------------------------------
		Y <= "11111111";  -- Some junk data to ensure it is ignored
		X <= "11101110";
		
		ALUFN <= "101"; 
		wait for 50 ns; -- Expected: adder_o=0, Z=1, N=0, C=0, V=0
		
		ALUFN <= "110"; 
		wait for 50 ns; -- Expected: adder_o=0, Z=1, N=0, C=0, V=0
		
		ALUFN <= "111"; 
		wait for 50 ns; -- Expected: adder_o=0, Z=1, N=0, C=0, V=0

		wait;
	end process;
end behavior;
