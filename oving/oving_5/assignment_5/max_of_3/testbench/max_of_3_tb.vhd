----------------------------------------------------------------------------------
-- Company: NTNU
-- Engineer: 
-- 
-- Create Date: 06/29/2020 04:04:48 PM
-- Design Name: max_of_3_tb
-- Module Name: max_of_3_tb - max_3
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

entity max_of_3_tb is
	generic (
		bit_width 		: positive := 16;
		test_set_size 	: positive := 1024
	);
end max_of_3_tb;




architecture max_3 of max_of_3_tb is

	signal data_in 			: std_logic_vector(bit_width-1 downto 0);
	signal data_in_valid 	: std_logic := '0';
	signal data_in_ready 	: std_logic;
	signal data_out 		: std_logic_vector(bit_width-1 downto 0);
	signal data_out_valid 	: std_logic;
	signal data_out_ready 	: std_logic := '0';
	signal clock 			: std_logic := '0';
	signal reset_n 			: std_logic := '0';


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



	type test_data_type is array(test_set_size-1 downto 0) of std_logic_vector(bit_width-1 downto 0);
	signal test_data_a : test_data_type;
	signal test_data_b : test_data_type;
	signal test_data_c : test_data_type;

	procedure generate_test_data(
		signal data_a : out test_data_type;
		signal data_b : out test_data_type;
		signal data_c : out test_data_type
	) is
		variable seed1 : positive;
		variable seed2 : positive;
		variable rand  : real;
	begin
		--generate test data for a
		for o in test_set_size-1 downto 0 loop
			for i in bit_width-1 downto 0 loop
				uniform(seed1, seed2, rand);
				if rand>0.5 then
					data_a(o)(i) <= '1';
				else
					data_a(o)(i) <= '0';
				end if;
			end loop;
		end loop;
		--generate test data for b
		for o in test_set_size-1 downto 0 loop
			for i in bit_width-1 downto 0 loop
				uniform(seed1, seed2, rand);
				if rand>0.5 then
					data_b(o)(i) <= '1';
				else
					data_b(o)(i) <= '0';
				end if;
			end loop;
		end loop;
		--generate test data for c
		for o in test_set_size-1 downto 0 loop
			for i in bit_width-1 downto 0 loop
				uniform(seed1, seed2, rand);
				if rand>0.5 then
					data_c(o)(i) <= '1';
				else
					data_c(o)(i) <= '0';
				end if;
			end loop;
		end loop;
	end generate_test_data;


	--reference implementation for max function
	function max (
		a,b,c: std_logic_vector
		) return std_logic_vector is
	variable au,bu,cu : unsigned(bit_width-1 downto 0) ;
	begin
		au:=unsigned(a);
		bu:=unsigned(b);
		cu:=unsigned(c);
		
		if a>b then
			if (a>c) then
				return std_logic_vector(a);
			else
				return std_logic_vector(c);
			end if;
		else
			if b>c then
				return std_logic_vector(b);
			else
				return std_logic_vector(c);
			end if;
		end if;
	end function;
begin


	-----------------------------------------------------------------------------
	-- Clock and reset generation
	-----------------------------------------------------------------------------

 	clock <= not clock after CLK_PERIOD/2;

	reset_gen: process is
	begin
		generate_test_data(
			data_a => test_data_a,
			data_b => test_data_b,
			data_c => test_data_c
		);
		reset_n <= '0';
		wait for 20 ns;
		reset_n <= '1';
		wait;
	end process;

	-----------------------------------------------------------------------------
	-- pushing data to data_inn
	-----------------------------------------------------------------------------

	datapusher : process is
	begin
		wait for 60 ns;
		wait until rising_edge(clock);
		write_all : for i in test_set_size-1 downto 0 loop
			--write test data a
			data_in <= test_data_a(i);
			data_in_valid <= '1';
			if (data_in_ready = '0') then
				wait until rising_edge(data_in_ready);
			end if;
			wait until falling_edge(clock);
			wait until rising_edge(clock);
			data_in_valid <= '0';
			wait until falling_edge(clock);
			wait until rising_edge(clock);

			--write test data b
			data_in <= test_data_b(i);
			data_in_valid <= '1';
			if (data_in_ready = '0') then
				wait until rising_edge(data_in_ready);
			end if;
			wait until falling_edge(clock);
			wait until rising_edge(clock);
			data_in_valid <= '0';
			wait until falling_edge(clock);
			wait until rising_edge(clock);

			--write test data c
			data_in <= test_data_c(i);
			data_in_valid <= '1';
			if (data_in_ready = '0') then
				wait until rising_edge(data_in_ready);
			end if;
			wait until falling_edge(clock);
			wait until rising_edge(clock);
			data_in_valid <= '0';
			wait until falling_edge(clock);
			wait until rising_edge(clock);

		end loop write_all;
		wait;
	end process datapusher;


	-----------------------------------------------------------------------------
	-- pulling data from data out
	-----------------------------------------------------------------------------

	data_puller : process is
		variable readout : std_logic_vector(bit_width-1 downto 0);
	begin
		wait for 60 ns;
		wait until rising_edge(clock);
		readout_all : for i in test_set_size-1 downto 0 loop

			data_out_ready <= '1';
			if (data_out_valid = '0') then
				wait until rising_edge(data_out_valid);
			end if;
			wait until falling_edge(clock);
			readout := data_out;
			wait until rising_edge(clock);
			data_out_ready<='0';
			wait until falling_edge(clock);
			wait until rising_edge(clock);

			--report "done pulling test " & integer'image(i) & " value: " &stdvec_to_string(test_data(i));
			report "tests " & integer'image(i) & " : [" &stdvec_to_string(max(test_data_a(i),test_data_b(i),test_data_c(i))) & "] = [" & stdvec_to_string(readout)&"]";
			assert max(test_data_a(i),test_data_b(i),test_data_c(i)) = readout
				report "incorrect data; test " & integer'image(i) & " expected [" & stdvec_to_string(max(test_data_a(i),test_data_b(i),test_data_c(i))) & "] got [" & stdvec_to_string(readout) & "]   "
					& "max([" & stdvec_to_string(test_data_a(i)) &"],["& stdvec_to_string(test_data_b(i)) &"],["& stdvec_to_string(test_data_c(i)) &"])=["&stdvec_to_string(max(test_data_a(i),test_data_b(i),test_data_c(i)))&"]"
					severity failure;
		end loop readout_all;
		wait for 10*CLK_PERIOD;
		assert false report "all tests done" severity failure;
	end process data_puller;




	DUT : entity work.max_of_3
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






end max_3;


