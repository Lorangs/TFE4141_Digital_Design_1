----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/15/2025 11:28:21 AM
-- Design Name: 
-- Module Name: latched - Behavioral
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

entity latched is
    Port ( in_1 : in STD_LOGIC;
           D : in STD_LOGIC;
           Q : out STD_LOGIC;
           in_out : inout STD_LOGIC;
           CLK : in STD_LOGIC);
end latched;

architecture Behavioral of latched is

begin


end Behavioral;
