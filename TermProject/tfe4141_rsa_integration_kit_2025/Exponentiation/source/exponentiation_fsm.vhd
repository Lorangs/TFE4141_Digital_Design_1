----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2025 15:27:47
-- Design Name: 
-- Module Name: exponentiation_fsm - expFsmBehave
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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity exponentiation_fsm is
    generic (
		C_block_size    : integer := 256
	);
    port ( 
        -- utility
        reset_n         : in std_logic;
        clk             : in std_logic;

        -- modulus
        n_minus_1       : in std_logic_vector(C_block_size-1 downto 0);

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
        counter         : out std_logic_vector(C_block_size-1 downto 0)
    );
end exponentiation_fsm;

architecture expFsmBehave of exponentiation_fsm is
    -- RESET = 00, COUNTING = 01, FINISHED = 10, unused 11
    signal next_state : std_logic_vector(1 downto 0);

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

                ----------------------------------
                -- Determine which summation to pass through to the outputs P_result and R_result.
                -- Based on the MSB of bit_shifted_a and the signs of the perfomed summations. See high-level code for details.
                ----------------------------------
                if (bit_shifted_a(255) = '1') then
                    -- Only summation S1, S3 and S5 possible for R and S7, S9 and S11 for P

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

                else
                    -- Only summation S2, S4 and S6 possible for R and S8, S10 and S12 for P

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
                        

                -- Check if counting is finished                     
                if (counter >= n_minus_1 ) then
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
   end process;
   

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
  -----------------------------------------
  SyncCounter: process (clk, reset_n, current_state) 
  begin
        if rising_edge(clk) then
            case current_state is
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

            end case ;
        end if;
    end process;

end expFsmBehave;
