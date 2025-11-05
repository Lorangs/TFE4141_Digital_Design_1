----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.10.2025 15:55:38
-- Design Name: 
-- Module Name: rsa_core_fsm_tb - rsa_core_fsm_tbBehave
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

entity rsa_core_fsm_tb is
    generic (
        C_block_size : integer := 256
    );
end rsa_core_fsm_tb;

architecture rsa_core_fsm_tbBehave of rsa_core_fsm_tb is
    signal  clk,
            reset_n,    
            msgin_valid, 
            msgin_last,  
            msgin_ready, 
            msgout_ready, 
            msgout_valid, 
            msgout_last,  
            valid_out,  
            valid_in,   
            ready_in, 
            ready_out,
            new_msg_neg,
            update_R_or_not
        : std_logic := '0';

    signal  key_e_d
        : std_logic_vector(C_block_size-1 downto 0) := (others => '0');

    signal counter      
        : std_logic_vector(9 downto 0) := (others => '0');

    signal rsa_status
        : std_logic_vector(31 downto 0) := (others => '0');

    constant clk_period 
        : time := 5 ns;


begin

    -------------------------------
    -- Instantiate the Device Under Test (DUT)
    -------------------------------
DUT: entity work.rsa_core_fsm 
    generic map (
        C_block_size => C_block_size
    )
    port map (
        clk             => clk,
        reset_n         => reset_n,
        msgin_valid     => msgin_valid,
        msgin_last      => msgin_last,
        msgout_ready    => msgout_ready,
        msgin_ready     => msgin_ready,
        msgout_valid    => msgout_valid,
        msgout_last     => msgout_last,
        rsa_status      => rsa_status,
        key_e_d         => key_e_d,
        valid_out       => valid_out,
        ready_in        => ready_in,
        valid_in        => valid_in,
        ready_out       => ready_out,
        new_msg_neg     => new_msg_neg,
        update_R_or_not => update_R_or_not
    );

    ----------------------------
    -- Clock Generation
    ----------------------------
    clk_process : process 
    begin 
        clk <= '1';
        wait for clk_period / 2;
        clk <= '0';
        wait for clk_period / 2;
    end process;

    ----------------------------
    -- Test Process
    ----------------------------
    test_process: process 
    begin
       -- Initialize signals
        reset_n      <= '0';
        msgin_valid  <= '0';
        msgout_ready <= '0';
        msgin_last   <= '0';
        valid_out    <= '0';
        ready_in     <= '0';
        key_e_d      <= x"0000000000000000000000000000000000000000000000000000000000000005"; -- Test with exponent 5

        wait for clk_period * 2;

        -- Release reset
        reset_n <= '1';

        wait for clk_period * 2;

        -- Test Case 1: Load new message
        report "Starting Test Case 1: Load New Message";
        msgin_valid <= '1';
        msgin_last  <= '1';
        ready_in    <= '1';
        
        wait for clk_period;
        
        -- Check if FSM moves to COUNT_WAIT state
        assert msgin_ready = '1' report "msgin_ready should be high in LOAD_NEW_MSG state" severity error;
        
        msgin_valid <= '0';
        ready_in    <= '0';
        
        wait for clk_period * 2;
        
        -- Test Case 2: Simulate computation cycles
        report "Starting Test Case 2: Computation Cycles";
       
        -- Simulate multiple computation cycles
        for i in 0 to 10 loop
            -- Simulate valid_out assertion from computation block
            valid_out <= '1';
            wait for clk_period;
            
            -- Check FSM is in COUNT_FIN_PARTIAL state
            assert msgout_valid = '0' report "msgout_valid should be low during computation" severity error;
            
            valid_out <= '0';
            ready_in  <= '1';
            wait for clk_period;
            
            ready_in <= '0';
            wait for clk_period * 2;
        end loop;
        
        -- Test Case 3: Complete computation (simulate reaching counter >= n)
        report "Starting Test Case 3: Complete Computation";
        
        -- Force the FSM to finish by simulating enough cycles
        -- The counter should reach C_block_size (256) to finish
        for i in 0 to 245 loop
            valid_out <= '1';
            wait for clk_period;
            valid_out <= '0';
            ready_in  <= '1';
             wait for clk_period;
            ready_in <= '0';
            wait for clk_period;
        end loop;
        
        -- Final cycle to reach FINISHED state
        valid_out <= '1';
        wait for clk_period;
        valid_out <= '0';
        ready_in  <= '1';
        wait for clk_period;
        ready_in <= '0';
        wait for clk_period * 5;
        
        -- Check if FSM is in FINISHED state
        assert msgout_valid = '1' report "msgout_valid should be high in FINISHED state" severity error;
        assert rsa_status = '0' report "rsa_status should be low in FINISHED state" severity error;
        
        -- Test Case 4: Output ready handshake
        report "Starting Test Case 4: Output Ready Handshake";
        msgout_ready <= '1';
        wait for clk_period;
        
        -- FSM should return to LOAD_NEW_MSG state
        msgout_ready <= '0';
        wait for clk_period * 2;
        
        -- Test Case 5: Test with different key
        report "Starting Test Case 5: Different Key Test";
        key_e_d <= x"0000000000000000000000000000000000000000000000000000000000000011"; -- Test with exponent 17
        
        msgin_valid <= '1';
        msgin_last  <= '0'; -- Test with msgin_last = '0'
        ready_in    <= '1';
        
        wait for clk_period;

        msgin_valid <= '0';
        ready_in    <= '0';
        
        -- Run a few computation cycles
        for i in 0 to 5 loop
            valid_out <= '1';
            wait for clk_period;
            valid_out <= '0';
            ready_in  <= '1';
            wait for clk_period;
            ready_in <= '0';
            wait for clk_period;
        end loop;
        
        -- Test Case 6: Reset during operation
        report "Starting Test Case 6: Reset During Operation";
        reset_n <= '0';
        wait for clk_period * 2;
        reset_n <= '1';
        wait for clk_period * 2;
        
        -- Verify FSM returns to initial state after reset
        assert msgin_ready = '1' report "FSM should return to LOAD_NEW_MSG after reset" severity error;
        
        wait for clk_period * 10;
        
        report "Testbench completed successfully";
        wait;
        
    end process;
end rsa_core_fsm_tbBehave;
