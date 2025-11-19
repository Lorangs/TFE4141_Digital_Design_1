-------------------------------------------------------------------------  -------
-- Author       : L. Strand, S. Gripsgård, O.J. Schubert
-- Organization : Norwegian University of Science and Technology (NTNU)
--                Department of Electronic Systems
--                https://www.ntnu.edu/ies
-- Course       : TFE4141 Design of digital systems 1 (DDS1)
-- Year         : Autumn 2025
-- Project      : RSA accelerator
-- License      : This is free and unencumbered software released into the
--                public domain (UNLICENSE)
--------------------------------------------------------------------------------
-- Purpose:
    --   VHDL implementation of FSM for modular exponentiation module for RSA encryption
    --   and decryption. Manages the states of the operation,
    --   including resetting, counting through the bits of the exponent, and
    --   signaling when the computation is finished.
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_STD.all;

entity exponentiation_fsm is
    generic (
        C_BLOCK_SIZE : INTEGER := 256
    );

    Port ( 
        ------------------------------------
        -- External Interface Signals
        ------------------------------------
        clk                 : in STD_LOGIC;
        reset_neg           : in STD_LOGIC;

        -- handshaking signals with external module.
        msgout_ready        : in STD_LOGIC;
        msgout_valid        : out STD_LOGIC;
        msgin_ready         : out STD_LOGIC;
        msgin_valid         : in STD_LOGIC;
 
        -- handshaking signals with mult_with_mod module.
        mult_ready_in       : in STD_LOGIC;
        mult_valid_in       : out STD_LOGIC;
        mult_ready_out      : out STD_LOGIC;
        mult_valid_out      : in STD_LOGIC;
        mult_reset_neg      : out STD_LOGIC;

        -- exponent bits
        key_e_d_reg         : in STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
        key_e_d_LSB         : out STD_LOGIC;     

        -- internal state signal transmitted to top module
        current_state       : inout STD_LOGIC_VECTOR( 1 downto 0 ) -- LOAD_NEW_MSG = 00, COUNT_WAIT = 01, COUNT_FIN_PARTIAL = 10, FINISHED = 11
    );
end exponentiation_fsm;

architecture exponentiation_fsm_behave of exponentiation_fsm is
    ------------------------------------------------------------------------
    -- RESET = 00, COUNT_WAIT = 01, COUNT_FIN_PARTIAL = 10, FINISHED = 11
    -------------------------------------------------------------------------
    signal next_state                   : STD_LOGIC_VECTOR(1 downto 0);
    signal counter                      : INTEGER range 0 to C_BLOCK_SIZE;              -- Counter to track number of exponent bits processed
    signal bit_shifted_key_e_d          : STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0);    -- Shifted version of key_e_d to extract LSB at each step
begin
    ---------------------------------------
    -- Bit shift key_e_d to get LSB
    ---------------------------------------
    key_e_d_LSB <= bit_shifted_key_e_d(0);


    ---------------------------------------
    -- Bit shift process for key_e_d
    ---------------------------------------
    bit_shift_e_d_Process: process (clk, current_state, key_e_d_reg, bit_shifted_key_e_d)
    begin
        if rising_edge(clk) then
            case current_state is 
                when "00" =>-- LOAD_NEW_MSG
                    bit_shifted_key_e_d <= key_e_d_reg;

                when "10" =>  -- COUNT_FIN_PARTIAL
                    bit_shifted_key_e_d <= STD_LOGIC_VECTOR( shift_right( unsigned( bit_shifted_key_e_d ), 1 ) );

                when others => -- COUNT_WAIT, FINISHED
                    bit_shifted_key_e_d <= bit_shifted_key_e_d;
            end case;
        end if;
    end process bit_shift_e_d_Process;



    ------------------------------------
    -- Set Outputs based on current state
    ------------------------------------
    OutputLogic: process (current_state)
    begin
        case current_state is  
        
            when "00" =>  -- LOAD_NEW_MSG
                msgin_ready    <= '1';
                msgout_valid   <= '0';
                mult_valid_in   <= '0';
                mult_ready_out  <= '0';
                mult_reset_neg  <= '0';

            when "01" =>  -- COUNT_WAIT
                msgin_ready    <= '0';
                msgout_valid   <= '0';
                mult_valid_in   <= '1';
                mult_ready_out  <= '1';
                mult_reset_neg  <= '1';

            when "10" =>  -- COUNT_FIN_PARTIAL
                msgin_ready    <= '0';
                msgout_valid   <= '0';
                mult_valid_in   <= '0';
                mult_ready_out  <= '1';
                mult_reset_neg  <= '1';

            when "11" =>  -- FINISHED
                msgin_ready    <= '0';
                msgout_valid   <= '1';
                mult_valid_in   <= '0';
                mult_ready_out  <= '0';
                mult_reset_neg  <= '1';

            when others =>  -- default case
                msgin_ready    <= '1';
                msgout_valid   <= '0';
                mult_valid_in   <= '0';
                mult_ready_out  <= '0';
                mult_reset_neg  <= '0';

        end case;
    end process OutputLogic;


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


    -----------------------------------
    -- Next State Logic
    -----------------------------------
    NextState: process (current_state, msgin_valid, mult_ready_in, mult_valid_out, msgout_ready, counter)
    begin
        case current_state is 

            when "00" =>   -- LOAD_NEW_MSG
                if (msgin_valid = '1' and mult_ready_in = '1') then
                    next_state  <= "01";  -- COUNT_WAIT state

                else
                    next_state <= "00";   -- remain in LOAD_NEW_MSG state
                end if;


            when "01" =>  -- COUNT_WAIT
                if ( mult_valid_out = '0' ) then
                    next_state  <= "01";  -- COUNT_WAIT state

                else
                    next_state  <= "10";  -- COUNT_FIN_PARTIAL state
                end if;


            when "10" =>  -- COUNT_FIN_PARTIAL
                if (mult_ready_in = '0') then -- Should never happen. The counter will be out of sync.
                    next_state  <= "10";  -- COUNT_FIN_PARTIAL state

                elsif ( counter < C_BLOCK_SIZE ) then
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
    SyncCounter: process (clk, current_state, next_state, counter) 
    begin
        if rising_edge(clk) then
            case current_state is
                when "00" => -- LOAD_NEW_MSG
                    counter <= 0;

                when "10" => -- COUNT_FIN_PARTIAL

                    if next_state = "01" then   -- transition to COUNT_WAIT
                        counter <= counter + 1;

                    else
                        counter <= counter;
                    
                    end if;

                when others => -- COUNT_WAIT, FINISHED
                    counter <= counter;
                    
            end case;
        end if;
    end process SyncCounter;
end exponentiation_fsm_behave;
