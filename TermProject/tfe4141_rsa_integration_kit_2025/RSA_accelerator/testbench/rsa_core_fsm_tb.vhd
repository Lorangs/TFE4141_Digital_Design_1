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
use IEEE.Numeric_STD.all;

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
    

    -- External Interface Signals
    signal clk                 : std_logic  := '0';
    signal reset_n             : std_logic  := '0';

    -- handshaking signals with external module.
    signal msgout_ready        : std_logic  := '0';
    signal msgout_valid        : std_logic  := '0';
    signal msgin_ready         : std_logic  := '0';
    signal msgin_valid         : std_logic  := '0';
    signal msgin_last          : std_logic  := '0';

begin

    ---------------------------
    -- Clock generation
    ---------------------------
    clk_process :process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process clk_process;

    ------------------------------
    -- DUT instantiation
    ------------------------------
    DUT: entity work.rsa_core_fsm
        generic map (
            C_BLOCK_SIZE => C_block_size
        )
        port map (
            -- External Interface Signals
            clk                 => clk,
            reset_n             => reset_n,

            -- handshaking signals with external module.
            msgout_ready        => msgout_ready,
            msgout_valid        => msgout_valid,
            msgin_ready         => msgin_ready,
            msgin_valid         => msgin_valid,
            msgin_last          => msgin_last,

            -- handshaking signals with exponentiation module.
            exp_ready_in        => exp_ready_in,
            exp_valid_in        => exp_valid_in,
            exp_ready_out       => exp_ready_out,
            exp_valid_out       => exp_valid_out,
            exp_reset_neg       => exp_reset_neg,

            -- RSA status signal
            rsa_status          => rsa_status,

            -- modulus 
            n                   => n,  

            -- exponent bits
            key_e_d_reg         => key_e_d_reg,
            key_e_d_LSB         => key_e_d_LSB,     
            
            current_state       => current_state,

            -- internal signals for testing
            counter             => counter
        );

end rsa_core_fsm_tbBehave;