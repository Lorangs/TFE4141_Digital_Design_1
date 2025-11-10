----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/22/2025 06:00:20 PM
-- Design Name: 
-- Module Name: rsa_core_fsm - rsa_core_fsm_behave
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

entity rsa_core_fsm is
    generic (
        C_block_size : integer := 256
    );

    Port ( 
        ------------------------------------
        -- External Interface Signals
        ------------------------------------
        clk                 : in std_logic;
        reset_neg             : in std_logic;

        -- handshaking signals with external module.
        msgout_ready        : in std_logic;
        msgout_valid        : out std_logic;
        msgin_ready         : out std_logic;
        msgin_valid         : in std_logic;
        msgin_last          : in std_logic;

        -- handshaking signals with exponentiation module.
        exp_ready_in        : in std_logic;
        exp_valid_in        : out std_logic;
        exp_ready_out       : out std_logic;
        exp_valid_out       : in std_logic;
        exp_reset_neg       : out std_logic;

        -- RSA status signal
        rsa_status          : out std_logic_vector(31 downto 0);

        -- modulus 
        n                   : in std_logic_vector(C_block_size-1 downto 0);  

        -- exponent bits
        key_e_d_reg         : in std_logic_vector(C_block_size-1 downto 0);
        key_e_d_LSB         : out std_logic;     
        
        current_state       : inout std_logic_vector(1 downto 0);

        -- internal signals for testing
        counter             : inout std_logic_vector(C_block_size-1 downto 0 )
    );
end rsa_core_fsm;

architecture rsa_core_fsm_behave of rsa_core_fsm is
    ------------------------------------------------------------------------
    -- RESET = 00, COUNT_WAIT = 01, COUNT_FIN_PARTIAL = 10, FINISHED = 11
    -------------------------------------------------------------------------
    signal next_state                   : std_logic_vector(1 downto 0);

    signal bit_shifted_key_e_d          : std_logic_vector(C_block_size-1 downto 0);

begin

    --------------------------------------
    -- RSA Status Signal.
    --------------------------------------
    rsa_status <= (others => '0');

    ---------------------------------------
    -- Bit shift key_e_d to get LSB
    ---------------------------------------
    key_e_d_LSB <= bit_shifted_key_e_d(0);

    bit_shift_e_d_Process: process (clk, current_state, key_e_d_reg)
    begin
        if rising_edge(clk) then
            case current_state is 
                when "00" =>-- LOAD_NEW_MSG
                    bit_shifted_key_e_d <= key_e_d_reg;

                when "10" =>  -- COUNT_FIN_PARTIAL
                    bit_shifted_key_e_d <= std_logic_vector( shift_right( unsigned( bit_shifted_key_e_d ), 1 ) );

                when others => -- COUNT_WAIT, FINISHED
                    bit_shifted_key_e_d <= bit_shifted_key_e_d;
            end case;
        end if;
    end process bit_shift_e_d_Process;


    -----------------------------------
    -- Current and Next State Syncronization
    -----------------------------------
    CurrentState: process (clk, reset_neg, next_state)
    begin
        if rising_edge(clk) then
            if (reset_neg = '0') then
                current_state <= "00"; -- LOAD_NEW_MSG state
            else
                current_state <= next_state;
            end if;
        end if;
    end process CurrentState;


    ------------------------------------
    -- Set Outputs based on current state
    ------------------------------------
    OutputLogic: process (current_state)
    begin
        case current_state is  
        
            when "00" =>  -- LOAD_NEW_MSG
                msgin_ready    <= '1';
                msgout_valid   <= '0';
                exp_valid_in   <= '0';
                exp_ready_out  <= '0';
                exp_reset_neg  <= '0';

            when "01" =>  -- COUNT_WAIT
                msgin_ready    <= '0';
                msgout_valid   <= '0';
                exp_valid_in   <= '1';
                exp_ready_out  <= '1';
                exp_reset_neg  <= '1';

            when "10" =>  -- COUNT_FIN_PARTIAL
                msgin_ready    <= '0';
                msgout_valid   <= '0';
                exp_valid_in   <= '0';
                exp_ready_out  <= '1';
                exp_reset_neg  <= '1';

            when "11" =>  -- FINISHED
                msgin_ready    <= '0';
                msgout_valid   <= '1';
                exp_valid_in   <= '0';
                exp_ready_out  <= '0';
                exp_reset_neg  <= '1';

            when others =>  -- default case
                msgin_ready    <= '1';
                msgout_valid   <= '0';
                exp_valid_in   <= '0';
                exp_ready_out  <= '0';
                exp_reset_neg  <= '0';

        end case;
    end process OutputLogic;


    -----------------------------------
    -- Next State Logic
    -----------------------------------
    NextState: process (current_state, msgin_valid, exp_ready_in, exp_valid_out, msgout_ready, counter, n)
    begin
        case current_state is 

            when "00" =>   -- LOAD_NEW_MSG

                if (msgin_valid = '1' and exp_ready_in = '1') then
                    next_state  <= "01";  -- COUNT_WAIT state
                else
                    next_state <= "00";   -- remain in LOAD_NEW_MSG state
                end if;


            when "01" =>  -- COUNT_WAIT

                if ( exp_valid_out = '0' ) then
                    next_state  <= "01";  -- COUNT_WAIT state
                else
                    next_state  <= "10";  -- COUNT_FIN_PARTIAL state
                end if;


            when "10" =>  -- COUNT_FIN_PARTIAL

                if (exp_ready_in = '0') then -- Should never happen. The counter will be out of sync.
                    next_state  <= "10";  -- COUNT_FIN_PARTIAL state

                elsif ( counter < n ) then
                    next_state <= "01";  -- COUNT_WAIT state

                else 
                    next_state  <= "11";  -- FINISHED state

                end if;


            when "11" =>  -- FINISHED

                if( msgout_ready = '1' ) then
                    next_state  <= "00";  -- LOAD_NEW_MSG state

                else
                    next_state  <= "11";  -- FINISHED state

                end if;
            

            when others =>  -- default case
                next_state <= "00"; -- LOAD_NEW_MSG state

        end case;
    end process NextState;

    
    -----------------------------------
    -- Sync counter
    -----------------------------------
    SyncCounter: process (current_state, next_state) 
    begin
        case current_state is
            when "00" => -- LOAD_NEW_MSG
                counter <= (others => '0');

            when "10" => -- COUNT_FIN_PARTIAL

                if next_state = "01" then   -- transition to COUNT_WAIT
                    counter <= std_logic_vector( unsigned( counter ) + 1);

                else
                    counter <= counter;
                
                end if;

            when others => -- COUNT_WAIT, FINISHED
                counter <= counter;
        end case;
    end process SyncCounter;



end rsa_core_fsm_behave;
