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
		C_block_size          : integer := 256
	);
	port (
		-----------------------------------------------------------------------------
		-- Clocks and reset
		-----------------------------------------------------------------------------
		clk                    :  in std_logic;
		reset_neg              :  in std_logic;

		-----------------------------------------------------------------------------
		-- Slave msgin interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgin_valid             : in std_logic;
		-- Slave ready to accept a new message
		msgin_ready             : out std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgin_data              :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgin_last              :  in std_logic;

		-----------------------------------------------------------------------------
		-- Master msgout interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgout_valid            : out std_logic;
		-- Slave ready to accept a new message
		msgout_ready            :  in std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgout_data             : out std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgout_last             : out std_logic;

		-----------------------------------------------------------------------------
		-- Interface to the register block
		-----------------------------------------------------------------------------
		key_e_d                 :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		key_n                   :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		rsa_status              :  out std_logic_vector(31 downto 0)
	);
end rsa_core;

architecture rtl of rsa_core is
	
begin

	i_exponentiation: entity work.exponentiation
		generic map (
			C_block_size => C_block_size
		)
		port map (
			clk				=> clk,
			reset_neg 		=> reset_neg,
			msgin_valid 	=> msgin_valid,
			msgin_ready 	=> msgin_ready,
			msgin_data		=> msgin_data,
			msgin_last		=> msgin_last,
			msgout_valid	=> msgout_valid,
			msgout_ready	=> msgout_ready,
			msgout_data		=> msgout_data,
			msgout_last		=> msgout_last,
			key_e_d			=> key_e_d,
			key_n			=> key_n,
			rsa_status		=> rsa_status,

			-----------------------------------------------------------------------------
			-- Internal signals for testing. Can be moved to signal interface when testing is done.
			-----------------------------------------------------------------------------
			counter				=> open,
			current_state		=> open,
			msgin_data_reg		=> open,
			mult_valid_out		=> open,
			mult_ready_in		=> open,
			mult_valid_in		=> open,
			mult_ready_out		=> open,
			mult_reset_neg		=> open,
			mult_R_next			=> open,
			mult_P_next			=> open,
			mult_e_d			=> open,
			mult_counter		=> open,
			mult_current_state	=> open,
			result_R			=> open,
			result_P			=> open,
			key_e_d_reg			=> open,
			key_n_reg			=> open,
			n_neg_reg			=> open,
			msgin_last_reg		=> open
		);
end rtl;
