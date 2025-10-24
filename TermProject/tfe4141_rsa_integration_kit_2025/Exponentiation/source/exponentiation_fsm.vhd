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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

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
        
        ready_out       : in std_logic;
        valid_in        : in std_logic;
        
        ready_in        : out std_logic;
        valid_out       : out std_logic;
        load_result     : out std_logic
        );
end exponentiation_fsm;

architecture expFsmBehave of exponentiation_fsm is
    signal counter : std_logic_vector(C_block_size-1 downto 0);
    
    type state_type is (RESET, COUNTING, FINISHED);
    signal current_state, next_state : state_type;
begin
   
 ------ State machine ------
   NextState: process (current_state, load_result, ready_out, valid_in) 
   begin
        case current_state is 
            when RESET =>
                ready_in    <= '1';
                valid_out   <= '0';
                counter     <= (others => '0');
                load_result <= '0';
                    
                if (valid_in = '1' and reset_n = '1') then 
                    next_state  <= COUNTING;
                else
                    next_state  <= RESET;
                end if;
                
            when COUNTING =>
                ready_in    <= '0';
                valid_out   <= '0';
                
                if (reset_n = '0') then
                    next_state <= RESET;
                else
                    if (counter = n) then
                        load_result <= '1';
                        next_state  <= FINISHED;
                    else
                        next_state <= COUNTING;
                    end if;
                end if;
       
             when FINISHED =>
                ready_in    <= '0';
                valid_out   <= '1';
                load_result <= '0';
                
                if (reset_n = '0' or ready_out = '1') then
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
    if(reset_n = '0') then
        current_state <= RESET;
    elsif rising_edge(clk) then
        current_state <= next_state;
    end if;
  end process SyncState;
  
  SyncCounter: process (clk, reset_n) 
  begin
    if (reset_n = '0') then 
        counter <= (others => '0');
    elsif rising_edge(clk) then
        counter <= std_logic_vector(unsigned(counter) + 1);
    end if;
  end process SyncCounter;
 

end expFsmBehave;
