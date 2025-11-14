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
entity rsa_core is
	generic (
		-- Users to add parameters here
		C_BLOCK_SIZE          	: INTEGER := 256;
		NUM_CORES		   	    : INTEGER := 2;
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
		rsa_status              : out STD_LOGIC_VECTOR( 31 downto 0 )
	);
end rsa_core;

architecture rtl of rsa_core is
	
	-- Array types for connecting multiple cores
	type msgin_data_array	is array (0 to NUM_CORES - 1) of STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
	type control_signal_array	is array (0 to NUM_CORES - 1) of STD_LOGIC;
	type rsa_status_array		is array (0 to NUM_CORES - 1) of STD_LOGIC_VECTOR( 31 downto 0 );

	-- Signals for connecting multiple cores
	signal msgin_data_array		: msgin_data_array;
	signal msgout_data_array	: msgin_data_array;
	signal key_e_d_array		: msgin_data_array;
	signal key_n_array			: msgin_data_array;
	signal msgin_valid_array	: control_signal_array;
	signal msgin_ready_array	: control_signal_array;
	signal msgin_last_array		: control_signal_array;
	signal msgout_valid_array	: control_signal_array;
	signal msgout_ready_array	: control_signal_array;
	signal msgout_last_array	: control_signal_array;
	signal rsa_status_array		: rsa_status_array;

begin

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
				key_e_d             => key_e_d_array(i),
				key_n               => key_n_array(i),
				rsa_status          => rsa_status_array(i)
			);
	end generate gen_exponentiation_cores;

	
end rtl;
