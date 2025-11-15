library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ALL;

use work.rsa_core_types.all;

entity rsa_core_tb is
    generic (
        C_block_size    : integer := 256;
        NUM_CORES       : INTEGER := 4
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
    signal result_R             : std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');
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
    
    signal queue_empty     : std_logic := '1';
    signal queue_full      : std_logic := '0';
    signal queue_tail      : integer range 0 to NUM_CORES - 1 := 0;
    signal queue_head      : integer range 0 to NUM_CORES - 1 := 0;

    signal exp_current_state  : state_array_t(0 to NUM_CORES - 1);

    -- Constants
    constant clk_period        : time := 5 ns;
    signal test_running        : boolean := true;
    signal test_case_num       : integer := 0;

begin
    ---------------------------
    -- Clock generation
    ---------------------------
    clk_process : process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process clk_process;


    ------------------------------
    -- DUT instantiation
    ------------------------------
    DUT: entity work.rsa_core
        generic map (
            C_BLOCK_SIZE => C_BLOCK_SIZE,
            NUM_CORES    => NUM_CORES
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

            -- Internal signals for testing. Can be moved to signal interface when testing is done.
            -- msgin_valid_array   => msgin_valid_array,
            -- msgin_ready_array   => msgin_ready_array,
            -- msgout_valid_array  => msgout_valid_array,
            -- msgout_ready_array  => msgout_ready_array,
            queue_empty         => queue_empty,
            queue_full          => queue_full,
            queue_tail          => queue_tail,
            queue_head          => queue_head,

            exp_current_state   => exp_current_state
        );


    test_process: process
    begin
        -- Reset the DUT
        reset_neg <= '0';
        wait for clk_period * 2;

        assert queue_empty = '1' report "Error: Queue should be empty after reset" severity error;
        assert queue_full = '0' report "Error: Queue should not be full after reset" severity error;
        assert queue_head = 0 report "Error: Queue head should be 0 after reset" severity error;
        assert queue_tail = 0 report "Error: Queue tail should be 0 after reset" severity error;


        reset_neg <= '1';

        key_n <= x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";
        key_e_d <= x"0000000000000000000000000000000000000000000000000000000000010001";
        msgin_data <= x"85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01";
    
        msgin_valid <= '1';
        
        wait for clk_period;

        msgin_valid <= '0';
        msgin_data <= x"08f9baf32e8505cbc9a28fed4d5791dce46508c3d1636232bf91f5d0b6632a9f";

        wait for clk_period;

        msgin_valid <= '1';
        
        wait for clk_period;
        
        msgin_valid <= '0';
        msgout_ready <= '1';
        

        -- End simulation
        report "-----Testbench completed-----";
        wait;
    end process test_process;

    
end Behavioral;
