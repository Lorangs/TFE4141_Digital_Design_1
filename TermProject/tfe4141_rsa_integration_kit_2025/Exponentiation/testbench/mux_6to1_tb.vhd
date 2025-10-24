----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/15/2025 05:33:16 PM
-- Design Name: 
-- Module Name: mux_6to1_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_6to1_tb is
    generic(
		C_block_size : integer := 254;
        -- implimentasjon constraint, for testing av system må vi bruke 255 lines, som reusltat av 255 pins på brette.
        Read_out_signed_bit: integer := 254 

    );
end mux_6to1_tb;

architecture Behavioral_mux_6to1_tb of mux_6to1_tb is
        signal s0, s1 ,s2 ,s3 ,s4, s5, R_new: std_logic_vector(C_block_size downto 0);
        signal mux_control, clk : std_logic;
        constant clk_period : time := 5 ns; -- 10ns about 100Mhz 200Mhz 5ns     
begin

the_clock : process
begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
end process  the_clock;

DUT : entity work.mux_6to1  
    generic map ( 
        C_block_size => C_block_size
    )
    port map (
        s0 => s0,
        s1 => s1,
        s2 => s2,
        s3 => s3,
        s4 => s4,
        s5 => s5,
        R_new => R_new,
        mux_control => mux_control
    );

test_process_mux6to1 : process
begin

    -- first test check for when we have the situastion
    -- a  = 1
    -- b  = 3
    -- s0 = R        = 3
    -- s1 = R + b    = 6
    -- s2 = R - n    = -4
    -- s3 = R+b-n    = -1
    -- s4 = R+b-2n   = -8
    -- s5 = R+b-2n   = -9
    -- mux_control = 0

    s0      <= (others => '0');
    s0(0)   <= '1';
    s0(1)   <= '1';
    s1      <= (others => '0');
    s1(1)   <= '1';
    s1(2)   <= '1';
    s2      <= (others => '0');
    s2(Read_out_signed_bit) <= '1';
    s2(2)   <= '1';
    s3      <= (others => '0');
    s3(Read_out_signed_bit) <= '1';
    s3(0)   <= '1';
    s4      <= (others => '0');
    s4(Read_out_signed_bit) <= '1';
    s4(3)   <= '1';
    s5      <= (others => '0');
    s5(Read_out_signed_bit) <= '1';
    s5(3)   <= '1';
    s5(1)   <= '1';

    mux_control <= '0';
   
    wait for clk_period; 

    -- Check R_new matches the expected input selected by mux_control.
    if mux_control = '0' then
        assert R_new = s0 report "FAIL: R_new /= s0 when mux_control = '0'" severity error;
    else
        assert R_new = s1 report "FAIL: R_new /= s1 when mux_control = '1'" severity error;
    end if;
    wait for clk_period; 

    
    -- Second same as first test except mux_control = 1
    mux_control <= '1';
    

    wait for clk_period; 

    -- Check R_new matches the expected input selected by mux_control.
    if mux_control = '0' then
        assert R_new = s0 report "FAIL: R_new /= s0 when mux_control = '0'" severity error;
    else
        assert R_new = s1 report "FAIL: R_new /= s1 when mux_control = '1'" severity error;
    end if;

    wait for clk_period;
    -- Third test, her har jeg ikke sjekket om tallene er mulig.
    -- men tall typene er mulig, så sammetall så tidligere bare s2 og s3 er positive tall 
    -- rett svar her skal være s2 eller s3 kommer an på signal mux_control
    -- a  = 1
    -- b  = 3
    -- s0 = R        = 3
    -- s1 = R + b    = 6
    -- s2 = R - n    = 4
    -- s3 = R+b-n    = 1
    -- s4 = R+b-2n   = -8
    -- s5 = R+b-2n   = -8
    -- mux_control = 0

    s0      <= (others => '0');
    s0(0)   <= '1';
    s0(1)   <= '1';
    s1      <= (others => '0');
    s1(1)   <= '1';
    s1(2)   <= '1';
    s2      <= (others => '0');
    s2(2)   <= '1';
    s3      <= (others => '0');
    s3(0)   <= '1';
    s4      <= (others => '0');
    s4(Read_out_signed_bit) <= '1';
    s4(3)   <= '1';
    s5      <= (others => '0');
    s5(Read_out_signed_bit) <= '1';
    s5(3)   <= '1';
    s5(1)   <= '1';

    mux_control <= '0';

    wait for clk_period;

    -- Check R_new matches the expected input selected by mux_control.
    if mux_control = '0' then
        assert R_new = s2 report "FAIL: R_new /= s2 when mux_control = '0'" severity error;
    else
        assert R_new = s3 report "FAIL: R_new /= s3 when mux_control = '1'" severity error;
    end if;

    
    wait for clk_period;

    mux_control <= '1';

   wait for clk_period;
    -- Check R_new matches the expected input selected by mux_control.
    if mux_control = '0' then
        assert R_new = s2 report "FAIL: R_new /= s2 when mux_control = '0'" severity error;
    else
        assert R_new = s3 report "FAIL: R_new /= s3 when mux_control = '1'" severity error;
    end if;

    -- forth test sett her correct answer should be s4 or s5 is choosen based of mux_control
    -- I have not check if this is a possible combination of values, only checking for type.
    -- a  = 1
    -- b  = 3
    -- s0 = R        = 3
    -- s1 = R + b    = 6
    -- s2 = R - n    = 4
    -- s3 = R+b-n    = 1
    -- s4 = R+b-2n   = 8
    -- s5 = R+b-2n   = 9
    -- mux_control = 0

    s0      <= (others => '0');
    s0(0)   <= '1';
    s0(1)   <= '1';
    s1      <= (others => '0');
    s1(1)   <= '1';
    s1(2)   <= '1';
    s2      <= (others => '0');
    s2(2)   <= '1';
    s3      <= (others => '0');
    s3(0)   <= '1';
    s4      <= (others => '0');
    s4(3)   <= '1';
    s5      <= (others => '0');
    s5(3)   <= '1';
    s5(1)   <= '1';

    mux_control <= '0';

    wait for clk_period;

    -- Check R_new matches the expected input selected by mux_control.
    if mux_control = '0' then
        assert R_new = s4 report "FAIL: R_new /= s4 when mux_control = '0'" severity error;
    else
        assert R_new = s5 report "FAIL: R_new /= s5 when mux_control = '1'" severity error;
    end if;

    
    wait for clk_period;

    mux_control <= '1';

   wait for clk_period;
    -- Check R_new matches the expected input selected by mux_control.
    if mux_control = '0' then
        assert R_new = s4 report "FAIL: R_new /= s4 when mux_control = '0'" severity error;
    else
        assert R_new = s5 report "FAIL: R_new /= s5 when mux_control = '1'" severity error;
    end if;

    report "SIMULATION: All tests completed." severity note;
    wait;
end process;

end Behavioral_mux_6to1_tb;

