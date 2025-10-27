library ieee;
use ieee.std_logic_1164.all;

entity exponentiation is
	generic (
		C_block_size : integer := 256
	);
	port (
		--input controll
		valid_in	: in STD_LOGIC;
		ready_in	: out STD_LOGIC;

		--input data
		a           : in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
	    b           : in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
        c           : in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
		
		--ouput controll
		ready_out	: in STD_LOGIC;
		valid_out	: out STD_LOGIC;

		--output data
		result_R 		: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);
		result_P 		: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		--modulus
		 n           : in STD_LOGIC_VECTOR ( C_block_size downto 0 );
		 n_neg       : in STD_LOGIC_VECTOR ( C_block_size downto 0 );
         
         
		--utility
		clk 		: in STD_LOGIC;
		reset_n 	: in STD_LOGIC
	);
end exponentiation;


architecture expBehave of exponentiation is
begin
	
end expBehave;
