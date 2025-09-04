----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2025 04:37:45 PM
-- Design Name: 
-- Module Name: main_logic - Behavioral
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
-- hei

entity main_logic is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           QN : buffer STD_LOGIC;
           Q : buffer STD_LOGIC);
end main_logic;

architecture Behavioral of main_logic is

begin
Q <= A nor QN;
QN <= B nor Q;

end Behavioral;
