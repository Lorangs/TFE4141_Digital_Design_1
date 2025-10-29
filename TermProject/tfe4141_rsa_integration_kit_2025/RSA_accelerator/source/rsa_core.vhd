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
		C_BLOCK_SIZE          : integer := 256
	);
	port (
		-----------------------------------------------------------------------------
		-- Clocks and reset
		-----------------------------------------------------------------------------
		clk                    :  in std_logic;
		reset_n                :  in std_logic;

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
		rsa_status              : out std_logic_vector(31 downto 0)

	);
end rsa_core;

architecture rtl of rsa_core is
signal 	n_neg : std_logic_vector(C_BLOCK_SIZE downto 0);
signal 	P_current, 
		P_next, 
		R_current, 
		R_next, 
		e_current, 
		e_next 
	: std_logic_vector(C_BLOCK_SIZE-1 downto 0);
signal 	exp_valid_out, 
		exp_valid_in, 
		exp_ready_in, 
		exp_ready_out, 
		exp_new_msg_neg
	 : std_logic;

begin

	Negate_N : process (key_n, reset_n)
	begin
		if reset_n = '0' then
			n_neg <= (others => '0');
		else
			n_neg <= std_logic_vector( Signed (( not key_n) + 1));
		end if;
	end process;

	Sync_P_R_e : process (clk, reset_n, P_next, R_next)
	begin
		if rising_edge(clk) then
			if reset_n = '0' then
				P_current <= (others => '0');
				R_current <= (others => '0');
			elsif (exp_valid_out = '1') then
				if exp_new_msg_neg = '1' then
					P_current <= msgin_data;
					R_current <= (0 => '1', others => '0');		-- LSB set to 1
				else
                    P_current <= P_next;
                    R_current <= R_next;
				end if;
			end if;
		end if;
	end process;

	Sync_e : process (clk, reset_n, key_e_d)
	begin
		if rising_edge(clk) then
			if reset_n = '0' then
				e_current <= (others => '0');
			end if;
	    end if;
	end process;		
	-----------------------------------------------------------------------------
	-- Exponentiation module instantiation
	-----------------------------------------------------------------------------
	i_exponentiation : entity work.exponentiation
		generic map (
			C_block_size => C_BLOCK_SIZE
		)
		port map (
			clk		 	=> clk,
			reset_n     => exp_new_msg_neg,
			n           => key_n,
			n_neg	    => n_neg,
			a           => P_current,
			b           => P_current,
			c 		 	=> R_current,	
			valid_in    => exp_valid_in,
			ready_out   => exp_ready_out,
			valid_out   => exp_valid_out,
			ready_in    => exp_ready_in,
			result_P    => P_next,
			result_R    => R_next
		);

	-----------------------------------------------------------------------------
	-- FSM module instantiation
	-----------------------------------------------------------------------------
	rsa_core_fsm: entity work.rsa_core_fsm
		generic map (
			C_BLOCK_SIZE => C_BLOCK_SIZE
		)
		port map (
			clk            => clk,
			reset_n        => reset_n,
			msgin_valid    => msgin_valid,
			msgin_last     => msgin_last,
			msgout_ready   => msgout_ready,
			msgin_ready    => msgin_ready,
			msgout_valid   => msgout_valid,
			msgout_last    => msgout_last,
			rsa_status     => rsa_status,
			valid_out      => msgout_valid,
			ready_in       => msgin_ready,
			valid_in       => msgin_valid,
			ready_out      => exp_ready_out,
			new_msg_neg    => open
		);
end rtl;
