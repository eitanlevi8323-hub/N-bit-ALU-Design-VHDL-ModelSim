LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY AdderSub is
	GENERIC (n : INTEGER := 8);
	port (
        Y   : in  std_logic_vector(n-1 downto 0); 
        X   : in  std_logic_vector(n-1 downto 0); 
		ALUFN: in std_logic_vector(2 downto 0);
        adder_o : out std_logic_vector(n-1 downto 0); 
		Cflag_Adder: out std_logic;
		overflow: out std_logic);
	
END AdderSub;
--------------------------------------------------------
ARCHITECTURE dataflow OF AdderSub IS
    component FA is
        PORT (xi, yi, cin: IN std_logic;
              s, cout: OUT std_logic);
    end component;
    
    signal S: std_logic_vector(n-1 downto 0);
    signal reg : std_logic_vector(n-1 downto 0);
    signal sub_cont : std_logic_vector(n-1 downto 0);
	signal s_adder_o: std_logic_vector(n-1 downto 0);
	signal x_fa: std_logic_vector(n-1 downto 0);
	signal x_Adder: std_logic_vector(n-1 downto 0);
	signal y_Adder: std_logic_vector(n-1 downto 0);
	signal ONE: std_logic_vector(n-1 downto 0);
	signal TWO: std_logic_vector(n-1 downto 0);
BEGIN
     
	ONE <= (0 => '1', others => '0');
	TWO <= (1 => '1', others => '0');
	
	x_Adder <= X when ALUFN = "000" else
		X when ALUFN = "001" else
		not X when ALUFN = "010" else
		not ONE when ALUFN = "011" else
		not ONE when ALUFN = "100" else
		(others => '0');
	
	y_Adder <= ONE when ALUFN = "010" else Y;
	
    sub_cont <= (others => ALUFN(0));
	x_fa <= x_Adder xor sub_cont;
    
	first : FA port map(
            xi => x_fa(0),
            yi => y_Adder(0),
            cin => ALUFN(0),
            s => S(0),
            cout => reg(0)
    );
    rest : for i in 1 to n-1 generate
        chain : FA port map(
            xi => x_fa(i),
            yi => y_Adder(i),
            cin => reg(i-1),
            s => S(i),
            cout => reg(i)
        );
    end generate;
    Cflag_Adder <= reg(n-1) when (ALUFN >= "000" and ALUFN <= "100") else '0';

	s_adder_o <= S when (ALUFN >= "000" and ALUFN <= "100") else
		(others => '0');
	adder_o <= s_adder_o;
	
	overflow <= ((y_Adder(n-1) and x_fa(n-1) and (not s_adder_o(n-1))) or 
               ((not y_Adder(n-1)) and (not x_fa(n-1)) and s_adder_o(n-1)))
			   when (ALUFN >= "000" and ALUFN <= "100") else '0';
			   
END dataflow;