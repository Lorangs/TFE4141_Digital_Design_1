library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rsa_core is
	generic (
		C_BLOCK_SIZE          	: INTEGER := 256;
		NUM_CORES		   	    : INTEGER := 4
	);
	port (
		-----------------------------------------------------------------------------
		-- Clocks and reset
		-----------------------------------------------------------------------------
		clk                    	: in STD_LOGIC;
		reset_n              	: in STD_LOGIC;

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
		rsa_status              : out STD_LOGIC_VECTOR( 31 downto 0 )
	);
end rsa_core;

architecture rtl of rsa_core is
	
	-- Array types for connecting multiple cores
	type msg_data_array_t		is array (0 to NUM_CORES - 1) of STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
	type logic_array_t 			is array (0 to NUM_CORES - 1) of STD_LOGIC;
    type status_array_t 		is array (0 to NUM_CORES - 1) of STD_LOGIC_VECTOR( 31 downto 0 );

	-- Internal arrays to connect to multiple cores
	signal msgin_data_array    : msg_data_array_t;
	signal msgout_data_array   : msg_data_array_t;

	signal msgin_valid_array   : logic_array_t;
	signal msgout_valid_array  : logic_array_t;
	signal msgin_ready_array   : logic_array_t;
	signal msgout_ready_array  : logic_array_t; 
	signal msgin_last_array    : logic_array_t;
	signal msgout_last_array   : logic_array_t;
	signal rsa_status_array    : status_array_t;

	-- Queue management signals
	signal queue_head          : INTEGER range 0 to NUM_CORES - 1;
	signal queue_tail          : INTEGER range 0 to NUM_CORES - 1;
	signal queue_count         : INTEGER range 0 to NUM_CORES;
	signal queue_empty         : STD_LOGIC;
	signal queue_full          : STD_LOGIC;

begin
    --------------------------------------
    -- RSA Status Signal. Not used.
    --------------------------------------
    rsa_status <= (others => '0');

	-----------------------------------------------------------
	-- Combinational logic for queue status signals
	-----------------------------------------------------------
	queue_empty <= '1' when queue_count = 0 else '0';
	queue_full  <= '1' when queue_count = NUM_CORES else '0';

	----------------------------------------------------------
	-- Port mapping of top-level signals to core-specific signals
	----------------------------------------------------------
	msgout_ready_array 	<= (queue_head => msgout_ready, others => '0');
	msgin_valid_array 	<= (queue_tail => msgin_valid, 	others => '0');
	msgin_last_array 	<= (queue_tail => msgin_last, 	others => '0');
	msgin_data_array 	<= (queue_tail => msgin_data, 	others => (others => '0'));

	msgout_valid 		<= msgout_valid_array(queue_head) 	when reset_n = '1' else '0';
	msgout_last 		<= msgout_last_array(queue_head) 	when reset_n = '1' else '0';
	msgin_ready 		<= msgin_ready_array(queue_tail) 	when reset_n = '1' else '0';
	msgout_data 		<= msgout_data_array(queue_head) 	when reset_n = '1' else (others => '0');

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
				reset_neg           => reset_n,

				-- Slave msgin interface
				msgin_data          => msgin_data_array(i),
				msgin_valid         => msgin_valid_array(i),
				msgin_ready         => msgin_ready_array(i),
				msgin_last          => msgin_last_array(i),
				
				-- Master msgout interface
				msgout_data         => msgout_data_array(i),
				msgout_valid        => msgout_valid_array(i),
				msgout_ready        => msgout_ready_array(i),
				msgout_last         => msgout_last_array(i),
				
				-- Interface to the register block. Key_n and key_e_d are the same for all cores.
				key_e_d             => key_e_d,
				key_n               => key_n
			);
		
	end generate gen_exponentiation_cores;


	----------------------------------------------------------
	-- Distribute incoming messages to available cores
	----------------------------------------------------------
	message_management: process(clk, reset_n)
	begin

		-- Asynchronous reset
		if reset_n = '0' then
			queue_head 			<= 0;
			queue_tail 			<= 0;
			queue_count 		<= 0;
		

		-- Synchronous operations
		elsif rising_edge(clk) then

			-- Distribute incoming message to available cores
			if msgin_ready_array( queue_tail ) = '1' and queue_full = '0'then

				-- enqueue core into queue (FIFO)
				if msgin_valid = '1' then
					queue_tail <= ( queue_tail + 1 ) mod NUM_CORES;
					queue_count <= queue_count + 1;

				end if;
			end if;	
				
			-- Manage outgoing messages from cores in order
			if msgout_valid_array( queue_head ) = '1' and queue_empty = '0' then			

				-- Dequeue core from queue (FIFO)
				if msgout_ready = '1' then
					queue_count <= queue_count - 1;
					queue_head <= ( queue_head + 1 ) mod NUM_CORES;

				end if;
			end if;
		end if;
	end process message_management;
end rtl;
