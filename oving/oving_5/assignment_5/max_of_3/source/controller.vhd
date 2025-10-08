----------------------------------------------------------------------------------
-- Company: NTNU
-- Engineer:
--
-- Create Date: 06/29/2020 04:04:48 PM
-- Design Name: controller
-- Module Name: controller - Behavioral
-- Project Name: assignment 5
-- Target Devices: pynq-z1
-- Tool Versions: Vivado 2020.1
-- Description:
-- 	the controller for assignment 5
--	is to be implemented as a statemachine
-- Dependencies:
-- 	none
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity controller is
	generic (
		bit_width 			: positive := 8
	);
	port (
		--misc
		clk 				: in  std_logic;
		reset_n 			: in  std_logic;

		--data
		data_in 			: in  std_logic_vector(bit_width-1 downto 0);

		--external controll signals
		ready_in 			: out std_logic;
		valid_in 			: in  std_logic;

		ready_out 			: in  std_logic;
		valid_out 			: out std_logic;

		--internal controll signals
		read_a_select 		: out std_logic_vector(2 downto 0);
		read_b_select 		: out std_logic_vector(2 downto 0);
		write_select 		: out std_logic_vector(4 downto 0);
		opcode 				: out std_logic_vector(2 downto 0);
		input_equal			: in  std_logic;
		input_greater		: in  std_logic
	);
end controller;

architecture Behavioral of controller is

	--enumerate for ALU opcodes
	constant alu_load		: std_logic_vector(2 downto 0) := "000";
	constant alu_add		: std_logic_vector(2 downto 0) := "001";
	constant alu_sub		: std_logic_vector(2 downto 0) := "010";
	constant alu_and		: std_logic_vector(2 downto 0) := "011";
	constant alu_or			: std_logic_vector(2 downto 0) := "100";
	constant alu_xor		: std_logic_vector(2 downto 0) := "101";
	constant alu_shift_left	: std_logic_vector(2 downto 0) := "110";
	constant alu_shift_Right: std_logic_vector(2 downto 0) := "111";

	--enumerate for read sources
	constant read_reg0		: std_logic_vector(2 downto 0) := "000";
	constant read_reg1		: std_logic_vector(2 downto 0) := "001";
	constant read_reg2		: std_logic_vector(2 downto 0) := "010";
	constant read_reg3		: std_logic_vector(2 downto 0) := "011";
	constant read_input		: std_logic_vector(2 downto 0) := "100";

	--enumerate for write sources
	constant write_reg0		: std_logic_vector(4 downto 0) := "00001";
	constant write_reg1		: std_logic_vector(4 downto 0) := "00010";
	constant write_reg2		: std_logic_vector(4 downto 0) := "00100";
	constant write_reg3		: std_logic_vector(4 downto 0) := "01000";
	constant write_output	: std_logic_vector(4 downto 0) := "10000";
	constant write_none 	: std_logic_vector(4 downto 0) := "00000";

	type state_type is (
		--states for reading inputs
		read_a,read_b,read_c,
		--states for comparing values
		comp_R0R1,comp_R1R2,
		--states for outputting data
		write_output_state,wait_output
	);
	signal state,state_next : state_type;
begin

	main_statem_proc : process (state,valid_in,ready_out,input_equal,input_greater)
	begin
		--default values
		--included at the as to make it unessesarry to specify in every case
		--this may hide errors, but prevents unintended latches
		opcode <= alu_load;
		read_a_select <= read_reg0;
		read_b_select <= read_reg0;
		ready_in <= '0';
		valid_out <= '0';
		state_next <= read_a;
		write_select <= write_none;
		
		--main implementation of statemachine
		case(state) is
			when read_a =>
				ready_in <= '1';
				read_a_select <= read_input;
				opcode <= alu_load;
				if valid_in = '1' then
					write_select <= write_reg0;
					state_next <= read_b;
				else
					write_select <= write_none;
					state_next <= read_a;
				end if;
			
			when read_b =>
				ready_in 		<= '1';
				read_a_select 	<= read_input;
				opcode 			<= alu_load;
				if valid_in = '1' then
					write_select 	<= write_reg1;
					state_next 		<= read_c;
				else
					write_select 	<= write_none;
					state_next 		<= read_b;
				end if;
			
			when read_c =>
				ready_in <= '1';
				read_a_select <= read_input;
				opcode <= alu_load;
				if valid_in = '1' then
					write_select <= write_reg2;
					state_next <= comp_R0R1;
				else
					write_select <= write_none;
					state_next <= read_c;
				end if;
			
			when comp_R0R1 =>
				read_a_select <= read_reg0;
				read_b_select <= read_reg1;
				opcode <= alu_load;
				if input_greater = '1' then
					write_select <= write_reg1;
				else
					write_select <= write_none;
				end if;
				state_next <= comp_R1R2;
			
			when comp_R1R2 =>
				read_a_select <= read_reg1;
				read_b_select <= read_reg2;
				opcode <= alu_load;
				if input_greater = '1' then
					write_select <= write_reg2;
				else
					write_select <= write_none;
				end if;
				state_next <= write_output_state;
			
			when write_output_state =>
				read_a_select <= read_reg2;
				opcode <= alu_load;
				write_select <= write_output;
				state_next <= wait_output;
			
			when wait_output =>
				if ready_out = '1' then
					state_next <= read_a;
				else
					state_next <= wait_output;
				end if;
				valid_out <= '1';
			
			when others =>
				read_a_select <= read_reg0;
				read_b_select <= read_reg0;
				write_select <= write_none;
				valid_out <= '0';
				ready_in <= '0';
				opcode <= alu_load;
				state_next <= read_a;
		end case;
	end process main_statem_proc;


	update_state : process (reset_n, clk)
	begin
		if (reset_n = '0') then
			state <= read_a;
		elsif (rising_edge(clk)) then
			state <= state_next;
		end if;
	end process update_state;


end Behavioral;
