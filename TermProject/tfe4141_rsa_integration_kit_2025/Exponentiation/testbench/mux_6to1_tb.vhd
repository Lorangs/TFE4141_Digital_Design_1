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
    generic(
		C_block_size : integer := 256 -- betyr dette det er ikke nullindiksert?
    );
end mux_6to1_tb;

architecture Behavioral_mux_6to1_tb of mux_6to1_tb is
        signal s0, s1 ,s2 ,s3 ,s4, s5, R_new: std_logic_vector(C_block_size downto 0);
        signal mux_control, clk : std_logic;
        constant clk_period : time := 5 ns; -- 10ns about 100Mhz 200Mhz 5ns     
begin

the_clock : process
begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process  the_clock;

DUT : entity work.mux_6to1  
    generic map ( 
        C_block_size => C_block_size
    )
    port map (
        s0 => s0,
        s1 => s1,
        s2 => s2,
        s3 => s3,
        s4 => s4,
        s5 => s5,
        R_new => R_new,
        mux_control => mux_control
    );

test_process_mux6to1 : process
begin

    -- first test check for when we have the situastion
    -- a  = 1
    -- b  = 3
    -- s0 = R        = 3
    -- s1 = R + b    = 6
    -- s2 = R - n    = -4
    -- s3 = R+b-n    = -1
    -- s4 = R+b-2n   = -8
    -- s5 = R+b-2n   = -8
    -- mux_control = 0

    -- s0 = 8;
    s0       <= (others => '0');
    s0(0)   <= '1';
    s0(1)   <= '1';
    -- s1 = 6
    s1      <= (others => '0');
    s1(1)   <= '1';
    s1(2)   <= '1';
    s2      <= (others => '0');
    s2(256) <= '1';
    s2(2)   <= '1';
    s3      <= (others => '0');
    s3(256) <= '1';
    s3(0)   <= '1';
    s4      <= (others => '0');
    s4(256) <= '1';
    s4(3)    <= '1';
    s5      <= (others => '0');
    s5(256) <= '1';
    s5(3)   <= '1';
    mux_control <= '1';
   
    wait for clk_period; 
    
    
       -- Second same as first test except muxcontrol = 1
    -- a  = 1
    -- b  = 3
    -- s0 = R        = 3
    -- s1 = R + b    = 6
    -- s2 = R - n    = -4
    -- s3 = R+b-n    = -1
    -- s4 = R+b-2n   = -8
    -- s5 = R+b-2n   = -8
    -- mux_control = 1

    -- s0 = 8;
    s0       <= (others => '0');
    s0(0)   <= '1';
    s0(1)   <= '1';
    -- s1 = 6
    s1      <= (others => '0');
    s1(1)   <= '1';
    s1(2)   <= '1';
    s2      <= (others => '0');
    s2(256) <= '1';
    s2(2)   <= '1';
    s3      <= (others => '0');
    s3(256) <= '1';
    s3(0)   <= '1';
    s4      <= (others => '0');
    s4(256) <= '1';
    s4(3)    <= '1';
    s5      <= (others => '0');
    s5(256) <= '1';
    s5(3)   <= '1';
    mux_control <= '0';
    

    wait for clk_period; 
    
end process;

end Behavioral_mux_6to1_tb;



    --s1 <= std_logic_vector(to_signed(6, C_block_size + 1));
    --s2 <= std_logic_vector(to_signed(-4, C_block_size + 1));
    --s3 <= std_logic_vector(to_signed(-1, C_block_size + 1));
    --s4 <= std_logic_vector(to_signed(-8, C_block_size + 1));
    --s5 <= std_logic_vector(to_signed(-8, C_block_size + 1));