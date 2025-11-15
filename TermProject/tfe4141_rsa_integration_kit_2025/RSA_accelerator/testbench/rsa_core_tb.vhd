library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.rsa_types_pkg.all; 

entity rsa_core_tb is
    generic (
        C_BLOCK_SIZE    : integer := 256;
        NUM_CORES       : integer := 6
    );
end rsa_core_tb;

architecture Behavioral of rsa_core_tb is

    -- Clock and reset
    signal clk                 : std_logic := '0';
    signal reset_n           : std_logic := '0';

    -- Slave msgin interface
    signal msgin_valid         : std_logic := '0';
    signal msgin_ready         : std_logic;
    signal msgin_data          : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
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

    -- Constants
    constant clk_period        : time := 10 ns;


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
            C_BLOCK_SIZE => C_BLOCK_SIZE
        )
        port map (
            -- Clock and reset
            clk             => clk,
            reset_n         => reset_n,

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
            rsa_status      => rsa_status
        );


    test_process: process
    begin
        -- Reset the DUT
        reset_n <= '0';

        key_n       <= x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";
        key_e_d       <= x"0000000000000000000000000000000000000000000000000000000000010001";
        msgin_data  <= x"0a23232323232323232323232323232323232323232323232323232323232323";

        msgin_valid <= '1';
        msgin_last  <= '0';
        msgout_ready <= '1';

        wait for clk_period;
        reset_n <= '1';

        wait for clk_period;
        msgin_valid <= '0';
        msgin_data <= x"85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01";

        wait for clk_period;
        msgin_valid <= '1';

        wait for clk_period;
        msgin_valid <= '0';
        msgin_data  <= x"0a23232323232323232323232323232323232323232323232323232323232323";

        wait for clk_period;
        msgin_valid <= '1';

        wait for clk_period;
        msgin_valid <= '0';
        msgin_data <= x"85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01";

        wait for clk_period;
        msgin_valid <= '1';

        wait for clk_period;
        msgin_valid <= '0';
        msgin_last  <= '1';
        msgin_data  <= x"0a23232323232323232323232323232323232323232323232323232323232323";

        wait for clk_period;
        msgin_valid <= '1';

        wait for clk_period;
        msgin_valid <= '0';
    
        wait;
    end process;
    
end Behavioral;
