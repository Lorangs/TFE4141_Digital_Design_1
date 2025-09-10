----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.09.2025 17:20:15
-- Design Name: 
-- Module Name: task1 - Behavioral
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

entity task1 is
end task1;

architecture Behavioral of task1 is
    signal D, G, Q : std_logic;
begin

latch1: entity work.latch(latch_behavior)
        port map (D => D, Q => Q, G => G);

stimulus: process is 
begin
    D <= '1'; wait for 2 ns;
    G <= '1'; wait for 10 ns;
    D <= '0'; wait for 10 ns;
    G <= '0'; wait for 10 ns;
    D <= '1'; wait for 10 ns;
    report std_logic'image(Q);
    wait; 
end process stimulus;


end Behavioral;
