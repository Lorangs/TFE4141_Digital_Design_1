----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2025 15:27:47
-- Design Name: 
-- Module Name: mux_6to1 - muxBehave
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

entity mux_6to1 is
    generic(
        C_block_size : integer:= 256
    );
    Port (
           s0          : in std_logic_vector( C_block_size downto 0);
           s1          : in std_logic_vector( C_block_size downto 0);
           s2          : in std_logic_vector( C_block_size downto 0);
           s3          : in std_logic_vector( C_block_size downto 0);
           s4          : in std_logic_vector( C_block_size downto 0);
           s5          : in std_logic_vector( C_block_size downto 0);

           R_new       : out std_logic_vector( C_block_size downto 0);
           mux_control : in std_logic;

           -- internal signals
            signal Muxed_s0_s2       : std_logic_vector(C_block_size downto 0);
            signal Muxed_s0_s2_s4    : std_logic_vector(C_block_size downto 0);
            signal Muxed_s1_s3       : std_logic_vector(C_block_size downto 0);
            signal Muxed_s1_s3_s5    : std_logic_vector(C_block_size downto 0);
           );
end mux_6to1;

architecture muxBehave of mux_6to1 is

begin

-- first mux for normal series, R or R-N
Mux_nr_1: process(s0 , s2 ,s2(256)) 
begin 
    case s2(256) is 
        when '0' => 
            Muxed_s0_s2 <= s2;
        when '1' => 
           Muxed_s0_s2 <= s0;
        when others =>
            Muxed_s0_s2 <= (others => '0');  
    end case;
end process Mux_nr_1;

-- Second mux for normal series R-2n or others
Mux_nr_2: process(Muxed_s0_s2, s4, s4(256))
begin 
    case s4(256) is 
        when '0' => 
            Muxed_s0_s2_s4 <= Muxed_s0_s2;
        when '1' => 
            Muxed_s0_s2_s4 <= s4;
        when others =>
            Muxed_s0_s2_s4 <= (others => '0'); 
    end case;
end process Mux_nr_2;

-- Deciding between R+B or R+B-N. First mux for B series 
Mux_nr_3_B: process(s1 , s3 ,s3(256)) -- s3(256)
begin 
    case s5(256) is 
        when '0' => 
            Muxed_s1_s3 <= s1;
        when '1' => 
           Muxed_s1_s3 <= s3;
        when others =>
            Muxed_s1_s3 <= (others => '0');  
    end case;
end process Mux_nr_3_B;

-- deciding if R+B-2n, or other last mux for B serien. 
Mux_nr_4_B: process(Muxed_s1_s3 , s5 ,s5(256)) -- s5(256)
begin 
    case s5(256) is 
        when '0' => 
            Muxed_s1_s3_s5 <= Muxed_s1_s3;
        when '1' => 
            Muxed_s1_s3_s5 <= s5;
        when others =>
            Muxed_s1_s3_s5 <= (others => '0'); 
    end case;
end process Mux_nr_4_B;

-- Last_temp s0||s1||s2 Muxed_s0_s2_s4
-- Last_temp_with_B s1||s3||s5 Muxed_s1_s3_s5
Last_Mux: process(Muxed_s0_s2_s4, Muxed_s1_s3_s5, mux_control)
begin 
    case mux_control is
        when '0' => 
            R_new <= Muxed_s1_s3_s5;
        when '1' => 
            R_new <= Muxed_s0_s2_s4;
        when others =>
            R_new <= (others => '0'); 
    end case;
end process Last_Mux;
        --when others

end muxBehave;
