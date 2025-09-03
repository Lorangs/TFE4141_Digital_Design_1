----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2025 04:32:28 PM
-- Design Name: 
-- Module Name: logic_tb - Behavioral
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

library work;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity logic_tb is
end logic_tb;

architecture test_logic of logic_tb is
    signal A, B, Q, QN : std_ulogic;
begin
    DUT: entity work.logic(behaviour)
        port map(A => A, B => B, Q => Q, QN => QN);
        
    stimulus: process is
    begin
        A <= '1'; B <= '0';
        wait for 10ns;
        A <= '0';
        wait for 10ns;
        B <= '1';
        wait for 10ns;
        B <= '0';
        wait for 10ns;
        B <= '1'; A <= '1';
        wait;
    end process stimulus;
end test_logic;
