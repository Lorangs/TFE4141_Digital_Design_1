----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2025 15:27:47
-- Design Name: 
-- Module Name: calculations - calcBehave
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
use IEEE.NUMERIC_STD.ALL;



entity calculations is
    generic (
		C_block_size : integer := 256
	);
    Port ( 
        clk              : in     std_logic;
    
        b                : in     std_logic_vector( C_block_size-1 downto 0 );
        R_new            : in     std_logic_vector( C_block_size-1 downto 0 );
        n_neg            : in     std_logic_vector( C_block_size downto 0 );
        s0               : out    std_logic_vector( C_block_size downto 0 );
        s1               : out    std_logic_vector( C_block_size downto 0 );
        s2               : out  std_logic_vector( C_block_size downto 0 );
        s3               : out    std_logic_vector( C_block_size downto 0 );
        s4               : out  std_logic_vector( C_block_size downto 0 );
        s5               : out    std_logic_vector( C_block_size downto 0 );

        -- for testing purposes
        R_reg            : inout  std_logic_vector( C_block_size-1 downto 0 );
        b_minus_n        : inout  std_logic_vector( C_block_size downto 0 );
        b_minus_2n       : inout  std_logic_vector( C_block_size downto 0);

        -- States encoded as 2-bit std_logic_vector
        -- 00 = RESET, 01 = COUNTING, 10 = FINISHED, 11 = UNUSED
        current_state_global : in std_logic_vector(1 downto 0)
    );
end calculations;

architecture calcBehave of calculations is
    --signal R_reg : std_logic_vector( C_block_size-1 downto 0 );
    --signal 
    --    b_minus_n,
    --    b_minus_2n
    --: std_logic_vector( C_block_size downto 0 );
begin

    ---------------------------------------
    -- R_reg register
    ---------------------------------------
    Sync_R_reg: process (clk, current_state_global, R_new) 
    begin
        if rising_edge(clk) then
            case current_state_global is
                when "00" =>  -- RESET
                    R_reg <= (others => '0');

                when "01" =>  -- COUNTING
                    R_reg <= std_logic_vector(shift_left(signed(R_new), 1));
              
                when others =>  -- FINISHED or UNUSED
                    R_reg <= R_reg;
            end case;
        end if;
    end process;


    ---------------------------------------
    -- b-n register
    ---------------------------------------
    Sync_b_minus_n:process (clk, current_state_global, b, n_neg) 
    begin
        if rising_edge(clk) then
            case current_state_global is
                when "00" =>  -- RESET
                    b_minus_n <= std_logic_vector(signed('0' & b) + signed(n_neg));

                when "01" =>  -- COUNTING
                    b_minus_n <= b_minus_n; 
              
                when others =>  -- FINISHED or UNUSED
                    b_minus_n <= ( others => '0' );

            end case;
        end if;
    end process;    


    ---------------------------------------
    -- b-2n register
    ---------------------------------------
    Sync_b_minus_2n: process (clk, current_state_global, b, n_neg)
    begin 
        if rising_edge(clk) then
            case current_state_global is
                when "00" =>  -- RESET
                    b_minus_2n <= std_logic_vector(signed('0' & b) + shift_left(signed(n_neg), 1));
                
                when "01" =>  -- COUNTING
                    b_minus_2n <= b_minus_2n;
                
                when others =>  -- FINISHED or UNUSED
                    b_minus_2n <= ( others => '0' );
            
            end case;
        end if;
    end process; 


    ---------------------------------------
    -- Calculations
    ---------------------------------------
    s0 <= '0' & R_reg;
    s1 <= std_logic_vector( signed('0' & R_reg) + signed('0' & b) );
    s2 <= std_logic_vector( signed('0' & R_reg) + signed(n_neg) );
    s3 <= std_logic_vector( signed('0' & R_reg) + signed(b_minus_n) );
    s4 <= std_logic_vector( signed('0' & R_reg) + shift_left(signed(n_neg), 1) );
    s5 <= std_logic_vector( signed('0' & R_reg) + signed(b_minus_2n) );
    

end calcBehave;
