----------------------------------------------------------------------------------
-- Company: NTNU
-- Engineer:
--
-- Create Date: 06/29/2020 04:04:48 PM
-- Design Name: ALU
-- Module Name: ALU - Behavioral
-- Project Name: assignment 5
-- Target Devices: pynq-z1
-- Tool Versions: Vivado 2020.1
-- Description:
-- 	simple accumulator alu for assignment 5
-- Dependencies:
-- 	none
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
	generic (
		bit_width : natural := 8
	);
	Port (
		--controll
		opcode 			: in std_logic_vector(2 downto 0);
		--data
		data_a  		: in  std_logic_vector(bit_width-1 downto 0);
		data_b  		: in  std_logic_vector(bit_width-1 downto 0);
		data_out 		: out std_logic_vector(bit_width-1 downto 0);
		input_equal		: out std_logic;
		input_greater	: out std_logic
	);
end ALU;

architecture Behavioral of ALU is
begin
	main_proc : process (opcode,data_a,data_b)
	begin
		case(opcode) is
			when "000" => --load
				data_out <= data_a;
			when "001" => --add
				data_out <= std_logic_vector(Unsigned(data_a)+Unsigned(data_b));
			when "010" => --sub
				data_out <= std_logic_vector(Unsigned(data_a)-Unsigned(data_b));
			when "011" => --and
				data_out <= data_a and data_b;
			when "100" => --or
				data_out <= data_a or data_b;
			when "101" => --xor
				data_out <= data_a xor data_b;
			when "110" => --shift left
				data_out <= data_a sll to_integer(unsigned(data_b));
			when "111" => --shift Right
				data_out <= data_a srl to_integer(unsigned(data_b));
			when others =>
				data_out <= (others=>'X');
		end case;
	end process main_proc;

	comp_proc : process (data_a,data_b)
	begin
		if Unsigned(data_a) > Unsigned(data_b) then
			input_greater <= '1';
		else
			input_greater <= '0';
		end if;
		if Unsigned(data_a) = Unsigned(data_b) then
			input_equal <= '1';
		else
			input_equal <= '0';
		end if;
	end process comp_proc;



end Behavioral;
