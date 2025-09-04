----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2025 04:39:56 PM
-- Design Name: 
-- Module Name: TB_main_logic - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_main_logic is
--  Port ( );
end TB_main_logic;

architecture Behavioral of TB_main_logic is

signal A, B, QN, Q: std_logic;

begin

DUT: entity work.main_logic(Behavioral)
    port map(A => A, B => B, QN => QN, Q => Q);  

noe: process is 

begin 

A <= '1' ; B <= '0' ;
wait for 10 ns ;
A <= '0' ;
wait for 10 ns ;
B <= '1' ;
wait for 10 ns ;
B <= '0' ;
wait for 10 ns ;
B <= '1' ; A <= '1' ;
wait for 100 ns ;

end process noe;


end Behavioral;
