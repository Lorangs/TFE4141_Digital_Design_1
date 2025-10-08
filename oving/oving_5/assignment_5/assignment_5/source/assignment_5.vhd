----------------------------------------------------------------------------------
-- Company: NTNU
-- Engineer:
--
-- Create Date: 06/29/2020 04:04:48 PM
-- Design Name: assignment_5
-- Module Name: assignment_5 - Behavioral
-- Project Name: assignment 5
-- Target Devices: pynq-z1
-- Tool Versions: Vivado 2020.1
-- Description:
-- 	simple top level design for a
-- Dependencies:
-- 	none
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity assignment_5 is
	generic (
		bit_width   : positive := 16
	);
	port (
		--misc
		clk 		: in  std_logic;
		reset_n 	: in  std_logic;
		--data in
		data_in 	: in  std_logic_vector(bit_width-1 downto 0);
		ready_in 	: out std_logic;
		valid_in 	: in  std_logic;
		--data out
		data_out 	: out std_logic_vector(bit_width-1 downto 0);
		ready_out 	: in  std_logic;
		valid_out 	: out std_logic
	);
end assignment_5;


architecture Behavioral of assignment_5 is

	--signals for communicating between controller and datapath
	signal read_b_select 	: std_logic_vector(2 downto 0);
	signal read_a_select 	: std_logic_vector(2 downto 0);
	signal write_select 	: std_logic_vector(4 downto 0);
	signal opcode 			: std_logic_vector(2 downto 0);
	signal input_reg 		: std_logic_vector(bit_width-1 downto 0);
	signal input_equal		: std_logic;
	signal input_greater	: std_logic;

	--registers for data storage
	signal reg0 			: std_logic_vector(bit_width-1 downto 0);
	signal reg1 			: std_logic_vector(bit_width-1 downto 0);
	signal reg2 			: std_logic_vector(bit_width-1 downto 0);
	signal reg3 			: std_logic_vector(bit_width-1 downto 0);

	--wires in and out for the ALU
	signal ALU_output 		: std_logic_vector(bit_width-1 downto 0);
	signal bus_a 			: std_logic_vector(bit_width-1 downto 0);
	signal bus_b 			: std_logic_vector(bit_width-1 downto 0);
begin
	

	--instantiate the controller and connect it to the required components
	i_controller : entity work.controller(Behavioral)
		generic map (
			bit_width => bit_width
		)
		port map (
			clk           	=> clk           ,
			reset_n       	=> reset_n       ,
			data_in       	=> data_in       ,
			ready_in      	=> ready_in      ,
			valid_in      	=> valid_in      ,
			ready_out     	=> ready_out     ,
			valid_out     	=> valid_out     ,
			read_a_select   => read_a_select ,
			read_b_select   => read_b_select ,
			write_select  	=> write_select  ,
			opcode        	=> opcode        ,
			input_equal   	=> input_equal   ,
			input_greater 	=> input_greater
		);

	-- a combinatorical process for selecting A and B inputs to the ALY
	read_proc : process (read_a_select,read_b_select,data_in,reg0,reg1,reg2,reg3)
	begin
		MUX_A : case(read_a_select) is
			when "000" =>	bus_a <= reg0;
			when "001" =>	bus_a <= reg1;
			when "010" =>	bus_a <= reg2;
			when "011" =>	bus_a <= reg3;
			when "100" =>	bus_a <= data_in;
			when others =>	bus_a <= (others=>'0');
		end case MUX_A;
		MUX_B : case(read_b_select) is
			when "000" =>	bus_b <= reg0;
			when "001" =>	bus_b <= reg1;
			when "010" =>	bus_b <= reg2;
			when "011" =>	bus_b <= reg3;
			when "100" =>	bus_b <= data_in;
			when others =>	bus_b <= (others=>'0');
		end case MUX_B;
	end process read_proc;


	i_ALU : entity work.ALU(Behavioral)
		generic map (
			bit_width => bit_width
		)
		port map (
			opcode        => opcode        ,
			data_a        => bus_a         ,
			data_b        => bus_b         ,
			data_out      => alu_output    ,
			input_equal   => input_equal   ,
			input_greater => input_greater
		);



	write_proc : process (reset_n, clk)
	begin
		if (reset_n = '0') then
			--resetting all registers
			reg0 <= (others=>'0');
			reg1 <= (others=>'0');
			reg2 <= (others=>'0');
			reg3 <= (others=>'0');
			data_out <= (others=>'0');
		elsif (rising_edge(clk)) then
			--because the signals are written to inside a clocked process they become registers
			--(insiside the rising_edge(clk) block)

			--if the writing is inside an if block, the condition is sendt to the enable signal of the register
			if write_select(0) = '1' then
				reg0 <= alu_output;
			end if ;

			if write_select(1) = '1' then
				reg1 <= alu_output;
			end if ;

			if write_select(2) = '1' then
				reg2 <= alu_output;
			end if ;

			if write_select(3) = '1' then
				reg3 <= alu_output;
			end if ;

			if write_select(4) = '1' then
				data_out <= alu_output;
			end if ;

		end if;
	end process write_proc;



end Behavioral;
