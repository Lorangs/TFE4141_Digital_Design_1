library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exponentiation_tb is
	generic (
		C_block_size : integer := 256
	);
end exponentiation_tb;



architecture expBehave of exponentiation_tb is 
	--port();
		--constant C_block_size : integer := 256;
		constant clk_period   : time 	:= 10ns;

		signal valid_in 	  :  STD_LOGIC;
		signal ready_in  	  :  STD_LOGIC;

		--input data
		signal a, b, c        :  STD_LOGIC_VECTOR ( C_block_size-1 downto 0);
		
		--ouput controll
		signal ready_out	  :  STD_LOGIC;
		signal valid_out	  :  STD_LOGIC;

		--output data
		signal result_R 	  :  STD_LOGIC_VECTOR( C_block_size-1 downto 0);
		signal result_P 	  :  STD_LOGIC_VECTOR( C_block_size-1 downto 0);

		--modulus
		signal n              :  STD_LOGIC_VECTOR ( C_block_size-1 downto 0);
		signal n_neg          :  STD_LOGIC_VECTOR ( C_block_size downto 0 );
         
		--utility
		signal clk 		      :  STD_LOGIC;
		signal reset_n 	      :  STD_LOGIC;

		-- Internal Signal
		signal s0, s1 ,s2 ,s3 ,s4, s5, s6, s7, s8, s9, s10, s11 : std_logic_vector(C_block_size downto 0);
		signal mux_ctrl_P_out, mux_ctrl_R_out : std_logic_vector(2 downto 0);

begin 



DUT : entity work.exponentiation
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
		reset_n    =>   reset_n,

	-- Internal Signal
		s0         =>   s0,
		s1         =>   s1,
		s2         =>   s2,
		s3         =>   s3,
		s4         =>   s4,
		s5         =>   s5,
		s6         =>   s6,
		s7         =>   s7,
		s8         =>   s8,
		s9         =>   s9,
		s10        =>   s10,
		s11        =>   s11,		
		mux_ctrl_R_out      =>   mux_ctrl_R_out,
		mux_ctrl_P_out	=> mux_ctrl_P_out      
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

	-- Start test with setting input values and resetting the module (reset_n = 0)

	a 			<= std_logic_vector(to_unsigned(100, a'length)); -- a = 100 (1100100)
	b 			<= std_logic_vector(to_unsigned(15, b'length)); -- b = 15
	c 			<= std_logic_vector(to_unsigned(11, c'length)); -- c = 11
	
	n			<= std_logic_vector(to_unsigned(19, n'length)); -- n = 19
	n_neg 		<= std_logic_vector(to_signed(-19, n_neg'length)); -- n_neg = 19

	valid_in 	<= '0';
	ready_out	<= '0';

	reset_n 	<= '0'; 

	wait for clk_period*2;

	-- asserting reset values for s0-s11 (except for values we expect to be unknown - s3, s5, s9, s11)
	assert to_integer(signed(s0)) = 0 report "s0 is not 0 when resetting" severity error;
	assert s1 = ('0' & b) report "s1 is not b when resetting" severity error;
	assert s2 = std_logic_vector(signed('0' & b) + signed(n_neg)) report "s2 is not b-n when resetting" severity error;
	assert s4 = std_logic_vector(signed('0' & b) + signed(shift_left(signed(n_neg), 1))) report "s4 is not b-2n when resetting" severity error;
	
	assert to_integer(unsigned(s6)) = 0 report "s6 is not 0 when resetting" severity error;
	assert s7 = ('0' & c) report "s7 is not c when resetting" severity error;
	assert s8 = std_logic_vector(signed('0' & c) + signed(n_neg)) report "s8 is not c-n when resetting" severity error;
	assert s10 = std_logic_vector(signed('0' & c) + signed(shift_left(signed(n_neg), 1))) report "s10 is not c-2n when resetting" severity error;

	-- test if the signals stay the same when reset_n = 0, but valid_in is still 0 
	reset_n		<= '1'; 
	wait for clk_period*2;

	-- checking if values of s0-s11 stay the same (except for the still unknown values - s3, s5, s9, s11)
	assert to_integer(signed(s0)) = 0 report "s0 is not 0 when resetting" severity error;
	assert s1 = ('0' & b) report "s1 is not b when resetting" severity error;
	assert s2 = std_logic_vector(signed('0' & b) + signed(n_neg)) report "s2 is not b-n when resetting" severity error;
	assert s4 = std_logic_vector(signed('0' & b) + signed(shift_left(signed(n_neg), 1))) report "s4 is not b-2n when resetting" severity error;
	
	assert to_integer(unsigned(s6)) = 0 report "s6 is not 0 when resetting" severity error;
	assert s7 = ('0' & c) report "s7 is not c when resetting" severity error;
	assert s8 = std_logic_vector(signed('0' & c) + signed(n_neg)) report "s8 is not c-n when resetting" severity error;
	assert s10 = std_logic_vector(signed('0' & c) + signed(shift_left(signed(n_neg), 1))) report "s10 is not c-2n when resetting" severity error;


	valid_in	<= '1';

	wait for clk_period*20;
    
    
    -- Check if result_R = a*b mod n and result_P = a*c mod n
    report " ---- Checking final results ---- " severity note;
    assert to_integer(unsigned(result_R)) = 18 report "result_R not correct - a*b mod n = 100*15 mod 256 = 220" severity error;
    assert to_integer(unsigned(result_P)) = 17 report "result_P not correct - a*c mod n = 100*11 mod 256 = 76" severity error;
	
	

    report "------ TEST COMPLETED -------" severity note;
    wait; 
end process test_process;


end expBehave;