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


entity exponentiation_fsm is
    generic (
		C_block_size    : integer := 256
	);
    port ( 
        -- utility
        reset_n         : in std_logic;
        clk             : in std_logic;

        -- modulus
        n               : in std_logic_vector(C_block_size-1 downto 0);

        -- input data
        a               : in std_logic_vector(C_block_size-1 downto 0);
        bit_shifted_a   : out std_logic_vector( C_block_size-1 downto 0 );

        -- input control
        ready_out       : in std_logic;
        valid_in        : in std_logic;
        
        -- output control
        ready_in        : out std_logic;
        valid_out       : out std_logic;
        
        -- mux control signals
        mux_ctrl_P_in   : in std_logic_vector(3 downto 0);
        mux_ctrl_R_in   : in std_logic_vector(3 downto 0);
        
        -- output mux control signals
        mux_ctrl_P_out  : out std_logic_vector(2 downto 0);
        mux_ctrl_R_out  : out std_logic_vector(2 downto 0);
        
        -- RESET = 00, COUNTING = 01, FINISHED = 10, unused 11
        current_state  : inout std_logic_vector(1 downto 0);

        -- counter
        counter        : out std_logic_vector(C_block_size-1 downto 0)
    );
end exponentiation_fsm;

architecture expFsmBehave of exponentiation_fsm is
    -- RESET = 00, COUNTING = 01, FINISHED = 10, unused 11
    signal next_state : std_logic_vector(1 downto 0);

    -- Add any internal signals here when testing is done


begin
    -----------------------------------------
    -- Next State Logic. Combinational process to determine next state.
    -----------------------------------------
   NextState: process (current_state, counter, ready_out, valid_in, bit_shifted_a(255), mux_ctrl_P_in, mux_ctrl_R_in) 
   begin
        case current_state is 

            ---------------------
            -- RESET State
            ---------------------
            when "00" =>    -- RESET
                -- Set outputs
                ready_in    <= '1';
                valid_out   <= '0';

                -- Mux control P & R set to "111" to indicate uninitialized state
                mux_ctrl_P_out <= "111"; 
                mux_ctrl_R_out <= "111";
                    

                --------------------------------
                -- Next State Transition Check
                --------------------------------
                if (valid_in = '1') then 
                    next_state  <= "01"; -- COUNTING state
                else
                    next_state  <= "00"; -- RESET state
                end if;
                

            ---------------------
            -- COUNTING State
            ---------------------
            when "01" =>  -- COUNTING
                -- Set outputs
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
                        

                ----------------------------------------------
                -- Next State Transition Check           
                ----------------------------------------------       
                if (counter = n ) then
                    next_state  <= "10";  -- FINISHED state
                else
                    next_state <= "01";  -- COUNTING state
                end if;
                

            ---------------------
            -- FINISHED State
            ---------------------
            when "10" =>  -- FINISHED
                -- Set outputs
                ready_in    <= '0';
                valid_out   <= '1';
               
                -- Hold result values
                mux_ctrl_P_out <= "000"; 
                mux_ctrl_R_out <= "000"; 

                -- Check for transition
                if( ready_out = '1' ) then
                    next_state  <= "00";  -- RESET state
                else 
                    next_state  <= "10";  -- FINISHED state
                end if;
                
            ------------------
            -- Default case
            ------------------
            when others =>
                next_state <= "00"; -- RESET state 
        end case;
    end process NextState;
   

    -----------------------------------------
    -- State Register. Updates current state on clock edge.
    -----------------------------------------
    SyncState: process (clk, reset_n, current_state, next_state) 
    begin
        if rising_edge(clk) then
            if( reset_n = '0' ) then
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
    SyncCounter: process (clk, reset_n, next_state) 
    begin
        if rising_edge(clk) then
            case next_state is
                when "01" =>    -- COUNTING
                    counter <= std_logic_vector( unsigned( counter ) + 1 );
    
                when others =>
                    counter <= ( others => '0' );
            end case ;
        end if;
    end process SyncCounter;  
  

    -----------------------------------------
    -- Shift A register. Shifts left during COUNTING state.
    -- In other states, loads input a.
    -----------------------------------------
   ShiftA: process (clk, current_state)
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

end expFsmBehave;
