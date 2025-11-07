----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2025 16:56:07
-- Design Name: 
-- Module Name: calculations_tb - calc_tbBehave
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

entity calculations_tb is
    generic (
		C_block_size : integer := 256
	);
end calculations_tb;

architecture calc_tbBehave of calculations_tb is
    signal 
            clk 
        : std_logic;

    signal
            current_state_global : std_logic_vector(1 downto 0);
    signal  
            b, 
            R_new,
            R_reg
        : std_logic_vector(C_block_size-1 downto 0) := (others => '0');
    signal  
            b_minus_n, 
            b_minus_2n, 
            n_neg, 
            s0, 
            s1, 
            s2, 
            s3, 
            s4, 
            s5 
        : std_logic_vector (C_block_size downto 0) := (others => '0');

    constant 
            clk_period 
        : time := 5 ns;

    function is_all_zero(vec: std_logic_vector) return boolean is 
    begin   
        for i in vec'range loop
            if vec(i) = '1' then
                return false;
            end if;
        end loop;
        return true;
    end function is_all_zero;

begin

DUT : entity work.calculations  
    generic map ( 
        C_block_size => C_block_size
    )
    port map (
        b               => b,
        n_neg           => n_neg,
        clk             => clk,
        R_new           => R_new,
        s0              => s0,
        s1              => s1,
        s2              => s2,
        s3              => s3,
        s4              => s4,
        s5              => s5,
        current_state_global => current_state_global,
        b_minus_n     => b_minus_n,
        b_minus_2n    => b_minus_2n,
        R_reg         => R_reg
    );
    
    
clk_process : process 
begin 
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;
end process;


test_process : process 
begin
    R_new               <= (others => '0');
    R_new(5)            <= '1';   -- Set R_new to 32 for testing
        
    b                   <= (others => '0');
    b(4)                <= '1';   -- Set b to 16 for testing

    n_neg               <= (others => '1');
    n_neg(7 downto 0)   <= "00000000"; -- Set n_neg to -255 for testing

    current_state_global <= "00"; -- RESET state
    wait for clk_period; 
    
    current_state_global <= "01"; -- COUNTING state
    wait for clk_period * 5;

    current_state_global <= "10"; -- FINISHED state

    wait for clk_period;
    R_new <= (others => '0');
    R_new(6) <= '1';   -- Set R_new to 64 for testing

    wait for clk_period * 5;
    current_state_global <= "00"; -- RESET state
    wait for clk_period;
    current_state_global <= "01"; -- COUNTING state
    wait for clk_period * 5;

    current_state_global <= "10"; -- FINISHED state


    report "---- Test completed ----" severity note;
    wait;

end process;

end calc_tbBehave;
