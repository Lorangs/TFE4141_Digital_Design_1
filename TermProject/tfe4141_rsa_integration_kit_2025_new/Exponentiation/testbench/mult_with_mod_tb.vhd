library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult_with_mod_tb is
	generic (
		C_BLOCK_SIZE : INTEGER := 256
	);
end mult_with_mod_tb;



architecture mult_behave of mult_with_mod_tb is 

		--constant C_BLOCK_SIZE : INTEGER := 256;
		constant clk_period   : TIME 	:= 10ns;

		signal valid_in 	  :  STD_LOGIC;
		signal ready_in  	  :  STD_LOGIC;

		--input data
		signal a, b, c        :  STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0);
		signal e              :  STD_LOGIC;
		
		--ouput controll
		signal ready_out	  :  STD_LOGIC;
		signal valid_out	  :  STD_LOGIC;

		--output data
		signal result_R 	  :  STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0);
		signal result_P 	  :  STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0);

		--modulus
		signal n              :  STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );

         
		--utility
		signal clk 		      :  STD_LOGIC;
		signal reset_neg 	  :  STD_LOGIC;

		-- Internal Signal
		signal s0, s1 ,s2 ,s3, s4, s5, s6, s7, s8, s9, s10, s11 : STD_LOGIC_VECTOR( C_BLOCK_SIZE + 1 downto 0 ); -- two extra bits: one for sign, one for possible overflow
		-- state
		signal current_state : STD_LOGIC_VECTOR( 1 downto 0 );	-- RESET = 00, COUNTING = 01, FINISHED = 10, unused 11

		-- counter
		signal counter       : INTEGER in range 0 to C_BLOCK_SIZE;

		-- Registers for input values
		signal a_reg, b_reg, c_reg: STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
		signal e_reg : std_logic;


begin 



DUT : entity work.mult_with_mod
	generic map(
		C_BLOCK_SIZE => C_BLOCK_SIZE
	)
	port map (
	--input controll
		valid_in   =>   valid_in,
		ready_in   =>   ready_in,
		
	--ouput controll
		ready_out  =>   ready_out,
		valid_out  =>   valid_out,

	--input data
		a 		   =>   a,
		b 		   =>   b,
		c 		   =>   c,
		e 		   =>   e,


	--output data
		result_R   =>   result_R,
		result_P   =>   result_P,
		
	--modulus
		n		   =>   n,

	--utility
		clk        =>   clk,
		reset_neg    =>   reset_neg,

	-- internal signals for testing
		current_state =>   current_state,
		counter       =>   counter,
		s0			=>   s0,
		s1			=>   s1,
		s2			=>   s2,
		s3			=>   s3,
		s4			=>   s4,
		s5			=>   s5,
		s6			=>   s6,
		s7			=>   s7,
		s8			=>   s8,
		s9			=>   s9,
		s10			=>   s10,
		s11			=>   s11

	);

clk_process : process
begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process clk_process;


test_process: process
begin

	-- Start test with setting input values and resetting the module (reset_neg = 0)

	a 			<= x"0a23232323232323232323232323232323232323232323232323232323232323";
	b 			<= x"0000000000000000000000000000000000000000000000000000000000000001";
	c 			<= x"0a23232323232323232323232323232323232323232323232323232323232323";
	e 			<= '1'; -- e = 1 (perform multiplication)

	n 			<= x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";
	

	valid_in 	<= '0';
	ready_out	<= '0';

	reset_neg 	<= '0'; 

	wait for clk_period*2;


	-- test if the signals stay the same when reset_neg = 0, but valid_in is still 0 
	reset_neg		<= '1'; 
	wait for clk_period*2;
	valid_in	<= '1';
	wait for clk_period*2;
	valid_in	<= '0';

	wait for clk_period*10;
	ready_out	<= '1';
    
	wait for clk_period;
	ready_out	<= '0';
	
    wait for clk_period*300;  -- wait enough time for the operation to complete


	-- Check new values after reset
	wait for clk_period*2;
	ready_out	<= '0';
	reset_neg 	<= '0';

	-----------------------------------------
	-- New input values after reset
	-----------------------------------------

    report "------ TEST COMPLETED -------" severity note;
    wait; 
end process test_process;
end mult_behave;