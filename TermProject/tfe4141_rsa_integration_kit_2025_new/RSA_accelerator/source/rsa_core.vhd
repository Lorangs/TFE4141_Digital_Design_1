--------------------------------------------------------------------------------
-- Author       : Oystein Gjermundnes
-- Organization : Norwegian University of Science and Technology (NTNU)
--                Department of Electronic Systems
--                https://www.ntnu.edu/ies
-- Course       : TFE4141 Design of digital systems 1 (DDS1)
-- Year         : 2018-2019
-- Project      : RSA accelerator
-- License      : This is free and unencumbered software released into the
--                public domain (UNLICENSE)
--------------------------------------------------------------------------------
-- Purpose:
--   RSA encryption core template. This core currently computes
--   C = M xor key_n
--
--   Replace/change this module so that it implements the function
--   C = M**key_e mod key_n.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.rsa_core_types.all;

entity rsa_core is
	generic (
		-- Users to add parameters here
		C_BLOCK_SIZE          	: INTEGER := 256;
		NUM_CORES		   	    : INTEGER := 2
	);
	
	port (
		-----------------------------------------------------------------------------
		-- Clocks and reset
		-----------------------------------------------------------------------------
		clk                    	: in STD_LOGIC;
		reset_neg              	: in STD_LOGIC;

		-----------------------------------------------------------------------------
		-- Slave msgin interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgin_valid             : in STD_LOGIC;
		-- Slave ready to accept a new message
		msgin_ready             : out STD_LOGIC;
		-- Message that will be sent out of the rsa_msgin module
		msgin_data              : in STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
		-- Indicates boundary of last packet
		msgin_last              : in STD_LOGIC;

		-----------------------------------------------------------------------------
		-- Master msgout interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgout_valid            : out STD_LOGIC;
		-- Slave ready to accept a new message
		msgout_ready            : in STD_LOGIC;
		-- Message that will be sent out of the rsa_msgin module
		msgout_data             : out STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
		-- Indicates boundary of last packet
		msgout_last             : out STD_LOGIC;

		-----------------------------------------------------------------------------
		-- Interface to the register block
		-----------------------------------------------------------------------------
		key_e_d                 : in STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
		key_n                   : in STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
		rsa_status              : out STD_LOGIC_VECTOR( 31 downto 0 );


		-----------------------------------------------------------------------------
		-- Internal signals for testing. Can be moved to signal interface when testing is done.
		-----------------------------------------------------------------------------
		queue_empty		: inout std_logic;
		queue_full		: inout std_logic;
		queue_tail		: inout integer range 0 to NUM_CORES - 1;
		queue_head		: inout integer range 0 to NUM_CORES - 1;


		-- msgin_valid_array   : out control_signal_array_t(0 to NUM_CORES - 1);
		-- msgin_ready_array 	: in control_signal_array_t(0 to NUM_CORES - 1);
		-- msgout_valid_array	: in control_signal_array_t(0 to NUM_CORES - 1);
		-- msgout_ready_array  : out control_signal_array_t(0 to NUM_CORES - 1);

		exp_current_state 	: inout state_array_t(0 to NUM_CORES - 1)

	);
end rsa_core;

architecture rtl of rsa_core is
	
	-- Array types for connecting multiple cores
	type msg_data_array_t		is array (0 to NUM_CORES - 1) of STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
	
	-- Signals for connecting multiple cores
	signal msgin_data_array		: msg_data_array_t;
	signal msgout_data_array	: msg_data_array_t;
	signal msgin_valid_array	: control_signal_array_t(0 to NUM_CORES - 1);
	signal msgin_ready_array	: control_signal_array_t(0 to NUM_CORES - 1);
	signal msgin_last_array		: control_signal_array_t(0 to NUM_CORES - 1);
	signal msgout_valid_array	: control_signal_array_t(0 to NUM_CORES - 1);
	signal msgout_ready_array	: control_signal_array_t(0 to NUM_CORES - 1);
	signal msgout_last_array	: control_signal_array_t(0 to NUM_CORES - 1);

	
	-- Signals for queue used to distributing messages to cores
	-- signal queue_empty		: std_logic := '1';
	-- signal queue_full		: std_logic := '0';
	-- signal queue_head		: integer range 0 to NUM_CORES - 1 := 0;
	-- signal queue_tail		: integer range 0 to NUM_CORES - 1 := 0;



