library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ALL;


entity exponentiation_tb is
    generic (
        C_BLOCK_SIZE : INTEGER := 256
    );
end exponentiation_tb;

architecture Behavioral of exponentiation_tb is

    -- Clock and reset
    signal clk                 	: STD_LOGIC := '0';
    signal reset_neg            : STD_LOGIC := '0';

    -- Slave msgin interface
    signal msgin_valid         	: STD_LOGIC := '0';
    signal msgin_ready         	: STD_LOGIC;
    signal msgin_data          	: STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0) := (others => '0');
    signal msgin_data_reg      	: STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0) := (others => '0');
    signal result_R        		: STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0) := (others => '0');
    signal msgin_last          	: STD_LOGIC := '0';

    -- Master msgout interface
    signal msgout_valid        	: STD_LOGIC;
    signal msgout_ready        	: STD_LOGIC := '0';
    signal msgout_data         	: STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0);
    signal msgout_last         	: STD_LOGIC;

    -- Interface to register block
    signal key_e_d             	: STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0) := (others => '0');
    signal key_n               	: STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0) := (others => '0');
    signal rsa_status          	: STD_LOGIC_VECTOR(31 downto 0);

    -- Internal signals for testing
    signal counter             	: INTEGER;
    signal current_state       	: STD_LOGIC_VECTOR(1 downto 0);

    -- Constants
    constant clk_period        	: TIME := 5 ns;
    signal test_running        	: boolean := true;
    signal test_case_num       	: INTEGER := 0;

    -- FSM States
    constant LOAD_NEW_MSG    	: STD_LOGIC_VECTOR(1 downto 0)     := "00";
    constant COUNT_WAIT      	: STD_LOGIC_VECTOR(1 downto 0)     := "01";
    constant COUNT_FIN_PARTIAL 	: STD_LOGIC_VECTOR(1 downto 0)     := "10";
    constant FINISHED        	: STD_LOGIC_VECTOR(1 downto 0)     := "11";

	signal mult_valid_out      	: STD_LOGIC;
	signal mult_ready_in       	: STD_LOGIC;
	signal mult_valid_in       	: STD_LOGIC;
	signal mult_ready_out      	: STD_LOGIC;
	signal mult_reset_neg      	: STD_LOGIC;

	signal mult_R_next         	: STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0);
	signal mult_P_next         	: STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0);
	signal mult_e_d            	: STD_LOGIC;				-- exponent bit (LSB first)

	---- can be deleted when testing is done ----
<<<<<<< HEAD
	signal mult_counter			: INTEGER;
=======
	signal mult_counter			: INTEGER in range 0 to C_BLOCK_SIZE;
>>>>>>> cb98b1c0a25e8962a1d6d4d123042f62adc11420
	signal mult_current_state	: STD_LOGIC_VECTOR(1 downto 0);					-- RESET = 00, COUNTING = 01, FINISHED = 10, unused 11

		-- Intermediate and result of R and P. R is to be treated as the resulting ciphertext.
	signal result_P          	: STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0) := (others => '0');

	-- Registers for storing input signals
	signal key_e_d_reg      	: STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0) := (others => '0');
	signal key_n_reg        	: STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0) := (others => '0');
	signal msgin_last_reg   	: STD_LOGIC := '0';

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
    DUT: entity work.exponentiation
        generic map (
            C_BLOCK_SIZE => C_BLOCK_SIZE
        )
        port map (
            -- Clock and reset
            clk               => clk,
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
            key_e_d         	=> key_e_d,
            key_n           	=> key_n,
            rsa_status      	=> rsa_status,

            -- Internal signals for testing
            counter         	=> counter,
            current_state   	=> current_state,

            msgin_data_reg  	=> msgin_data_reg,
            result_R        	=> result_R,
            result_P        	=> result_P,

            key_e_d_reg     	=> key_e_d_reg,
            key_n_reg       	=> key_n_reg,
            msgin_last_reg  	=> msgin_last_reg,
            mult_valid_out      => mult_valid_out,
            mult_ready_in       => mult_ready_in,
            mult_valid_in       => mult_valid_in,
            mult_ready_out      => mult_ready_out,
            mult_reset_neg      => mult_reset_neg,
            mult_R_next         => mult_R_next,
            mult_P_next         => mult_P_next,
            mult_e_d            => mult_e_d,
            mult_counter        => mult_counter,
            mult_current_state  => mult_current_state 
        );

    
    
    --------------------------------------------------
    -- Main test process
    --------------------------------------------------
    test_process: process

            -- helper function to test outputs correctness
        procedure check_outputs(
            expected_state  : STD_LOGIC_VECTOR(1 downto 0);
            expected_msgin_ready : STD_LOGIC;
            expected_msgout_valid : STD_LOGIC;
            expected_mult_valid_in  : STD_LOGIC;
            expected_mult_ready_out  : STD_LOGIC;
            expected_mult_reset_neg   : STD_LOGIC
        ) is
        begin 
            if current_state /= expected_state then
                report "TEST " & INTEGER'image(test_case_num) & " FAILED: Incorrect current_state" severity error;
            end if;

            if msgin_ready /= expected_msgin_ready then
                report "TEST " & INTEGER'image(test_case_num) & " FAILED: Incorrect msgin_ready" severity error;
            end if;

            if msgout_valid /= expected_msgout_valid then
                report "TEST " & INTEGER'image(test_case_num) & " FAILED: Incorrect msgout_valid" severity error;
            end if;

            if mult_valid_in = expected_mult_valid_in then
                report "TEST " & INTEGER'image(test_case_num) & " FAILED: Incorrect mult_valid_in" severity error;
            end if;

            if mult_ready_out /= expected_mult_ready_out then
                report "TEST " & INTEGER'image(test_case_num) & " FAILED: Incorrect mult_ready_out" severity error;
            end if;

            if mult_reset_neg /= expected_mult_reset_neg then
                report "TEST " & INTEGER'image(test_case_num) & " FAILED: Incorrect mult_reset_neg" severity error;
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
            expected_mult_valid_in  => '0',
            expected_mult_ready_out  => '0',
            expected_mult_reset_neg   => '0'
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

        key_n <= x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d"; -- msgin_data 
        key_e_d    <= x"0000000000000000000000000000000000000000000000000000000000010001"; -- key_e_d = 3, 256 bit
        msgin_data      <= x"0a23232323232323232323232323232323232323232323232323232323232323"; -- key_n = 256, 256 bit

        msgin_valid <= '1';
        msgin_last  <= '1';

        wait for clk_period;

        check_outputs(
            expected_state       => COUNT_WAIT,
            expected_msgin_ready => '0',
            expected_msgout_valid => '0',
            expected_mult_valid_in  => '1',
            expected_mult_ready_out  => '1',
            expected_mult_reset_neg   => '1'
        );
        report "TEST CASE 2: PASSED" severity note;

        msgin_valid <= '0';

        --------------------------------------------------------------
        -- TEST CASE 3: Wait for operation to complete and check outputs
        --------------------------------------------------------------
        test_case_num <= 3;

        report "TEST CASE 3: Wait for operation to complete and check outputs" severity note;

        wait for clk_period * 256;  -- wait enough TIME for operation to complete

        check_outputs(
            expected_state       => COUNT_FIN_PARTIAL,
            expected_msgin_ready => '0',
            expected_msgout_valid => '1',
            expected_mult_valid_in  => '0',
            expected_mult_ready_out  => '0',
            expected_mult_reset_neg   => '1'
        );

        report "TEST CASE 3: PASSED" severity note;



        wait;
    end process test_process;
end Behavioral;

