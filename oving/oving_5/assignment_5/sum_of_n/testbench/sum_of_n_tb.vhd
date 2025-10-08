----------------------------------------------------------------------------------
-- Company: NTNU
-- Engineer: 
-- 
-- Create Date: 06/29/2020 04:04:48 PM
-- Design Name: sum_of_n_tb
-- Module Name: sum_of_n_tb - Behavioral
-- Project Name: assignment 5
-- Target Devices: pynq-z1
-- Tool Versions: Vivado 2020.1
-- Description: 
-- 	testbench for assignment 5.
--	should not be necessarry to edit
-- Dependencies: 
-- 	none
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library std;
use std.textio.all;

entity sum_of_n_tb is
	generic (
		--bit_width controlls the number of wires in the input and output bus of the design
		bit_width 			: natural := 16;
		--the maximum number of values to be summed in a stream
		max_stream_length 	: positive := 16;
		--test_set_size controlls the number of values stored for the input stream.
		test_set_size 		: natural := 128
	);
end sum_of_n_tb;


architecture Behavioral of sum_of_n_tb is

	--interface signals for the Design Under Test
	signal data_in 			: std_logic_vector(bit_width-1 downto 0);
	signal data_in_valid 	: std_logic := '0';
	signal data_in_ready 	: std_logic;
	signal data_out 		: std_logic_vector(bit_width-1 downto 0);
	signal data_out_valid 	: std_logic;
	signal data_out_ready 	: std_logic := '0';
	signal clock 			: std_logic := '0';
	signal reset_n 			: std_logic := '0';


	--utility function for writing std_logic_vectors to terminal

	function stdvec_to_string ( a: std_logic_vector) return string is
		variable b : string (a'length/4 downto 1) := (others => NUL);
		variable nibble : std_logic_vector(3 downto 0);
	begin
		for i in b'length downto 1 loop
			nibble := a(i*4-1 downto (i-1)*4);
			case nibble is
				when "0000" => b(i) := '0';
				when "0001" => b(i) := '1';
				when "0010" => b(i) := '2';
				when "0011" => b(i) := '3';
				when "0100" => b(i) := '4';
				when "0101" => b(i) := '5';
				when "0110" => b(i) := '6';
				when "0111" => b(i) := '7';
				when "1000" => b(i) := '8';
				when "1001" => b(i) := '9';
				when "1010" => b(i) := 'A';
				when "1011" => b(i) := 'B';
				when "1100" => b(i) := 'C';
				when "1101" => b(i) := 'D';
				when "1110" => b(i) := 'E';
				when "1111" => b(i) := 'F';
				when others => b(i) := 'X';
			end case;
		end loop;
		return b;
	end function;

	constant CLK_PERIOD    : time := 10 ns;



	type test_data_type is array (test_set_size downto 0) of std_logic_vector(bit_width-1 downto 0);
	signal test_data_a,test_data_result : test_data_type;
	signal test_size,result_size : integer;

	--utility function for generating random logic vectors
	function random_std_vec (
		size  : integer ;
		seeda : positive;
		seedb : positive
	) return std_logic_vector is
		variable result 	: std_logic_vector(size-1 downto 0) := (others=>'0');
		variable seed1 		: positive;
		variable seed2 		: positive;
		variable rand  		: real;
	begin
		seed1 := seeda;
		seed2 := seedb;
		for i in size-1 downto 0 loop
			uniform(seed1, seed2, rand);
			if rand>0.5 then
				result(i) := '1';
			else
				result(i) := '0';
			end if;
		end loop;

		return result;
	end function;


	--utility procedure for filling inn test data
	procedure generate_test_data(
		signal data_a 		: inout test_data_type;
		signal data_result 	: inout test_data_type;
		signal test_size 	: inout integer;
		signal result_size 	: inout integer
	) is
		variable seed1 		: positive;
		variable seed2 		: positive;
		variable rand  		: real;
		variable len   		: integer;
		variable pos   		: integer:=0;
		variable result_pos : integer:=0;
		variable temp  		: std_logic_vector(bit_width-1 downto 0);
		variable sum   		: unsigned(bit_width-1 downto 0);
	begin
		--calculating test data a
		for o in 0 to test_set_size-1 loop
			--generate a random number to decide the length of the stream
			uniform(seed1, seed2, rand);
			len := integer(floor(rand * ((max_stream_length - 1) * 1.0))) + 1;
			--if the stream will fit in the allocated std_vector_array, add it
			if pos+len+1<test_set_size then
				--prefix stream with length
				data_a(pos)<=std_logic_vector(to_unsigned(len, bit_width));
				sum := (others=>'0');
				pos := pos+1;
				if len>0 then
					--add all the following numbers
					for k in 0 to len-1 loop
						temp := random_std_vec(bit_width,k+o+len,pos+len);
						data_a(pos) <= temp;
						sum := sum + unsigned(temp);
						pos := pos+1;
					end loop;
				end if;
				data_result(result_pos) <= std_logic_vector(sum);
				result_pos := result_pos + 1;
			end if;
		end loop;
		result_size <= result_pos-1;
		test_size <= pos-1;
		report "generated test data:\n\r" &
		       "    input  size (0 to " & integer'image(test_size) & ")\r\n"&
		       "    output size (0 to " & integer'image(result_size) & ")";
	end generate_test_data;


	


begin


	-----------------------------------------------------------------------------
	-- Clock and reset generation
	-----------------------------------------------------------------------------

 	clock <= not clock after CLK_PERIOD/2;

	-- reset_n generator
	reset_gen: process is
	begin
		reset_n <= '0';
		wait for 20 ns;
		reset_n <= '1';
		wait;
	end process reset_gen;

	-- test data generator
	test_data_gen: process is
	begin
		--not strictly necesarry to put in a procedure
		-- but this enables reuse of the test generator
		generate_test_data(
			data_a 		=> test_data_a,
			data_result => test_data_result,
			test_size 	=> test_size,
			result_size => result_size
		);
		wait;
	end process test_data_gen;


	-----------------------------------------------------------------------------
	-- pushing data to data_inn
	-----------------------------------------------------------------------------

	datapusher : process is
	begin
		wait for 60 ns;
		wait until rising_edge(clock);
		write_all : for i in 0 to test_size loop
			data_in <= test_data_a(i);
			data_in_valid <= '1';
			if (data_in_ready = '0') then
				wait until rising_edge(data_in_ready);
			end if;
			
			wait until rising_edge(clock);
			data_in_valid <= '0';
			
			wait until rising_edge(clock);

		end loop write_all;
		wait;
	end process datapusher;

	-----------------------------------------------------------------------------
	-- pulling data from data_out
	-----------------------------------------------------------------------------

	data_puller : process is
		variable readout : std_logic_vector(bit_width-1 downto 0);
	begin
		wait for 60 ns;
		wait until rising_edge(clock);
		readout_all : for i in 0 to result_size loop
			report "initializing test " & integer'image(i);
			data_out_ready <= '1';
			if (data_out_valid = '0') then
				wait until rising_edge(data_out_valid);
			end if;

			wait until rising_edge(clock);
			readout := data_out;
			data_out_ready<='0';
			
			wait until rising_edge(clock);

			--check for correctness
			assert test_data_result(i) = readout
				report "incorrect data; test " & integer'image(i) & " expected [" & stdvec_to_string(test_data_result(i)) & "] got [" & stdvec_to_string(readout) & "]"
					severity failure;
		end loop readout_all;
		wait for 10*CLK_PERIOD;
		--this is to stop the simulation
		assert false report "all tests done" severity failure;
	end process data_puller;




	DUT : entity work.sum_of_n
	--	change this generic map to use the generics in the testbench
	--  generics cannot be used with post synthesis and post implementation simulations
	--  this is because after synthesis the module is no longer configurable with generics
	--	generic map (
	--		bit_width => bit_width
	--	)
		port map (
			clk       => clock         ,
			reset_n   => reset_n       ,
			data_in   => data_in       ,
			ready_in  => data_in_ready ,
			valid_in  => data_in_valid ,
			data_out  => data_out      ,
			ready_out => data_out_ready,
			valid_out => data_out_valid
		);






end Behavioral;


