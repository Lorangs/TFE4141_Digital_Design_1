----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.10.2025 14:37:15
-- Design Name: 
-- Module Name: exponentiation_fsm_tb - expFsm_tbBehave
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

entity exponentiation_fsm_tb is
generic (
		C_block_size : integer := 256
	);
end exponentiation_fsm_tb;

architecture expFsm_tbBehave of exponentiation_fsm_tb is
    signal n : std_logic_vector(C_block_size-1 downto 0); 
    signal clk, reset_n, valid_out, valid_in, ready_out, ready_in, load_result : std_logic;
    constant clk_period : time := 5 ns;
    
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

DUT: entity work.exponentiation_fsm
    generic map (
            C_block_size => C_block_size
        )
    port map (
        reset_n         => reset_n,
        clk             => clk,
        n               => n,
        
        ready_out       => ready_out,
        valid_in        => valid_in,
        
        ready_in        => ready_in,
        valid_out       => valid_out,
        load_result     => load_result
    );
    
clk_process : process 
begin 
    clk <= '1';
    wait for clk_period / 2;
    clk <= '0';
    wait for clk_period / 2;
end process;

test_process : process 
begin
    reset_n     <= '0';
    ready_out   <= '0';
    valid_in    <= '0';
    
    -- setting n = 8
    n       <= (others => '0'); 
    n(3)    <= '1'; 
    
    wait for clk_period;
    
    assert valid_out = '0' report "valid_out is not reset when in reset state" severity error;
    assert ready_in = '1' report "ready_in is not 1 when in reset state" severity error;
    assert load_result = '0' report "load_result is not 0 when in reset state" severity error;
    
    reset_n     <= '1';
    valid_in    <= '1';
    ready_out   <= '1';
    
    wait for clk_period*10;
    
    report "----- Test done ----" severity note; 
    
    wait;
end process;
    
 
end expFsm_tbBehave;
