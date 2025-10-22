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
        valid_out       : out std_logic;
        load_result     : out std_logic
        );
end exponentiation_fsm;

architecture expFsmBehave of exponentiation_fsm is
    signal counter, counter_new : std_logic_vector(C_block_size-1 downto 0);
    
    type state_type is (RESET, COUNTING, FINISHED);
    signal current_state, next_state : state_type;
begin
    
    -- counter register
    process (clk, reset_n)
    begin 
        if rising_edge(clk) then 
            if (reset_n = '0') then
                counter <= (others => '0');
            else
                counter <= counter_new;
            end if;
         end if;
    end process;

   counter_new  <= std_logic_vector(unsigned(counter) + 1);

   load_result   <= '1' when counter = n else '0';
   
   
 ------ State machine ------
 
   process (clk, reset_n, load_result, ready_out) 
   begin
        case state is 
            when RESET =>
                if (reset_n = '0') then
                    next_state <= RESET;
                else 
                    next_state <= COUNTING;
                end if;
                
            when COUNTING =>
                if (reset_n = '0') then
                    next_state <= RESET;
                else
                    if (load_result = '0') then
                        next_state <= COUNTING;
                    else 
                        valid_out  <= '1';
                        next_state <= FINISHED;
                    end if;
                end if;
       
             when FINISHED =>
                if (reset_n = '0' or ready_out = '1') then
                    valid_out <= '0';
                    next_state <= RESET;
                else 
                    next_state <= FINISHED;
                end if;
                
             when others =>
                next_state <= RESET;    
        end case;
   end process;
   
   -- Updating state
   process (clk) 
   begin
        if rising_edge(clk) then
            current_state <= next_state;
        end if;
   end process;

end expFsmBehave;
