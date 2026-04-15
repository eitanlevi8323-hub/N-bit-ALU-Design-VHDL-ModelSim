LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY top IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT 
  (  
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC
  ); -- Zflag,Cflag,Nflag,Vflag
END top;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top IS 
	
	signal adder_x : std_logic_vector(n-1 downto 0);
	signal adder_y : std_logic_vector(n-1 downto 0);
	signal logic_x : std_logic_vector(n-1 downto 0);
	signal logic_y : std_logic_vector(n-1 downto 0);
	signal shifter_x : std_logic_vector(n-1 downto 0);
	signal shifter_y : std_logic_vector(n-1 downto 0);
	signal adder_o : std_logic_vector(n-1 downto 0);
	signal logic_o : std_logic_vector(n-1 downto 0);
	signal shifter_o : std_logic_vector(n-1 downto 0);
	signal s_ALUout_o : std_logic_vector(n-1 downto 0);
	signal Cflag_Adder : std_logic;
	signal Cflag_Shifter : std_logic;
	signal overflow : std_logic;
	constant ZEROS : std_logic_vector(n-1 downto 0) := (others => '0');
	
BEGIN
	adder_x <= X_i when ALUFN_i(4 downto 3) = "01" else (others => '0');
	adder_y <= Y_i when ALUFN_i(4 downto 3) = "01" else (others => '0');
	
	logic_x <= X_i when ALUFN_i(4 downto 3) = "11" else (others => '0');
	logic_y <= Y_i when ALUFN_i(4 downto 3) = "11" else (others => '0');
	
	shifter_x <= X_i when ALUFN_i(4 downto 3) = "10" else (others => '0');
	shifter_y <= Y_i when ALUFN_i(4 downto 3) = "10" else (others => '0');
	
	inst_AdderSub: AdderSub generic map (n => n) port map (adder_y, adder_x, ALUFN_i(2 downto 0), adder_o, Cflag_Adder, overflow);
	inst_Logic: Logic generic map (n => n) port map (logic_y, logic_x, ALUFN_i(2 downto 0), logic_o);
	inst_Shifter: Shifter generic map (n => n, k => k) port map (shifter_y, shifter_x, ALUFN_i(2 downto 0), shifter_o, Cflag_Shifter);
	
	s_ALUout_o <= adder_o   when ALUFN_i(4 downto 3) = "01" else
				logic_o   when ALUFN_i(4 downto 3) = "11" else
				shifter_o when ALUFN_i(4 downto 3) = "10" else
				(others => '0');
	
	ALUout_o <= s_ALUout_o;
	
	Nflag_o <= s_ALUout_o(n-1);
	Zflag_o <= '1' when (s_ALUout_o = ZEROS) else '0';
	Vflag_o <= overflow when ALUFN_i(4 downto 3) = "01" else '0';
	Cflag_o <= Cflag_Adder when ALUFN_i(4 downto 3) = "01" else
				Cflag_Shifter when ALUFN_i(4 downto 3) = "10" else	
				'0';
 
END struct;

