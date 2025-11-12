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

	signal exp_valid_out      : std_logic;
	signal exp_ready_in       : std_logic;
	signal exp_valid_in       : std_logic;
	signal exp_ready_out      : std_logic;
	signal exp_reset_neg      : std_logic;

	signal exp_R_next         : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
	signal exp_P_next         : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
	signal exp_e_d            : std_logic;				-- exponent bit (LSB first)

	---- can be deleted when testing is done ----
	signal exp_counter			: std_logic_vector(C_BLOCK_SIZE-1 downto 0);
	signal exp_current_state	: std_logic_vector(1 downto 0);					-- RESET = 00, COUNTING = 01, FINISHED = 10, unused 11

		-- Intermediate and result of R and P. R is to be treated as the resulting ciphertext.
	signal result_P          : std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');

	-- Registers for storing input signals
	signal key_e_d_reg      : std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');
	signal key_n_reg        : std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');
	signal n_neg_reg        : std_logic_vector(C_BLOCK_SIZE downto 0);
	signal msgin_last_reg   : std_logic := '0';

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
            result_R        => result_R,
            result_P        => result_P,

            key_e_d_reg     => key_e_d_reg,
            key_n_reg       => key_n_reg,
            n_neg_reg       => n_neg_reg,
            msgin_last_reg  => msgin_last_reg,
            exp_valid_out      => exp_valid_out,
            exp_ready_in       => exp_ready_in,
            exp_valid_in       => exp_valid_in,
            exp_ready_out      => exp_ready_out,
            exp_reset_neg      => exp_reset_neg,
            exp_R_next         => exp_R_next,
            exp_P_next         => exp_P_next,
            exp_e_d            => exp_e_d,
            exp_counter        => exp_counter,
            exp_current_state  => exp_current_state 
        );

    
    
    --------------------------------------------------
    -- Main test process
    --------------------------------------------------
    test_process: process

            -- helper function to test outputs correctness
        procedure check_outputs(
            expected_state  : std_logic_vector(1 downto 0);
            expected_msgin_ready : std_logic;
            expected_msgout_valid : std_logic;
            expected_exp_valid_in  : std_logic;
            expected_exp_ready_out  : std_logic;
            expected_exp_reset_neg   : std_logic
        ) is
        begin 
            if current_state /= expected_state then
                report "TEST " & integer'image(test_case_num) & " FAILED: Incorrect current_state" severity error;
            end if;

            if msgin_ready /= expected_msgin_ready then
                report "TEST " & integer'image(test_case_num) & " FAILED: Incorrect msgin_ready" severity error;
            end if;

            if msgout_valid /= expected_msgout_valid then
                report "TEST " & integer'image(test_case_num) & " FAILED: Incorrect msgout_valid" severity error;
            end if;

            if exp_valid_in = expected_exp_valid_in then
                report "TEST " & integer'image(test_case_num) & " FAILED: Incorrect exp_valid_in" severity error;
            end if;

            if exp_ready_out /= expected_exp_ready_out then
                report "TEST " & integer'image(test_case_num) & " FAILED: Incorrect exp_ready_out" severity error;
            end if;

            if exp_reset_neg /= expected_exp_reset_neg then
                report "TEST " & integer'image(test_case_num) & " FAILED: Incorrect exp_reset_neg" severity error;
            end if;

        end procedure check_outputs;

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
        
        wait for clk_period;
        
        -- Check reset state
        check_outputs(
            expected_state       => LOAD_NEW_MSG,
            expected_msgin_ready => '1',
            expected_msgout_valid => '0',
            expected_exp_valid_in  => '0',
            expected_exp_ready_out  => '0',
            expected_exp_reset_neg   => '0'
        );

        reset_neg <= '1';
        wait for clk_period;
        report "TEST CASE 1: PASSED" severity note;
        report "----------------------------------------" severity note;


        -----------------------------------------------
        -- TEST CASE 2: Load values and start simple RSA operation
        -----------------------------------------------
        test_case_num <= 2;
        report "TEST CASE 2: Load values and start simple RSA operation" severity note;

        msgin_data <= x"00000000000000000000000000000000000000000000000000000000000001ff"; -- msgin_data 
        key_e_d    <= x"0100000000000000000000000000000000000000000000000000000000000101"; -- key_e_d = 3, 256 bit
        key_n      <= x"0000000000000000000000000000000000000000000000000000000000000100"; -- key_n = 256, 256 bit

        msgin_valid <= '1';
        msgin_last  <= '1';

        wait for clk_period;

        check_outputs(
            expected_state       => COUNT_WAIT,
            expected_msgin_ready => '0',
            expected_msgout_valid => '0',
            expected_exp_valid_in  => '1',
            expected_exp_ready_out  => '1',
            expected_exp_reset_neg   => '1'
        );
        report "TEST CASE 2: PASSED" severity note;

        msgin_valid <= '0';

        --------------------------------------------------------------
        -- TEST CASE 3: Wait for operation to complete and check outputs
        --------------------------------------------------------------
        test_case_num <= 3;

        report "TEST CASE 3: Wait for operation to complete and check outputs" severity note;

        wait for clk_period * 256;  -- wait enough time for operation to complete

        check_outputs(
            expected_state       => COUNT_FIN_PARTIAL,
            expected_msgin_ready => '0',
            expected_msgout_valid => '1',
            expected_exp_valid_in  => '0',
            expected_exp_ready_out  => '0',
            expected_exp_reset_neg   => '1'
        );

        report "TEST CASE 3: PASSED" severity note;



        wait;
    end process test_process;
end Behavioral;
