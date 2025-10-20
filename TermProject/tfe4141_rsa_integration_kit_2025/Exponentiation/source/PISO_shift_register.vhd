----------------------------------------------------------------------------------
-- Company:     NTNU, Norwegian University of Technology and Science
-- Engineer:    Lorang Strand
-- 
-- Create Date: 15.10.2025 15:27:47
-- Design Name: PISO shift register
-- Module Name: PISO_shift_register - PISOBehave
-- Project Name: RSA Accelerator
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--            Parallel In Serial Out shift register. The MSB of the input data is output to
--            the mux control output. On each clock cycle the data is shifted left by one bit
--            until all bits have been shifted out.

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity PISO_shift_register is
    ----------------------------------
    -- Generic Declarations
    ----------------------------------
    generic (
        C_BLOCK_SIZE : integer := 256
    );
    ----------------------------------
    -- Port Declarations
    ----------------------------------
    Port ( 
        a            : in STD_LOGIC_VECTOR (C_BLOCK_SIZE-1 downto 0);   -- a is the input data
        reset_n      : in STD_LOGIC;                                    -- Active high reset
        clk          : in STD_LOGIC;                                    -- Clock
        mux_control  : out STD_LOGIC                                    -- Output to for mux control (MSB of a_reg)
    );
end PISO_shift_register;

--------------------------------
-- Architecture Declaration
--------------------------------
architecture Behavioral of PISO_shift_register is
    ----------------------------------
    -- Signal Declarations
    ----------------------------------
    signal a_reg : STD_LOGIC_VECTOR (C_BLOCK_SIZE-1 downto 0); 
begin
    process (clk, reset_n, a)
    begin
        if (rising_edge(clk)) then
            if (reset_n = '1') then
                a_reg <= STD_LOGIC_VECTOR(shift_left(unsigned(a_reg), 1));  -- Shift left by 1 bit
             else
                a_reg <= a; 
             end if;
        end if;
    end process;
    mux_control <= a_reg(255); -- MSB of a is output to mux control. Hold value at all times (Asynchrone).
end Behavioral;
