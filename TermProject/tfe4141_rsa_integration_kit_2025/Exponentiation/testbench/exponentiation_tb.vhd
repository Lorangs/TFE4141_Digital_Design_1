library ieee;
use ieee.std_logic_1164.all;

entity exponentiation_tb is
end exponentiation_tb;


architecture expBehave of exponentiation_tb is 
	--port(;
		constant C_block_size : integer := 256;
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
		signal s0, s1 ,s2 ,s3 ,s4, s5, R_new: std_logic_vector(C_block_size downto 0);

begin 

a_clock : process
begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process  a_clock;


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
		s6         =>   s6,
		s7         =>   s7,
		s8         =>   s8,
		s9         =>   s9,
		s10        =>   s10,
		s11         =>   s11,		
		mux_ctrl_R_out      =>   mux_ctrl_R_out,
		mux_ctrl_P_out	=> mux_ctrl_P_out      
);
--end expBehave;


test_of_exponentiation : process
begin
-- signaler som ikke kommer fra FSM 
-- ready_in, reset_n

-- styre signaler fra FSM
-- ready_in, valid_out, load_result

-- is it possible to writte the state out in the testbench.


wait for clk_period;


--test_zero sett all to zero
valid_in <= '0';

a 			<= (others => '0');
b 			<= (others => '0');
c 			<= (others => '0');

ready_out 	<= '0';

--n			<= (others => '0');
n			<= (others => '1');


n_neg 		<= (others => '1') ;
n_neg(C_block_size) <= '1';

reset_n 	<= '1';

wait for clk_period;
 
-- first test, does it work as it is supposed to?
-- A message with just a nuumber, 

valid_in <= '1';
-- ready_in is output

a 			<= (others => '0');
a(2)		<= '1';
b 			<= (others => '0');
b(1)		<= '1';
c 			<= (others => '0');
c(0)		<= '1';

wait for clk_period;

-- third test, try to reset

reset_n <= '1';


--fourth test and more copilot assisted :)
 
-- forslag til tests
-- what happens if handshake is not good. 
-- handsake should be valid when ready and valid are high
-- what happens if there is an unexcpeted invalid signal?
-- 





end process;



end expBehave;