----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/15/2025 05:33:16 PM
-- Design Name: 
-- Module Name: mux_6to1_tb - Behavioral
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

entity mux_6to1_tb is
end mux_6to1_tb;

architecture Behavioral_mux_6to1_tb of mux_6to1_tb is
        signal s0, s1 ,s2 ,s3 ,s4, s5, R_new: std_logic_vector( 256 downto 0);
        signal mux_control, clk : std_logic;
        constant clk_period : time := 10 ns;       

begin

the_clock : process
begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process  the_clock;
    
s0
s1 ,s2 ,s3 ,s4, s5

end Behavioral_mux_6to1_tb;
