library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
	component top is
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
	end component;
---------------------------------------------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
---------------------------------------------------------	
	component AdderSub is
		GENERIC (n : INTEGER := 8);
		port (
			Y   : in  std_logic_vector(n-1 downto 0); 
			X   : in  std_logic_vector(n-1 downto 0); 
			ALUFN: in std_logic_vector(2 downto 0);
			adder_o : out std_logic_vector(n-1 downto 0);
			Cflag_Adder: out std_logic;
			overflow: out std_logic); 
		
	end component;
--------------------------------------------------------
	component Shifter is
		GENERIC (n : INTEGER := 8;
				k : INTEGER := 3);
		port (
			Y   : in  std_logic_vector(n-1 downto 0); 
			X   : in  std_logic_vector(n-1 downto 0); 
			ALUFN: in std_logic_vector(2 downto 0);
			shifter_o : out std_logic_vector(n-1 downto 0);
			Cflag_Shifter: out std_logic);

	end component;
--------------------------------------------------------
	component Logic is
		GENERIC (n : INTEGER := 8);
		port (
			Y   : in  std_logic_vector(n-1 downto 0); 
			X   : in  std_logic_vector(n-1 downto 0);
			ALUFN: in std_logic_vector(2 downto 0);	
			logic_o : out std_logic_vector(n-1 downto 0));
	end component;
	
	
	
	
	
	
	
	
	
	
	
	
end aux_package;

