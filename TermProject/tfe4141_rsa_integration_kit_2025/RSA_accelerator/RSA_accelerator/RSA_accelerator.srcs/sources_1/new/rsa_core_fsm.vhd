----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/22/2025 06:00:20 PM
-- Design Name: 
-- Module Name: rsa_core_fsm - rsa_core_fsm_behave
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

entity rsa_core_fsm is
    generic (
        C_BLOCK_SIZE : integer := 256
    );

    Port ( 
        ------------------------------------
        -- External Interface Signals
        ------------------------------------
           clk              : in STD_LOGIC;
           reset_n          : in STD_LOGIC;
           msgin_valid      : in STD_LOGIC;
           msgin_last       : in STD_LOGIC;
           msgout_ready     : in STD_LOGIC;
           msgin_ready      : out STD_LOGIC;
           msgout_valid     : out STD_LOGIC;
           msgout_last      : out STD_LOGIC;
           rsa_status       : out STD_LOGIC;


        ------------------------------------
        -- Internal Interface Signals
        ------------------------------------
            valid_out         : in STD_LOGIC;
            ready_in          : in STD_LOGIC;
            valid_in          : out STD_LOGIC;
            ready_out         : out STD_LOGIC;
            load_output_value : out STD_LOGIC;
            new_msg           : out STD_LOGIC
        );
end rsa_core_fsm;

architecture rsa_core_fsm_behave of rsa_core_fsm is

    type state_type is (RESET, COUNTING, FINNISHED);
    signal current_state    : state_type                                    := RESET;
    signal next_state       : state_type                                    := RESET;
    signal count            : std_logic_vector(C_BLOCK_SIZE-1 downto 0)     := (others => '0');

begin

    process(clk, current_state, msgin_valid, msgin_last, msgout_ready)
    begin
        if rising_edge(clk) then
            case current_state is
                when RESET =>
                    rsa_status          <= '0';
                    msgout_last         <= msgin_last;
                    msgout_valid        <= '0';

                    load_output_value   <= '0';


                    if msgin_valid = '1' then
                        msgin_ready     <= '0';
                        valid_in        <= '1';
                        next_state      <= COUNTING;
                        
                    else
                        msgin_ready     <= '1';
                        valid_in        <= '0';
                        next_state      <= RESET;


                    end if;

                when COUNTING =>
                    if count = C_BLOCK_SIZE - 1 then
                        msgout_valid    <= '1';                 
                        count           <= (others => '0');     
                        next_state      <= FINNISHED;           
                    else 
                        msgout_valid    <= '0';
                        count           <= count + 1;   
                        next_state      <= COUNTING;

                        if valid_out = '1' and ready_in = '1' then
                            new_msg     <= '1';
                        else
                            new_msg     <= '0';
                        end if;
                    end if;

                when FINNISHED =>
                    load_output_value   <= '1';

                    if msgout_ready = '1' then
                        msgin_ready     <= '1';
                        next_state      <= RESET;
                    else
                        next_state      <= FINNISHED; 
                    end if;
            end case;

            current_state <= next_state;
        end if;
    end process;
end rsa_core_fsm_behave;
