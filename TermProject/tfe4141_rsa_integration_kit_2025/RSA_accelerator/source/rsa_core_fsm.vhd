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
           clk              : in STD_LOGIC;
           reset_n          : in STD_LOGIC;
           msgin_valid      : in STD_LOGIC;
           msgin_last       : in STD_LOGIC;
           msgout_ready     : in STD_LOGIC;
           msgin_ready      : out STD_LOGIC;
           msgout_valid     : out STD_LOGIC;
           msgout_last      : out STD_LOGIC;
           rsa_status       : out STD_LOGIC;

           key_e_d          : in STD_LOGIC_VECTOR(C_block_size-1 downto 0);

        ------------------------------------
        -- Internal Interface Signals
        ------------------------------------
            valid_out         : in STD_LOGIC;
            ready_in          : in STD_LOGIC;
            valid_in          : out STD_LOGIC;
            ready_out         : out STD_LOGIC;
            new_msg_neg       : out STD_LOGIC;
            update_R_or_not   : out STD_LOGIC;
        );
end rsa_core_fsm;

architecture rsa_core_fsm_behave of rsa_core_fsm is

    type state_type is (LOAD_NEW_MSG, COUNT_WAIT, COUNT_FIN_PARTIAL, FINISHED);
    signal current_state, next_state    : state_type                                := LOAD_NEW_MSG;
    signal counter                      : std_logic_vector(9 downto 0)              := (others => '0');  -- enough to count to 512 (we need to count 257)
    signal n                            : std_logic_vector(C_block_size-1 downto 0) := std_logic_vector(to_unsigned(C_block_size, C_block_size));
    signal bit_shifted_key_e_d          : std_logic_vector(C_block_size-1 downto 0);

begin

    -----------------------------------
    -- Next State Logic
    -----------------------------------
    NextState: process (current_state, msgin_valid, msgin_last, msgout_ready)
    begin
        case current_state is
            when LOAD_NEW_MSG =>
                -- set outputs
                rsa_status          <= '0';
                msgin_ready         <= '1';   
                msgout_last         <= msgin_last;
                msgout_valid        <= '0';
                valid_in            <= '0';
                ready_out           <= '0';
                new_msg_neg         <= '0';

                -- check for transition
                if msgin_valid = '1' and ready_in = '1' then
                    next_state      <= COUNT_WAIT;  
                else
                    next_state      <= LOAD_NEW_MSG;
                end if;

            when COUNT_WAIT =>
                -- set outputs
                rsa_status          <= '0';
                msgin_ready         <= '0';
                msgout_valid        <= '0';
                valid_in            <= '1';
                ready_out           <= '1';
                new_msg_neg         <= '1';
                

                -- check for transition
                if valid_out = '1' then
                    next_state      <= COUNT_FIN_PARTIAL;
                else
                    next_state      <= COUNT_WAIT;
                end if;

            when COUNT_FIN_PARTIAL =>
                -- set outputs
                rsa_status          <= '0';
                msgin_ready         <= '0';
                msgout_valid        <= '0';
                valid_in            <= '0';
                ready_out           <= '1';
                new_msg_neg         <= '1';
                

                -- check for transition
                if ready_in = '1' then
                    if counter >= n then     
                        next_state      <= FINISHED;

                    else
                        next_state      <= COUNT_WAIT;
                    end if;
                else
                    next_state      <= COUNT_FIN_PARTIAL;
                end if;

            when FINISHED =>
                -- set outputs
                rsa_status          <= '0';
                msgin_ready         <= '0';
                msgout_valid        <= '1';
                valid_in            <= '0';
                ready_out           <= '0';
                new_msg_neg         <= '1';

                -- check for transition
                if msgout_ready = '1' then
                    next_state      <= LOAD_NEW_MSG;
                else
                    next_state      <= FINISHED;
                end if;
        end case;
    end process;


    -----------------------------------
    -- Sync current state with next state
    -----------------------------------
    SyncState: process (clk, reset_n) 
    begin
            if rising_edge(clk) then
                if( reset_n = '0' ) then
                    current_state <= LOAD_NEW_MSG;
                else
                    current_state <= next_state;
                end if;
            end if;
    end process SyncState;


    -----------------------------------
    -- Sync counter
    -----------------------------------
    SyncCounter: process (clk, reset_n) 
    begin
        if rising_edge(clk) then
            if current_state = COUNT_FIN_PARTIAL and next_state = COUNT_WAIT then
                counter <= std_logic_vector( unsigned( counter ) + 1 );

            elsif current_state = LOAD_NEW_MSG and next_state = COUNT_WAIT then
                counter <= ( others => '0' );
            else
                counter <= counter;
            end if;
        end if;
    end process SyncCounter;


    -----------------------------------
    -- Sync bit_shifted_key_e_d and update_R_or_not
    -----------------------------------
    SyncUpdate_R_or_not: process (clk, reset_n, key_e_d)
    begin
        if rising_edge(clk) then
            update_R_or_not <= bit_shifted_key_e_d(0);

            if current_state = LOAD_NEW_MSG then
                bit_shifted_key_e_d <= key_e_d;

            elsif current_state = COUNT_WAIT and next_state = COUNT_FIN_PARTIAL then
                bit_shifted_key_e_d <= '0' & bit_shifted_key_e_d(C_block_size-2 downto 0);  -- shift right

            else
                bit_shifted_key_e_d <= bit_shifted_key_e_d;
            end if;
        end if;
    end process SyncUpdate_R_or_not;
end rsa_core_fsm_behave;
