----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2025 10:07:22 AM
-- Design Name: 
-- Module Name: rsa_core_tb - Behavioral
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
use IEEE.math_real.ALL;


entity rsa_core_tb is
    generic (
        C_BLOCK_SIZE : integer := 256
    );
end rsa_core_tb;

architecture Behavioral of rsa_core_tb is

    -- Clock and reset
    signal clk                 : std_logic := '0';
    signal reset_neg             : std_logic := '0';

    -- Slave msgin interface
    signal msgin_valid         : std_logic := '0';
    signal msgin_ready         : std_logic;
    signal msgin_data          : std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');
    signal msgin_data_reg      : std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');
    signal result_R         : std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');
    signal msgin_last          : std_logic := '0';

    -- Master msgout interface
    signal msgout_valid        : std_logic;
    signal msgout_ready        : std_logic := '0';
    signal msgout_data         : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
    signal msgout_last         : std_logic;

    -- Interface to register block
    signal key_e_d             : std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');
    signal key_n               : std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');
    signal rsa_status          : std_logic_vector(31 downto 0);

    -- Internal signals for testing
    signal counter             : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
    signal current_state       : std_logic_vector(1 downto 0);

    -- Constants
    constant clk_period        : time := 5 ns;
    signal test_running        : boolean := true;
    signal test_case_num       : integer := 0;

    -- FSM States
    constant LOAD_NEW_MSG    : std_logic_vector(1 downto 0)     := "00";
    constant COUNT_WAIT      : std_logic_vector(1 downto 0)     := "01";
    constant COUNT_FIN_PARTIAL : std_logic_vector(1 downto 0)   := "10";
    constant FINISHED        : std_logic_vector(1 downto 0)     := "11";

    -- Test vectors
    type test_vector is record
        name        : string(1 to 20);
        message     : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
        exponent    : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
        modulus     : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
        expected    : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
    end record;
begin
    ---------------------------
    -- Clock generation
    ---------------------------
    clk_process : process
    begin
        while test_running loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process clk_process;


    ------------------------------
    -- DUT instantiation
    ------------------------------
    DUT: entity work.rsa_core
        generic map (
            C_BLOCK_SIZE => C_BLOCK_SIZE
        )
        port map (
            -- Clock and reset
            clk             => clk,
            reset_neg         => reset_neg,

            -- Slave msgin interface
            msgin_valid     => msgin_valid,
            msgin_ready     => msgin_ready,
            msgin_data      => msgin_data,
            msgin_last      => msgin_last,

            -- Master msgout interface
            msgout_valid    => msgout_valid,
            msgout_ready    => msgout_ready,
            msgout_data     => msgout_data,
            msgout_last     => msgout_last,

            -- Register interface
            key_e_d         => key_e_d,
            key_n           => key_n,
            rsa_status      => rsa_status,

            -- Internal signals for testing
            counter         => counter,
            current_state   => current_state,

            msgin_data_reg  => msgin_data_reg,
            result_R        => result_R
        );

    
    
    --------------------------------------------------
    -- Main test process
    --------------------------------------------------
    test_process : process

        -- Helper procedure to wait for specific state
        procedure wait_for_state(expected_state : std_logic_vector(1 downto 0)) is
            variable timeout_counter : integer := 0;
        begin
            while current_state /= expected_state and timeout_counter < 100000 loop
                wait for clk_period;
                timeout_counter := timeout_counter + 1;
            end loop;

            if timeout_counter >= 100000 then
                report "TIMEOUT: Expected state " & integer'image(to_integer(unsigned(expected_state))) &
                       " but got " & integer'image(to_integer(unsigned(current_state))) severity error;
            end if;
        end procedure;

    
    -- Helper procedure to send message
    procedure send_message(
        msg : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
        last : std_logic := '1'
    ) is
    begin
        -- Wait for ready
        while msgin_ready = '0' loop
            wait for clk_period;
        end loop;
        
        -- Send message
        msgin_data <= msg;
        msgin_last <= last;
        msgin_valid <= '1';
        wait for clk_period;
        msgin_valid <= '0';
        msgin_data <= (others => '0');
        msgin_last <= '0';
    end procedure;

    -- Helper procedure to receive message
    procedure receive_message is
    begin
        -- Wait for valid output
        while msgout_valid = '0' loop
            wait for clk_period;
        end loop;
        
        -- Accept message
        msgout_ready <= '1';
        wait for clk_period;
        msgout_ready <= '0';
    end procedure;

    
    -- Helper procedure to perform complete RSA operation
    procedure perform_rsa_operation(
        msg : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
        exp : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
        mod_n : std_logic_vector(C_BLOCK_SIZE-1 downto 0)
        ) is
    begin
        -- Set keys
        key_e_d <= exp;
        key_n <= mod_n;
        wait for clk_period;

        -- Send message
        send_message(msg, '1');
        
    end procedure;

