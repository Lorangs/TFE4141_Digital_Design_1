----------------------------------------------------------------------------------
-- Company:     NTNU, Norwegian University of Technology and Science
-- Engineer:    Lorang Strand
-- 
-- Create Date: 15.10.2025 15:27:47
-- Design Name: PISO shift register Testbench
-- Module Name: PISO_shift_register_tb
-- Project Name: RSA Accelerator
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--            Parallel In Serial Out shift register. The MSB of the input data is output to
--            the mux control output. On each clock cycle the data is shifted left by one bit
--            until all bits have been shifted out.
-- 
--           Testbench for PISO shift register
--           This testbench will test the PISO shift register by applying a known input
--           and checking the output on the mux control line.

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PISO_shift_register_tb is
    generic (
        C_BLOCK_SIZE : integer := 256
    );
end PISO_shift_register_tb;

architecture Behavioral of PISO_shift_register_tb is
    ----------------------------------
    -- Signal Declarations
    ----------------------------------
    signal a           : STD_LOGIC_VECTOR (C_BLOCK_SIZE-1 downto 0) := (others => '0');
    signal reset_n     : STD_LOGIC := '0';
    signal clk         : STD_LOGIC := '0';
    signal mux_control : STD_LOGIC;
begin
    -- Instantiate the Device Under Test (DUT)
    dut: entity work.PISO_shift_register
        generic map (
            C_BLOCK_SIZE => C_BLOCK_SIZE
        )
        port map (
            a           => a,
            reset_n     => reset_n,
            clk         => clk,
            mux_control => mux_control
        );


    ----------------------------------
    -- Clock generation. 
    -- Periode = 4 ns, thus frequency = 500 MHz
    ----------------------------------
    -- Unit under test is tested at a higher clock frequency than the rest of the design
    -- to ensure functionality at lower frequencies.
    clk <= not clk after 2 ns;

    -- Stimulus process
    stim_proc: process
    begin		
        -- hold reset state for 10 ns.
        reset_n <= '0';
        wait for 10 ns;	

        reset_n <= '1';
        wait for 10 ns;
        a <= X"8888888888888888888888888888888888888888888888888888888888888888";

        wait for 20 ns;

        -- set reset_n low again to load new data into the shift register
        reset_n <= '0';
        wait for 10 ns;
        reset_n <= '1';


        -- Shift out all bits
        for i in 0 to C_BLOCK_SIZE-1 loop
            wait for 4 ns;
            -- Only report error when MSB doesn't match the expected bit from original 'a'
            if (mux_control /= a(255 - i)) then
                assert false
                report "Test failed at bit position " & integer'image(i) & 
                       ": Expected " & std_logic'image(a(255 - i)) & 
                       ", Got " & std_logic'image(mux_control)
                severity error;
            end if;
        end loop;

        -- Finish simulation
        report "Test completed successfully" severity note;
        wait;
    end process;

end Behavioral;
