----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.10.2025 15:55:38
-- Design Name: 
-- Module Name: rsa_core_fsm_tb - rsa_core_fsm_tbBehave
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

entity rsa_core_fsm_tb is
    generic (
        C_block_size : integer := 256
    );
end rsa_core_fsm_tb;

architecture rsa_core_fsm_tbBehave of rsa_core_fsm_tb is
    signal msgin_last, msgin_ready, msgin_valid, msgout_last, msgout_ready, msgout_valid, rsa_status : std_logic;
    signal clk, reset_n, valid_out, valid_in, ready_out, ready_in : std_logic;
    signal new_msg_neg : std_logic;
    signal count : std_logic_vector(C_block_size-1 downto 0);
    constant clk_period : time := 5 ns;

begin

DUT: entity work.rsa_core_fsm 
    generic map (
        C_block_size => C_block_size
    )
    port map (
        clk             => clk,
        reset_n         => reset_n,
        msgin_valid     => msgin_valid,
        msgin_last      => msgin_last,
        msgout_ready    => msgout_ready,
        msgin_ready     => msgin_ready,
        msgout_valid    => msgout_valid,
        msgout_last     => msgout_last,
        rsa_status      => rsa_status,

        valid_out       => valid_out,
        ready_in        => ready_in,
        valid_in        => valid_in,
        ready_out       => ready_out,
        new_msg_neg     => new_msg_neg,
        
        count           => count
    );

    clk_process : process 
    begin 
        clk <= '1';
        wait for clk_period / 2;
        clk <= '0';
        wait for clk_period / 2;
    end process;

    test_process: process 
    begin
       reset_n      <= '0';
       msgin_valid  <= '1';
       msgout_ready <= '0';
       valid_out    <= '0';
       
       
       wait for clk_period;

       assert msgin_ready = '1' report "msgin_ready not 1 when ready for new message" severity error;

       
       reset_n  <= '1';
       ready_in <= '1';
       
       wait for clk_period*2;

       assert valid_in = '1' report "valid_in not 1 when in count_wait state" severity error;
       assert ready_out = '1' report "ready_out is not 1 when waiting for output of exponentiation" severity error;
       
       valid_out    <= '1';
       ready_in     <= '1';
       
       wait for clk_period*10;
    

       report "---- Test complete ----" severity note;
       wait;
       
    end process;
end rsa_core_fsm_tbBehave;