begin 
        report "****************************************" severity note;
        report "Starting RSA Core Testbench" severity note;
        report "****************************************" severity note;

            
        -- Initialize signals
        reset_neg    <= '0';
        msgin_valid  <= '0';
        msgin_data   <= (others => '0');
        msgin_last   <= '0';
        msgout_ready <= '0';
        key_e_d      <= (others => '0');
        key_n        <= (others => '0');

        -------------------------------------------------
        -- TEST CASE 1: Reset functionality
        -----------------------------------------------
        test_case_num <= 1;
        report "TEST CASE 1: Reset functionality" severity note;
        
        wait for clk_period * 3;
        
        -- Check reset state
        assert current_state = LOAD_NEW_MSG
            report "TEST 1 FAILED: Not in LOAD_NEW_MSG after reset" severity error;
        assert unsigned(counter) = 0
            report "TEST 1 FAILED: Counter not zero after reset" severity error;
        
        reset_neg <= '1';
        wait for clk_period * 2;
        report "TEST CASE 1: PASSED" severity note;
        report "----------------------------------------" severity note;


        -----------------------------------------------
        -- TEST CASE 2: Simple RSA operation (small values)
        -----------------------------------------------
        test_case_num <= 2;
        report "TEST CASE 2: Simple RSA operation (2^3 mod 5)" severity note;
        
        -- Test: 2^3 mod 256 = 8
        perform_rsa_operation(
            std_logic_vector(to_unsigned(2, C_BLOCK_SIZE)),    -- message = 2
            std_logic_vector(to_unsigned(3, C_BLOCK_SIZE)),    -- exponent = 3
            std_logic_vector(to_unsigned(256, C_BLOCK_SIZE))   -- modulus = 256                         
        );

        while msgout_valid = '0' loop
            wait for clk_period;
        end loop;

        if current_state /= FINISHED then
            report "TEST 2 FAILED: Not in FINISHED after operation" severity error;
        end if;
        
        if unsigned(msgout_data) = 8 then
            report "TEST CASE 2: PASSED - Result = 8" severity note;
        else
            report "TEST CASE 2: FAILED - Expected 8, got " & integer'image(to_integer(unsigned(msgout_data))) severity error;
        end if;

        msgout_ready <= '1';
        wait for clk_period;
        msgout_ready <= '0';

        if current_state /= LOAD_NEW_MSG then
            report "TEST 2 FAILED: Not in LOAD_NEW_MSG after operation" severity error;
        end if;

        report "----------------------------------------" severity note;

    
        -----------------------------------------------
        -- TEST CASE 3: Identity operation (M^1 mod N = M)
        -----------------------------------------------
        test_case_num <= 3;
        report "TEST CASE 3: Identity operation (M^1 mod N = M)" severity note;
        
        perform_rsa_operation(
            std_logic_vector(to_unsigned(42, C_BLOCK_SIZE)),   -- message = 42
            std_logic_vector(to_unsigned(1, C_BLOCK_SIZE)),    -- exponent = 1
            std_logic_vector(to_unsigned(256, C_BLOCK_SIZE))  -- modulus = 256r
        ); 
        
        receive_message;

        if unsigned(msgout_data) = 42 then
            report "TEST CASE 3: PASSED - Result = 42" severity note;
        else
            report "TEST CASE 3: FAILED - Expected 42, got " & integer'image(to_integer(unsigned(msgout_data    ))) severity error;
        end if;

        report "All test cases completed." severity note;
        test_running <= false;
        wait;
    end process test_process;
end Behavioral;
