----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2025 15:27:47
-- Design Name: 
-- Module Name: exponentiation_fsm - expFsmBehave
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

entity exponentiation_fsm is
    Port ( enable : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           clk : in STD_LOGIC;
           n_p_1 : in STD_LOGIC;
           result_valid : out STD_LOGIC);
end exponentiation_fsm;

architecture expFsmBehave of exponentiation_fsm is

begin


end expFsmBehave;
