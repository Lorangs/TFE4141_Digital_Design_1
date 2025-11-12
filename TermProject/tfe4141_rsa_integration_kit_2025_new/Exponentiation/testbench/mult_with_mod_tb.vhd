library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult_with_mod_tb is
	generic (
		C_block_size : integer := 256
	);
end mult_with_mod_tb;



architecture mult_behave of mult_with_mod_tb is 

		--constant C_block_size : integer := 256;
		constant clk_period   : time 	:= 10ns;

		signal valid_in 	  :  STD_LOGIC;
		signal ready_in  	  :  STD_LOGIC;

		--input data
		signal a, b, c        :  STD_LOGIC_VECTOR ( C_block_size-1 downto 0);
		signal e              :  std_logic;
		
		--ouput controll
		signal ready_out	  :  STD_LOGIC;
		signal valid_out	  :  STD_LOGIC;

		--output data
		signal result_R 	  :  STD_LOGIC_VECTOR( C_block_size-1 downto 0);
		signal result_P 	  :  STD_LOGIC_VECTOR( C_block_size-1 downto 0);

		--modulus
		signal n              :  STD_LOGIC_VECTOR ( C_block_size-1 downto 0);
		signal n_neg          :  STD_LOGIC_VECTOR ( C_block_size downto 0 );

		-- Precalculated values 
		signal b_minus_n      :  STD_LOGIC_VECTOR ( C_block_size downto 0 );
		signal b_minus_2n     :  STD_LOGIC_VECTOR ( C_block_size downto 0 );
		signal c_minus_n      :  STD_LOGIC_VECTOR ( C_block_size downto 0 );
		signal c_minus_2n     :  STD_LOGIC_VECTOR ( C_block_size downto 0 );
         
		--utility
		signal clk 		      :  STD_LOGIC;
		signal reset_neg 	      :  STD_LOGIC;

		-- Internal Signal
		signal s0, s1 ,s2 ,s3 ,s4, s5, s6, s7, s8, s9, s10, s11 : std_logic_vector(C_block_size downto 0);
		signal bit_shifted_a : std_logic_vector( C_block_size-1 downto 0 );
		signal mux_ctrl_P_out, mux_ctrl_R_out : std_logic_vector(2 downto 0);

		-- state
		signal current_state : std_logic_vector(1 downto 0);

		-- counter
		signal counter       : std_logic_vector(C_block_size-1 downto 0);

		-- Registers for input values
		signal a_reg, b_reg, c_reg: std_logic_vector(C_block_size-1 downto 0);
		signal e_reg : std_logic;

begin 



DUT : entity work.mult_with_mod
	generic map(
		C_block_size => C_block_size
	)
	port map (
	--input controll
		valid_in   =>   valid_in,
		ready_in   =>   ready_in,

	--input data
		a 		   =>   a,
		b 		   =>   b,
		c 		   =>   c,
		e 		   =>   e,

	--ouput controll
		ready_out  =>   ready_out,
		valid_out  =>   valid_out,

	--output data
		result_R   =>   result_R,
		result_P   =>   result_P,
		
	--modulus
		n          =>   n,
		n_neg      =>   n_neg,

	--utility
		clk        =>   clk,
		reset_neg  =>   reset_neg,

		counter			=> counter,
		current_state 	=> current_state
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

	a 			<= std_logic_vector(to_unsigned(100, a'length)); -- a = 100 (1100100)
	b 			<= std_logic_vector(to_unsigned(15, b'length)); -- b = 15
	c 			<= std_logic_vector(to_unsigned(11, c'length)); -- c = 11
	e 			<= '1'; -- e = 1 (perform multiplication)
	
	n			<= std_logic_vector(to_unsigned(1000, n'length)); -- n = 256
	n_neg 		<= std_logic_vector(to_signed(-1000, n_neg'length)); -- n_neg = 256

	valid_in 	<= '0';
	ready_out	<= '0';

	reset_neg 	<= '0'; 

	wait for clk_period*1;

	assert valid_out = '0' report "valid_out not 0 when resetting" severity error;
	assert to_integer(unsigned(result_R)) = 0 report "result_R not 0 when resetting" severity error;
	assert to_integer(unsigned(result_P)) = 0 report "result_P not 0 when resetting" severity error;

	valid_in 	<= '1';
	reset_neg 	<= '1';

	wait for clk_period;

	if (current_state /= "01")then 
	   report "current_state not 01 (COUNTING) one clk_period after valid_in and reset_neg is set to 1" severity error;
	end if;
	
    wait for clk_period*300;  -- wait enough time for the operation to complete


    -- Check if result_R = a*b mod n and result_P = a*c mod n
    report " ---- Checking final results ---- " severity note;
    assert to_integer(unsigned(result_R)) = 220 report "result_R not correct - a*b mod n = 100*15 mod 256 = 220" severity error;
    assert to_integer(unsigned(result_P)) = 76 report "result_P not correct - a*c mod n = 100*11 mod 256 = 76" severity error;
	

	-- Check new values after reset
	wait for clk_period*2;
	ready_out	<= '0';
	reset_neg 	<= '0';

	-----------------------------------------
	-- New input values after reset
	-----------------------------------------
	a 			<= std_logic_vector(to_unsigned(120, a'length)); -- a = 120 (1111000)
	b 			<= std_logic_vector(to_unsigned(385, b'length)); -- b = 385 (110000001)
	c 			<= std_logic_vector(to_unsigned(77, c'length)); -- c = 77 (1001101)
	e 			<= '0'; -- e = 0 (perform squaring)

	valid_in 	<= '1';

	wait for clk_period;
	reset_neg		<= '1';

	wait for clk_period;
	valid_in	<= '0';

	wait for clk_period*300;  -- wait enough time for the operation to complete

	ready_out	<= '1';

	report " ---- Checking final results after reset ---- " severity note;
	-- Check if result_R = a^2 mod n and result_P = a^2 mod n
	assert to_integer(unsigned(result_R)) = 385 report "result_R not correct - b, since e = 0" severity error;
	assert to_integer(unsigned(result_P)) = 24 report "result_P not correct - a * c mod n = 24" severity error;	


    report "------ TEST COMPLETED -------" severity note;
    wait; 
end process test_process;
end mult_behave;