
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

entity exponentiation_fsm_tb is
    generic (
        C_block_size : integer := 256
    );
end exponentiation_fsm_tb;

architecture exponentiation_fsm_tbBehave of exponentiation_fsm_tb is
    

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
    signal mult_ready_in        : std_logic  := '0';
    signal mult_valid_in        : std_logic  := '0';
    signal mult_ready_out       : std_logic  := '0';
    signal mult_valid_out       : std_logic  := '0';
    signal mult_reset_neg       : std_logic  := '0';

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


    constant clk_period        : time := 5 ns;

    -- state constants for readability
    constant LOAD_NEW_MSG     : std_logic_vector(1 downto 0) := "00";
    constant COUNT_WAIT       : std_logic_vector(1 downto 0) := "01";
    constant COUNT_FIN_PARTIAL: std_logic_vector(1 downto 0) := "10";
    constant FINISHED         : std_logic_vector(1 downto 0) := "11";

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
    DUT: entity work.exponentiation_fsm
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
            mult_ready_in        => mult_ready_in,
            mult_valid_in        => mult_valid_in,
            mult_ready_out       => mult_ready_out,
            mult_valid_out       => mult_valid_out,
            mult_reset_neg       => mult_reset_neg,

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

        -- Helper procedure to check outputs in each state
        procedure check_state_outputs(
            expected_state      : std_logic_vector(1 downto 0);
            expected_msgin_ready : std_logic;
            expected_msgout_valid: std_logic;
            expected_mult_valid_in: std_logic;
            expected_mult_ready_out: std_logic;
            expected_mult_reset_neg: std_logic
        ) is
        begin
            wait for clk_period/4; -- Wait for outputs to settle
            
            assert current_state = expected_state
                report "State check failed: expected " & integer'image(to_integer(unsigned(expected_state))) &
                       " got " & integer'image(to_integer(unsigned(current_state))) severity error;

            assert msgin_ready = expected_msgin_ready
                report "msgin_ready check failed in state " & integer'image(to_integer(unsigned(current_state))) severity error;

            assert msgout_valid = expected_msgout_valid
                report "msgout_valid check failed in state " & integer'image(to_integer(unsigned(current_state))) severity error;

            assert mult_valid_in = expected_mult_valid_in
                report "mult_valid_in check failed in state " & integer'image(to_integer(unsigned(current_state))) severity error;

            assert mult_ready_out = expected_mult_ready_out
                report "mult_ready_out check failed in state " & integer'image(to_integer(unsigned(current_state))) severity error;

            assert mult_reset_neg = expected_mult_reset_neg
                report "mult_reset_neg check failed in state " & integer'image(to_integer(unsigned(current_state))) severity error;
        end procedure;

    begin
        report "Starting RSA Core FSM Testbench" severity note;

        -- initialize inputs
        reset_n         <= '0';
        msgout_ready    <= '0';
        msgin_valid     <= '0';
        msgin_last      <= '0';
        mult_ready_in    <= '0';
        mult_valid_out   <= '0';
        n               <= std_logic_vector(to_unsigned(256, n'length));
        key_e_d_reg     <= std_logic_vector(to_unsigned(65537, key_e_d_reg'length));

        ----------------------------------------
        -- Test case 1: Reset Functionality
        ----------------------------------------
        report "TEST CASE 1: Reset Functionality" severity note;
        wait for clk_period * 2;

        -- Check that FSM is in LOAD_NEW_MSG state after reset
        assert current_state = LOAD_NEW_MSG
            report "FSM did not enter LOAD_NEW_MSG state after reset" severity error;
        assert unsigned(counter) = 0
            report "Counter not reset to 0 after reset" severity error;

        reset_n <= '1';
        wait for clk_period;

        report "TEST CASE 1 PASSED: Reset functionality verified" severity note;


        ----------------------------------------
        -- Test case 2: LOAD_NEW_MSG state behavior
        ----------------------------------------
        report "TEST CASE 2: LOAD_NEW_MSG state behavior" severity note;

        -- Check outputs in LOAD_NEW_MSG state
        check_state_outputs(
            LOAD_NEW_MSG,
            '1',  -- expected_msgin_ready
            '0',  -- expected_msgout_valid
            '0',  -- expected_mult_valid_in
            '0',  -- expected_mult_ready_out
            '0'   -- expected_mult_reset_neg
        );

        -- Test staying in LOAD_NEW_MSG state when msgin_valid = '0' or mult_ready_in = '0'
        msgin_valid  <= '0';
        mult_ready_in <= '0';
        wait for clk_period;
        assert current_state = LOAD_NEW_MSG
            report "TEST CASE 2 FAILED: FSM incorrectly left LOAD_NEW_MSG state when msgin_valid = '0' or mult_ready_in = '0'" severity error;


        msgin_valid  <= '1';
        mult_ready_in <= '0';
        wait for clk_period;
        assert current_state = LOAD_NEW_MSG
            report "TEST CASE 2 FAILED: FSM incorrectly left LOAD_NEW_MSG state when mult_ready_in = '0'" severity error;

        msgin_valid  <= '0';
        mult_ready_in <= '1';
        wait for clk_period;
        assert current_state = LOAD_NEW_MSG
            report "TEST CASE 2 FAILED: FSM incorrectly left LOAD_NEW_MSG state when msgin_valid = '0'" severity error;


        -- Test transition to COUNT_WAIT
        msgin_valid  <= '1';
        mult_ready_in <= '1';
        wait for clk_period;
        assert current_state = COUNT_WAIT
            report "TEST CASE 2 FAILED: FSM did not transition to COUNT_WAIT state when msgin_valid = '1' and mult_ready_in = '1'" severity error;


        report "TEST CASE 2 PASSED: LOAD_NEW_MSG state behavior verified" severity note;



        ----------------------------------------
        -- TEST CASE 3: COUNT_WAIT state behavior
        ----------------------------------------
        report "TEST CASE 3: COUNT_WAIT state behavior" severity note;

        -- Check outputs in COUNT_WAIT state
        check_state_outputs(
            COUNT_WAIT,
            '0',  -- expected_msgin_ready
            '0',  -- expected_msgout_valid
            '1',  -- expected_mult_valid_in
            '1',  -- expected_mult_ready_out
            '1'   -- expected_mult_reset_neg
        );

        -- Test staying in COUNT_WAIT state when mult_valid_out = '0'
        mult_valid_out <= '0';
        wait for clk_period;
        assert current_state = COUNT_WAIT
            report "TEST CASE 3 FAILED: FSM incorrectly left COUNT_WAIT state when mult_valid_out = '0'" severity error;
        
        -- Test transition to COUNT_FIN_PARTIAL
        mult_valid_out <= '1';
        wait for clk_period;
        assert current_state = COUNT_FIN_PARTIAL
            report "TEST CASE 3 FAILED: FSM did not transition to COUNT_FIN_PARTIAL state when mult_valid_out = '1'" severity error;

        report "TEST CASE 3 PASSED: COUNT_WAIT state behavior verified" severity note;

        ----------------------------------------
        -- TEST CASE 4: COUNT_FIN_PARTIAL state behavior
        ----------------------------------------
        report "TEST CASE 4: COUNT_FIN_PARTIAL state behavior" severity note;

        -- Check outputs in COUNT_FIN_PARTIAL state
        check_state_outputs(
            COUNT_FIN_PARTIAL,
            '0',  -- expected_msgin_ready
            '0',  -- expected_msgout_valid
            '0',  -- expected_mult_valid_in
            '1',  -- expected_mult_ready_out
            '1'   -- expected_mult_reset_neg
        );

        -- Test counter increment in COUNT_FIN_PARTIAL state
        wait for clk_period;
        assert unsigned(counter) = 1
            report "TEST CASE 4 FAILED: Counter did not increment in COUNT_FIN_PARTIAL state" severity error;
        

        -- Test staying in COUNT_FIN_PARTIAL state when counter < n and mult_ready_in = '0'
        mult_ready_in <= '0';
        wait for clk_period;
        assert current_state = COUNT_FIN_PARTIAL
            report "TEST CASE 4 FAILED: FSM incorrectly left COUNT_FIN_PARTIAL state when counter < n and mult_ready_in = '0'" severity error;
        
        assert unsigned(counter) = 1
            report "TEST CASE 4 FAILED: Counter incremented while staying in COUNT_FIN_STATE more than one cycle." severity error;


        mult_ready_in <= '1';
        report "TEST CASE 4 PASSED: COUNT_FIN_PARTIAL state behavior verified" severity note;

        ----------------------------------------
        -- TEST CASE 5: COUNT_FIN_PARTIAL loop to FINISHED state behavior
        ----------------------------------------
        report "TEST CASE 5: FINISHED state behavior" severity note;

        -- counter to n-1 to trigger transition to FINISHED state
        while unsigned(counter) < unsigned(n) loop

            -- COUNT_FIN_PARTIAL -> COUNT_WAIT
            mult_valid_out <= '0';
            wait for clk_period;
            assert current_state = COUNT_WAIT
                report "TEST CASE 5 FAILED: FSM did not transition back to COUNT_WAIT state from COUNT_FIN_PARTIAL when mult_valid_out = '0'" severity error;

            -- COUNT_WAIT -> COUNT_FIN_PARTIAL
            mult_valid_out <= '1';
            wait for clk_period;
            assert current_state = COUNT_FIN_PARTIAL
                report "TEST CASE 5 FAILED: FSM did not transition to COUNT_FIN_PARTIAL state from COUNT_WAIT when mult_valid_out = '1'" severity error;

            wait for clk_period; -- Increment counter
        end loop;


        wait for clk_period;
        assert current_state = FINISHED
            report "TEST CASE 5 FAILED: FSM did not transition to FINISHED state when counter = n" severity error;
        

        --------------------------------------------------------
        -- TEST CASE 6: FINISHED state behavior and reset
        --------------------------------------------------------
        report "TEST CASE 6: FINISHED state behavior and reset" severity note;

        -- Check outputs in FINISHED state
        check_state_outputs(
            FINISHED,
            '0',  -- expected_msgin_ready
            '1',  -- expected_msgout_valid
            '0',  -- expected_mult_valid_in
            '0',  -- expected_mult_ready_out
            '1'   -- expected_mult_reset_neg
        );

        -- Stay in FINISHED state when msgout_ready = '0'
        msgout_ready <= '0';
        wait for clk_period;
        assert current_state = FINISHED
            report "TEST CASE 6 FAILED: FSM incorrectly left FINISHED state when msgout_ready = '0'" severity error;
        
        -- Transition to LOAD_NEW_MSG when msgout_ready = '1'
        msgout_ready <= '1';
        wait for 3*clk_period/2;
        assert current_state = LOAD_NEW_MSG
            report "TEST CASE 6 FAILED: FSM did not transition to LOAD_NEW_MSG state when msgout_ready = '1'" severity error;

        wait for clok_period/2;

        --- Check that counter is reset to 0
        assert unsigned(counter) = 0
            report "TEST CASE 6 FAILED: Counter not reset to 0 after transitioning to LOAD_NEW_MSG state" severity error;       

        report "TEST CASE 6 PASSED: FINISHED state behavior and reset verified" severity note;


        wait;
    end process;

end exponentiation_fsm_tbBehave;