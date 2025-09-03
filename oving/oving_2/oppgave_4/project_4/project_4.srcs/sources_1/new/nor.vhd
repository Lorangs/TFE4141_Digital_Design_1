----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2025 04:28:29 PM
-- Design Name: 
-- Module Name: logic - Behavioral
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

entity logic is
    Port ( A : in STD_ULOGIC;
           B : in STD_ULOGIC;
           Q : buffer STD_ULOGIC;
           QN : buffer STD_ULOGIC);
end logic;

architecture behaviour of logic is
begin
  Q <= A nor QN;
  QN <=  B nor Q;   
end behaviour;
