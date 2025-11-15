------------------------------------------
-- Exponentiation FSM VHDL Module

-- This module implements the finite state machine (FSM) for controlling the
-- modular exponentiation process. It manages the states of the operation,
-- including resetting, counting through the bits of the exponent, and
-- signaling when the computation is finished.

-- assumes constant inputs during operation.
-- Do not change inputs until valid_out is high.
------------------------------------------


library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mult_with_mod_fsm is
    generic (
		C_BLOCK_SIZE    : INTEGER := 256
	);
    port ( 
        -- utility
        reset_neg       : in STD_LOGIC;
        clk             : in STD_LOGIC;

        -- input data
        a               : in STD_LOGIC_VECTOR ( C_BLOCK_SIZE - 1 downto 0 );

        -- input control
        ready_out       : in STD_LOGIC;
        valid_in        : in STD_LOGIC;
        
        -- output control
        ready_in        : out STD_LOGIC;
        valid_out       : out STD_LOGIC;
        
        -- mux control signals
        mux_ctrl_P_in   : in STD_LOGIC_VECTOR ( 3 downto 0 );
        mux_ctrl_R_in   : in STD_LOGIC_VECTOR ( 3 downto 0 );
        
        -- output mux control signals
        mux_ctrl_P_out  : out STD_LOGIC_VECTOR ( 2 downto 0 );
        mux_ctrl_R_out  : out STD_LOGIC_VECTOR ( 2 downto 0 );

        -- internal state signal
        current_state   : inout STD_LOGIC_VECTOR ( 1 downto 0 )
    ); 
end mult_with_mod_fsm;

architecture mult_fsm_behave of mult_with_mod_fsm is
    --------------------------------------------------------------------
    -- RESET = 00, COUNTING = 01, FINISHED = 10, unused 11
    --------------------------------------------------------------------
    signal  next_state 
        : STD_LOGIC_VECTOR ( 1 downto 0 );

    signal counter 
        : INTEGER range 0 to C_BLOCK_SIZE;

    signal  bit_shifted_a 
        : STD_LOGIC_VECTOR ( C_BLOCK_SIZE-1 downto 0 );

