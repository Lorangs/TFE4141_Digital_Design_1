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
		rsa_status              :  out std_logic_vector(31 downto 0);


		-----------------------------------------------------------------------------
		-- Internal signals for testing. Can be moved to signal interface when testing is done.
		-----------------------------------------------------------------------------
		counter				  : inout std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		
		
		-- Control signals from FSM
		current_state			: inout std_logic_vector(1 downto 0);
		
		-- LOAD_NEW_MSG = 00, COUNT_WAIT = 01, COUNT_FIN_PARTIAL = 10, FINISHED = 11
		msgin_data_reg   : inout std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		
		-- Exponentiation module signals
		exp_valid_out      : inout std_logic;
		exp_ready_in       : inout std_logic;
		exp_valid_in       : inout std_logic;
		exp_ready_out      : inout std_logic;
		exp_reset_neg      : inout std_logic;

		exp_R_next         : inout std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		exp_P_next         : inout std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		exp_e_d            : inout std_logic;				-- exponent bit (LSB first)


		---- can be deleted when testing is done ----
		exp_counter			: inout std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		exp_current_state	: inout std_logic_vector(1 downto 0);					-- RESET = 00, COUNTING = 01, FINISHED = 10, unused 11

		-- Intermediate and result of R and P. R is to be treated as the resulting ciphertext.
		result_R          : inout std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');
		result_P          : inout std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');

		-- Registers for storing input signals
		key_e_d_reg      : inout std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');
		key_n_reg        : inout std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');
		n_neg_reg        : inout std_logic_vector(C_BLOCK_SIZE downto 0);
		msgin_last_reg   : inout std_logic := '0'

	);
end rsa_core;

architecture rtl of rsa_core is
	
begin

	i_exponentiation: entity work.exponentiation
		generic map (
			C_block_size => C_block_size
		)
		port map (
			clk			=> clk,
			reset_neg 	=> reset_neg,

			msgin_valid => msgin_valid,
			msgin_ready => msgin_ready,
			msgin_data	=> msgin_data,
			msgin_last	=> msgin_last,

			msgout_valid => msgout_valid,
			msgout_ready => msgout_ready,
			msgout_data => msgout_data,
			msgout_last => msgout_last,

			key_e_d		=> key_e_d,
			key_n		=> key_n,
			rsa_status	=> rsa_status
		);

	
end rtl;