begin
	
	queue_empty <= '1' when (queue_head = queue_tail) else '0';
	queue_full <= '1' when (queue_head = (queue_tail + 1) mod NUM_CORES) else '0';


	----------------------------------------------------------
	-- Generate NUM_CORES instances of exponentiation module
	----------------------------------------------------------
	gen_exponentiation_cores: for i in 0 to NUM_CORES - 1 generate
		exponentiation_inst: entity work.exponentiation
			generic map (
				C_BLOCK_SIZE    => C_BLOCK_SIZE
			)
			port map (
				-- Clocks and reset
				clk                 => clk,
				reset_neg           => reset_neg,

				-- Slave msgin interface
				msgin_valid         => msgin_valid_array(i),
				msgin_ready         => msgin_ready_array(i),
				msgin_data          => msgin_data_array(i),
				msgin_last          => msgin_last_array(i),

				-- Master msgout interface
				msgout_valid        => msgout_valid_array(i),
				msgout_ready        => msgout_ready_array(i),
				msgout_data         => msgout_data_array(i),
				msgout_last         => msgout_last_array(i),

				-- Interface to the register block
				key_e_d             => key_e_d,
				key_n               => key_n,

				rsa_status          => rsa_status,

				current_state      => exp_current_state(i)
			);
	end generate gen_exponentiation_cores;


	----------------------------------------------------------
	-- Controlling delegating messages to the cores
	-----------------------------------------------------------
	sendMsgsToCores: process(clk, reset_neg, msgin_ready_array, msgout_valid_array)
	begin
		if reset_neg = '0' then 
			queue_tail <= 0;
			msgin_ready <= '0';

			msgin_valid_array <= (others => '0');
			msgin_data_array <= (others => (others => '0'));
			msgin_last_array <= (others => '0');

		else
			if rising_edge(clk) then
				-- Default: clear all valid signals
				msgin_valid_array <= (others => '0');

				msgin_ready <= not queue_full;

				-- Ready to accept new message if queue is not full and msgin_valid is high
				if msgin_valid = '1' and queue_full = '0' then
					-- Send message to core at queue_head
					msgin_data_array(queue_tail) <= msgin_data;
					msgin_valid_array(queue_tail) <= '1';
					msgin_last_array(queue_tail) <= msgin_last;
					
					-- Enqueue the message
					queue_tail <= (queue_tail + 1) mod NUM_CORES;
				end if;
			end if;
		end if;
	end process sendMsgsToCores;

	----------------------------------------------------------
	-- Controlling routing finished results from core to output
	-----------------------------------------------------------
	routeFinishedMsg: process(clk, reset_neg, msgout_valid_array, msgout_ready, msgout_data_array, msgout_last_array, queue_head, queue_empty)
	begin	
		if reset_neg = '0' then 
			queue_head <= 0;
			msgout_valid <= '0';
			msgout_last <= '0';
			msgout_data <= (others => '0');
			msgout_ready_array <= (others => '0');

		else
			if rising_edge(clk) then
				-- Default: clear all ready signals
				msgout_ready_array <= (others => '0');

				-- Check if we can output a message
				if queue_empty = '0' then
					msgout_ready_array(queue_head) <= msgout_ready;

					-- If the core has valid output, route it to msgout interface
					if msgout_valid_array(queue_head) = '1' then
						msgout_data <= msgout_data_array(queue_head);
						msgout_valid <= '1';
						msgout_last <= msgout_last_array(queue_head);

						-- check if outside is ready to accept the message, then dequeue
						if msgout_ready = '1' then
							queue_head <= (queue_head + 1) mod NUM_CORES;
						end if;
					else 
						msgout_valid <= '0';
					end if;	
				else
					msgout_valid <= '0';
				end if;			
			end if;
		end if;
	end process routeFinishedMsg;
end rtl;

