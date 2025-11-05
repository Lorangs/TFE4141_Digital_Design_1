----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2025 16:56:07
-- Design Name: 
-- Module Name: calculations_tb - calc_tbBehave
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity calculations_tb is
    generic (
		C_block_size : integer := 256
	);
end calculations_tb;

architecture calc_tbBehave of calculations_tb is
    signal reset_n, clk, valid_out, mux_calculation : std_logic;
    signal  b, R_new               : std_logic_vector(C_block_size-1 downto 0);
    signal  b_minus_n, b_minus_2n, n_neg, s0, s1, s2, s3, s4, s5 : std_logic_vector (C_block_size downto 0);
    constant clk_period : time := 5 ns;

    function is_all_zero(vec: std_logic_vector) return boolean is 
    begin   
        for i in vec'range loop
            if vec(i) = '1' then
                return false;
            end if;
        end loop;
        return true;
    end function is_all_zero;

begin

DUT : entity work.calculations  
    generic map ( 
        C_block_size => C_block_size
    )
    port map (
        b       => b,
        n_neg   => n_neg,
    
        clk     => clk,
        reset_n => reset_n,
        valid_out => valid_out,
        
        mux_calculation => mux_calculation,
    
        R_new   => R_new,
    
        s0      => s0,
        s1      => s1,
        s2      => s2,
        s3      => s3,
        s4      => s4,
        s5      => s5
    );
    
    
clk_process : process 
begin 
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;
end process;


test_process : process 
begin
    R_new       <= (others => '0');
    R_new(70)   <= '1';
    
    b       <= (others => '0');
    b(200)  <= '1';
    
    n_neg       <= (others => '0');
    n_neg(256)  <= '1'; -- makes it negative
    n_neg(50)   <= '1';
    
    mux_calculation <= '0';
    valid_out <= '0';
    
    reset_n <= '0';
    wait for clk_period; 
    
    assert is_all_zero(s0) report "s0 is not reset value when reset" severity error;
    assert s1 = '0' & b report "s1 is not reset value when reset" severity error;
    assert s2 = std_logic_vector(signed(b) + signed(n_neg)) report "s2 is not reset value when reset" severity error;
    assert s4 = std_logic_vector(signed(b) + shift_left(signed(n_neg), 1)) report "s4 is not reset value when reset" severity error;
    -- s3 and s5 are unknown values at this point and therefore not checked 

    wait for clk_period/2;
    reset_n <= '1'; -- turn off reset
    mux_calculation <= '1';
    
    b_minus_n <= std_logic_vector(signed(b) + signed(n_neg));
    b_minus_2n <= std_logic_vector(signed(b) + shift_left(signed(n_neg), 1));
    
    wait for clk_period;  -- Wait for R_temp to update
    
    -- -- Check outputs based on expected calculations
    assert s0 = std_logic_vector(shift_left(signed('0' & R_new), 1)) report "s0 incorrect" severity error;
    assert s1 = std_logic_vector(shift_left(signed('0' & R_new), 1) + signed(b)) report "s1 incorrect" severity error;
    assert s2 = std_logic_vector(shift_left(signed('0' & R_new), 1) + signed(n_neg)) report "s2 incorrect" severity error;
    assert s3 = std_logic_vector(shift_left(signed('0' & R_new), 1) + signed(b_minus_n)) report "s3 incorrect" severity error;
    assert s4 = std_logic_vector(shift_left(signed('0' & R_new), 1) + shift_left(signed(n_neg), 1)) report "s4 incorrect" severity error;
    assert s5 = std_logic_vector(shift_left(signed('0' & R_new), 1) + signed(b_minus_2n)) report "s5 incorrect" severity error;
    
    
    R_new <= s4(C_block_size-1 downto 0);
    
    wait for clk_period;
    
    -- -- Check outputs based on expected calculations
    assert s0 = std_logic_vector(shift_left(signed('0' & R_new), 1)) report "s0 incorrect" severity error;
    assert s1 = std_logic_vector(shift_left(signed('0' & R_new), 1) + signed(b)) report "s1 incorrect" severity error;
    assert s2 = std_logic_vector(shift_left(signed('0' & R_new), 1) + signed(n_neg)) report "s2 incorrect" severity error;
    assert s3 = std_logic_vector(shift_left(signed('0' & R_new), 1) + signed(b_minus_n)) report "s3 incorrect" severity error;
    assert s4 = std_logic_vector(shift_left(signed('0' & R_new), 1) + shift_left(signed(n_neg), 1)) report "s4 incorrect" severity error;
    assert s5 = std_logic_vector(shift_left(signed('0' & R_new), 1) + signed(b_minus_2n)) report "s5 incorrect" severity error;
    
    report "---- Test completed ----" severity note;
    wait;

end process;

end calc_tbBehave;
