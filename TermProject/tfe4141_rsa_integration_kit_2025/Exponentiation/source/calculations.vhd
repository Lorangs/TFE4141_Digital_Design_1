----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2025 15:27:47
-- Design Name: 
-- Module Name: calculations - calcBehave
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity calculations is
    generic (
		C_block_size : integer := 256
	);
    Port ( 
           b       : in     std_logic_vector( C_block_size downto 0 );
           n_neg   : in     std_logic_vector( C_block_size downto 0 );
           
           clk     : in     std_logic;
           reset_n : in     std_logic;
           
           R_new   : in     std_logic_vector( C_block_size downto 0 );
           
           s0      : out    std_logic_vector( C_block_size downto 0 );
           s1      : out    std_logic_vector( C_block_size downto 0 );
           s2      : inout  std_logic_vector( C_block_size downto 0 );
           s3      : out    std_logic_vector( C_block_size downto 0 );
           s4      : inout  std_logic_vector( C_block_size downto 0 );
           s5      : out     std_logic_vector( C_block_size downto 0 )
          );
end calculations;

architecture calcBehave of calculations is
    signal R_temp, mux, b_n, b_2n, n_2 : std_logic_vector( C_block_size downto 0 );
begin

-- R_reg register
process (clk, reset_n) 
begin
    if (reset_n = '0') then 
        R_temp <= (others => '0');
    else 
        R_temp <= std_logic_vector(shift_left(signed(R_new), 1));
    end if;
end process;


-- b-n register
process (clk, reset_n) 
begin
    if (reset_n = '0') then
        b_n <= s2;
    else 
        b_n <= b_n;
    end if;
end process;

-- b-2n register
process (clk, reset_n)
begin 
    if (reset_n = '0') then
        b_2n <= s4;
    else
        b_2n <= b_2n;     
    end if;
end process; 


-- Mux 
mux <= b when reset_n = '0' else R_temp;


s0 <= R_temp;
s1 <= std_logic_vector(signed(R_temp) + signed(b));
s2 <= std_logic_vector(signed(mux) + signed(n_neg)); 
s3 <= std_logic_vector(signed(R_temp) + signed(b_n));
s4 <= std_logic_vector(signed(mux) + shift_left(signed(n_neg), 1));
s5 <= std_logic_vector(signed(R_temp) + signed(b_2n));


end calcBehave;
