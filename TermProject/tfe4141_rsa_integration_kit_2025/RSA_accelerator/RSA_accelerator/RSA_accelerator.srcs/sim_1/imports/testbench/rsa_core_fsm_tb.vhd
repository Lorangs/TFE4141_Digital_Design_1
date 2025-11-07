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
use IEEE.numeric_std.all;

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

    -- handshaking signals with exponentiation module.
    signal exp_ready_in        : std_logic  := '0';
    signal exp_valid_in        : std_logic  := '0';
    signal exp_ready_out       : std_logic  := '0';
    signal exp_valid_out       : std_logic  := '0';
    signal exp_reset_neg       : std_logic  := '0';

    -- RSA status signal
    signal rsa_status          : std_logic_vector(31 downto 0);

    -- modulus 
    signal n                   : std_logic_vector(C_block_size-1 downto 0);  

    -- exponent bits
    signal key_e_d_reg         : std_logic_vector(C_block_size-1 downto 0);
    signal key_e_d_LSB         : std_logic;     
        
    signal current_state       : std_logic_vector(1 downto 0);

        -- internal signals for testing
    signal counter             : std_logic_vector(C_block_size-1 downto 0 );


    constant clk_period 
        : time := 5 ns;

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




    --------------------------------------------------
    -- Test procedure and stimulus process here
    --------------------------------------------------
    test_process : process
    begin
        -- Reset the DUT
        reset_n <= '0';
        wait for clk_period * 2;
        reset_n <= '1';
        wait for clk_period * 2;

        -- Set inputs
        n			<= std_logic_vector(to_unsigned(256, n'length)); -- n = 256
        key_e_d_reg	<= std_logic_vector(to_unsigned(65537, key_e_d_reg'length)); -- e = 65537
    
        msgin_valid     <= '1';
        exp_ready_in    <= '1';
        exp_valid_out   <= '0';

        -- Wait for some time to observe behavior
        wait for clk_period * 300;


    end process;

end rsa_core_fsm_tbBehave;