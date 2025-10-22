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
    signal n : std_logic_vector(C_block_size downto 0); 
    signal clk, reset_n, valid_out, ready_out, load_result : std_logic;
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
        valid_out       => valid_out,
        ready_out       => ready_out,
        load_result
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
    reset_n     <= '0';
    ready_out   <= '0';
    
    -- setting n = 8
    n       <= (others => '0'); 
    n(3)    <= '1'; 
    
    wait for clk_period;
    
    assert load_result = '0' report "load_result = 1 after reset" severity error;
    
    reset_n         <= '1';
    
    wait for clk_period*8; -- after a total of 9 cycles 
    
    assert valid_out = '1' report "valid_out not 1 after n+1 cycles" severity error;
    
    ready_out <= '1';
    
    wait for clk_period*3;
    
    report "----- Test done ----" severity note; 
    
    wait;
end process;
    
 
end expFsm_tbBehave;