begin

    ------------------------------------------
    -- Set outputs based on current state
    ------------------------------------------
    setOutputs: process (current_state, mux_ctrl_R_in, mux_ctrl_P_in, bit_shifted_a(255))
    begin
        case current_state is
            when "00" =>    -- RESET
                ready_in    <= '1';
                valid_out   <= '0';
                mux_ctrl_P_out <= "111";    -- Indicate invalid mux selection
                mux_ctrl_R_out <= "111";    -- Indicate invalid mux selection

            when "01" =>  -- COUNTING
                ready_in    <= '0';
                valid_out   <= '0';

                ----------------------------------------------------------------------------------
                -- Determine Mux Control Outputs

                -- If a(255) = '1'  --> possible outputs: S1, S3, S5 for R and S7, S9, S11 for P
                ----------------------------------------------------------------------------------
                if (bit_shifted_a(255) = '1') then
                    -- Mux control R
                    if ( mux_ctrl_R_in(3) = '0') then       -- If R + b - 2*n >= 0
                        mux_ctrl_R_out <= "101";            -- Select S5: R = R + b - 2*n

                    elsif ( mux_ctrl_R_in(1) = '0') then    -- If R + b - n >= 0
                        mux_ctrl_R_out <= "011";            -- Select S3: R = R + b - n

                    else                                    -- R >= 0                   
                        mux_ctrl_R_out <= "001";            -- Select S1: R = R + b

                    end if;

                    -- Mux control P
                    if ( mux_ctrl_P_in(3) = '0') then       -- If P + b - 2*n >= 0
                        mux_ctrl_P_out <= "101";            -- Select S11: P = P + b - 2*n
                    
                    elsif ( mux_ctrl_P_in(1) = '0') then    -- If P + b - n >= 0
                        mux_ctrl_P_out <= "011";            -- Select S9: P = P + b - n

                    else                                    -- P >= 0
                        mux_ctrl_P_out <= "001";            -- Select S7: P = P + b

                    end if;

                ----------------------------------------------------------------------------------
                -- Else             --> possible outputs: S0, S2, S4 for R and S6, S8, S10 for P
                ----------------------------------------------------------------------------------
                else

                    -- Mux control R
                    if ( mux_ctrl_R_in(2) = '0') then       -- If R - 2*n >= 0
                        mux_ctrl_R_out <= "100";            -- Select S4: R = R - 2*n
                    
                    elsif ( mux_ctrl_R_in(0) = '0') then    -- If R - n >= 0
                        mux_ctrl_R_out <= "010";            -- Select S2: R = R - n

                    else                                    -- R >= 0
                        mux_ctrl_R_out <= "000";            -- Select S0: R = R

                    end if;


                    -- Mux control P
                    if ( mux_ctrl_P_in(2) = '0') then       -- If P - 2*n >= 0
                        mux_ctrl_P_out <= "100";            -- Select S10: P = P - 2*n
                    
                    elsif ( mux_ctrl_P_in(0) = '0') then    -- If P - n >= 0
                        mux_ctrl_P_out <= "010";            -- Select S8: P = P - n

                    else                                    -- P >= 0
                        mux_ctrl_P_out <= "000";            -- Select S6: P = P

                    end if;
                end if;
                        
            when "10" =>  -- FINISHED
                ready_in    <= '0';
                valid_out   <= '1';
                mux_ctrl_P_out <= "000"; 
                mux_ctrl_R_out <= "000"; 


            -- Set equal to RESET state outputs
            when others =>      
                ready_in    <= '1';
                valid_out   <= '0';
                mux_ctrl_P_out <= "111";    -- Indicate invalid mux selection
                mux_ctrl_R_out <= "111";    -- Indicate invalid mux selection
        end case;
    end process setOutputs;

    
    -----------------------------------------
    -- Next State Logic.
    -----------------------------------------
   NextState: process (current_state, counter, ready_out, valid_in) 
   begin
        case current_state is 
            when "00" =>    -- RESET
                if (valid_in = '1') then 
                    next_state  <= "01"; -- COUNTING state
                else
                    next_state  <= "00"; -- RESET state
                end if;

            when "01" =>  -- COUNTING
   
                if ( counter = C_BLOCK_SIZE ) then
                    next_state  <= "10";  -- FINISHED state
                else
                    next_state <= "01";  -- COUNTING state
                end if;
                
            when "10" =>  -- FINISHED
                if( ready_out = '1' ) then
                    next_state  <= "00";  -- RESET state
                else 
                    next_state  <= "10";  -- FINISHED state
                end if;
                
    
            when others => -- UNUSED
                next_state <= "00"; -- RESET state

        end case;
    end process NextState;
   

    -----------------------------------------
    -- State Register. Updates current state on clock edge.
    -----------------------------------------
    SyncState: process (clk, reset_neg, current_state, next_state) 
    begin
        if rising_edge(clk) then
            if( reset_neg = '0' ) then
                current_state <= "00";  -- RESET state
            else
                current_state <= next_state;
            end if;

        end if;
    end process SyncState;
  

    -----------------------------------------
    -- Counter Control. Increments during COUNTING state.
    -- In other states, resets to zero.
    -- Uses next_state signal from Next State Logic.
    -----------------------------------------
    SyncCounter: process (clk, next_state) 
    begin
        if rising_edge(clk) then
            case next_state is
                when "01" =>    -- COUNTING
                    counter <= counter + 1;
    
                when others =>
                    counter <= 0;
            end case ;
        end if;
    end process SyncCounter;  
  

    -----------------------------------------
    -- Shift A register. Shifts left during COUNTING state.
    -- In other states, loads input a.
    -----------------------------------------
   ShiftA: process (clk, current_state, a, bit_shifted_a)
    begin
        if rising_edge(clk) then
            case current_state is
                when "00" =>   -- RESET
                    bit_shifted_a <= a;

                when "01" =>   -- COUNTING
                    bit_shifted_a <= STD_LOGIC_VECTOR( shift_left( unsigned( bit_shifted_a ), 1 ) );  -- Shift left by 1 bit 
    
                when others => -- FINISHED and UNUSED
                    bit_shifted_a <= bit_shifted_a;

            end case;
        end if;
    end process;
end mult_fsm_behave;
