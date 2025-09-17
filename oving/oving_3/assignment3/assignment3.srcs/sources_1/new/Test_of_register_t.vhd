----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2025 02:42:58 PM
-- Design Name: 
-- Module Name: Test_of_register_t - Behavioral
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

entity Test_of_register_t is
    Port ( y     : out STD_ULOGIC;
           CLK   : in std_ulogic;
           reset : in std_ulogic;
           a     : in std_ulogic;
           b     : in std_ulogic);
end Test_of_register_t;

architecture Behavioral_1 of Test_of_register_t is

begin 
    process (clk, reset) is 
        variable t : std_ulogic; 
begin 
    if (reset = '1') then 
        t := '0'; 
        y <= '0'; 
    elsif (rising_edge(clk)) then 
        t := a xor b; 
        y <= t; 
    end if; 
end process; 
end Behavioral_1;



architecture Behavioral_2 of Test_of_register_t is

begin 
    process (clk, reset) is 
        variable t : std_ulogic; 
begin 
    if (reset = '1') then 
        t := '0'; 
        y <= '0'; 
    elsif (rising_edge(clk)) then 
        y <= t; 
        t := a xor b; 
    end if; 
end process; 


end Behavioral_2;