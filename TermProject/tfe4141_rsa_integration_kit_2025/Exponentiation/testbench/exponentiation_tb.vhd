library ieee;
use ieee.std_logic_1164.all;

--entity exponentiation_tb is
--	generic (
--		C_block_size : integer := 256
--	);
--end exponentiation_tb;


architecture expBehave of exponentiation_tb is 
		valid_in	:  STD_LOGIC;
		ready_in	:  STD_LOGIC;

		--input data
		a           :  STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
	    b           :  STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
        c           :  STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
		
		--ouput controll
		ready_out	:  STD_LOGIC;
		valid_out	:  STD_LOGIC;

		--output data
		result_R 	:  STD_LOGIC_VECTOR(C_block_size-1 downto 0);
		result_P 	:  STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		--modulus
		n           :  STD_LOGIC_VECTOR ( C_block_size downto 0 );
		n_neg       :  STD_LOGIC_VECTOR ( C_block_size downto 0 );
         
		--utility
		clk 		:  STD_LOGIC;
		reset_n 	:  STD_LOGIC;

		-- Internal Signal
		signal s0, s1 ,s2 ,s3 ,s4, s5, R_new: std_logic_vector(C_block_size downto 0);
		constant C_block_size := 256;


begin
a_clock : process
begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process  a_clock;

begin
	DUT : entity work.exponentiation
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
			result_R   =>   moduluresult_Rs,
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
			R_new      =>   R_new      
	);

end expBehave;


test_of_exponentiation : process
begin
-- signaler som ikke kommer fra FSM 
-- ready_in, reset_n

-- styre signaler fra FSM
-- ready_in, valid_out, load_result

valid_out
reset_n --lav

wait for clk_period;
-- first test, what happens if handshake is not good. 
-- handsake should be valid when ready and valid are high

end process



end exponentiation_tb