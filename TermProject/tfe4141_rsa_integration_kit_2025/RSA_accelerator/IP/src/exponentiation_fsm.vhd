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
    Port ( 
        reset_n         : in std_logic;
        clk             : in std_logic;
        n               : in std_logic_vector(C_block_size-1 downto 0);
        a               : in std_logic_vector(C_block_size-1 downto 0);
        
        ready_out       : in std_logic;
        valid_in        : in std_logic;
        
        ready_in        : out std_logic;
        valid_out       : out std_logic;
        
        mux_ctrl_P_in   : in std_logic_vector(3 downto 0);
        mux_ctrl_R_in   : in std_logic_vector(3 downto 0);
        
        mux_ctrl_P_out  : out std_logic_vector(2 downto 0);
        mux_ctrl_R_out  : out std_logic_vector(2 downto 0);

        mux_calculation : out std_logic;
         
        counter         : out std_logic_vector(C_block_size-1 downto 0)
    );
end exponentiation_fsm;

architecture expFsmBehave of exponentiation_fsm is
   signal a_reg : std_logic_vector(C_block_size-1 downto 0);
    
    type state_type is (RESET, COUNTING, FINISHED);
    signal current_state, next_state : state_type;
begin
   
   
   NextState: process (current_state, counter, ready_out, valid_in, a_reg(255), mux_ctrl_P_in, mux_ctrl_R_in) 
   begin
        case current_state is 
            when RESET =>
                ready_in    <= '1';
                valid_out   <= '0';
                mux_calculation <= '0';
                    
                if (valid_in = '1') then 
                    next_state  <= COUNTING;
                else
                    next_state  <= RESET;
                end if;
                
            when COUNTING =>
                ready_in    <= '0';
                valid_out   <= '0';
                mux_calculation <= '1';
                
                -- Mux control P
                mux_ctrl_P_out(0) <=    a_reg(255) ;

                mux_ctrl_P_out(1) <=    (a_reg(255) and mux_ctrl_P_in(3) and not(mux_ctrl_P_in(1)))
                                        or (not(a_reg(255)) and mux_ctrl_P_in(2) and not(mux_ctrl_P_in(0)));

                mux_ctrl_P_out(2) <=    (a_reg(255)  and not(mux_ctrl_P_in(3))) 
                                        or  (not(a_reg(255)) and not(mux_ctrl_P_in(2)));
                                
                -- Mux control R
                mux_ctrl_R_out(0) <=    a_reg(255) ;

                mux_ctrl_R_out(1) <=    (a_reg(255) and mux_ctrl_R_in(3) and not(mux_ctrl_R_in(1)) ) 
                                        or  (not(a_reg(255)) and mux_ctrl_R_in(2) and not(mux_ctrl_R_in(0)) );

                mux_ctrl_R_out(2) <=    (a_reg(255) and not(mux_ctrl_R_in(3))) 
                                        or  (not(a_reg(255)) and not(mux_ctrl_R_in(2)));                
                
                -- Check if counting is finished                     
                if (counter = n) then
                    next_state  <= FINISHED; 
                else
                    next_state <= COUNTING;
                end if;
                
       
             when FINISHED =>
                ready_in    <= '0';
                valid_out   <= '1';
                mux_calculation <= '1';
                
                -- Hold result value
                mux_ctrl_P_out <= "000"; 
                mux_ctrl_R_out <= "000"; 
                
                if( ready_out = '1' ) then
                    next_state  <= RESET;
                else 
                    next_state  <= FINISHED;
                end if;
                
             when others =>
                next_state <= RESET;    
        end case;
   end process;
   
  SyncState: process (clk, reset_n) 
  begin
        if rising_edge(clk) then
            if( reset_n = '0' ) then
                current_state <= RESET;
            else
                current_state <= next_state;
            end if;
        end if;
  end process SyncState;
  
  SyncCounter: process (clk, reset_n) 
  begin
        if rising_edge(clk) then
            case current_state is
                when COUNTING =>
                    counter <= std_logic_vector( unsigned( counter ) + 1 );
    
                when others =>
                    counter <= ( others => '0' );
            end case ;
        end if;
  end process SyncCounter;
  
   ShiftA: process (clk, reset_n, a)
    begin
        if rising_edge(clk) then
            case current_state is
                when COUNTING =>
                    a_reg <= STD_LOGIC_VECTOR( shift_left( unsigned( a_reg ), 1 ) );  -- Shift left by 1 bit 
    
                when others =>
                    a_reg <= a;
            end case ;
        end if;
    end process;

end expFsmBehave;
