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
		-- Internal signals for testing
		-----------------------------------------------------------------------------
		counter				  : inout std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		
		
		-- Control signals from FSM
		current_state			: inout std_logic_vector(1 downto 0);
		
		-- LOAD_NEW_MSG = 00, COUNT_WAIT = 01, COUNT_FIN_PARTIAL = 10, FINISHED = 11
		msgin_data_reg   : inout std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		result_R          : inout std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0')

	);
end rsa_core;

architecture rtl of rsa_core is
	-----------------------------------------
	-- R and P signals are defined as per the RSA algorithm in high-level description.
	-- R is the result accumulator, P is the base being exponentiated.
	-- See the datasheet for documentation. 
	----------------------------------------



		-- Exponentiation module signals
	signal exp_valid_out      : std_logic;
	signal exp_ready_in       : std_logic;
	signal exp_valid_in       : std_logic;
	signal exp_ready_out      : std_logic;
	signal exp_reset_neg      : std_logic;

	signal exp_R_next         : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
	signal exp_P_next         : std_logic_vector(C_BLOCK_SIZE-1 downto 0);
	signal exp_e_d            : std_logic;				-- exponent bit (LSB first)


	---- can be deleted when testing is done ----
	signal exp_counter			: std_logic_vector(C_BLOCK_SIZE-1 downto 0);
	signal exp_current_state	: std_logic_vector(1 downto 0);					-- RESET = 00, COUNTING = 01, FINISHED = 10, unused 11

		-- Intermediate and result of R and P. R is to be treated as the resulting ciphertext.
	signal result_P          : std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');

	-- Registers for storing input signals
	signal key_e_d_reg      : std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');
	signal key_n_reg        : std_logic_vector(C_BLOCK_SIZE-1 downto 0) := (others => '0');
	signal n_neg_reg        : std_logic_vector(C_BLOCK_SIZE downto 0);
	signal msgin_last_reg   : std_logic := '0';

begin
	----------------------------
	-- Register input signals. Can be opted out if register block is static.
	----------------------------
	Input_Reg : process (current_state, key_e_d, key_n, msgin_data, msgin_last)
	begin
		case current_state is
			when "00" =>  -- LOAD_NEW_MSG
				key_e_d_reg    <=  key_e_d;
				key_n_reg      <=  key_n;
				msgin_data_reg <=  msgin_data;
				msgin_last_reg <=  msgin_last;

			when others =>
				key_e_d_reg    <=  key_e_d_reg;
				key_n_reg      <=  key_n_reg;
				msgin_data_reg <=  msgin_data_reg;
				msgin_last_reg <=  msgin_last_reg;	
		end case;
	end process;


	------------------------------
	-- Propagate msgin_last value to msgout_last
	------------------------------
	msgout_last <= msgin_last_reg;

	----------------------------
	-- Negate N. not a register, but relies on key_n_reg, which is a stored value.
	----------------------------
	n_neg_reg <= std_logic_vector( not unsigned( '0' & key_n_reg ) + 1 );


	------------------------------
	-- Port data to output when in FINISHED state
	------------------------------
	port_data_out : process (current_state, result_R)
	begin
		case current_state is
			when "11" =>  -- FINISHED
				msgout_data <= exp_R_next;
			
			when others =>
				msgout_data <= (others => '0');
		end case;
	end process;


	----------------------------------
	-- Update exp_R_next and exp_P_next when finished a computation
	----------------------------------
	update_exp_inputs : process (current_state, exp_valid_out, result_R, result_P, msgin_data_reg)
	begin
		case current_state is
			when "00" =>  -- LOAD_NEW_MSG
				exp_R_next <= ( 0 => '1', others => '0' );  -- Initialize R to 1
				exp_P_next <= msgin_data_reg;				-- Load new message into P

			when "10" =>  -- COUNT_FIN_PARTIAL
				exp_R_next <= result_R;
				exp_P_next <= result_P;

			when others => -- COUNT_WAIT, FINISHED
				exp_R_next <= exp_R_next;
				exp_P_next <= exp_P_next;
			
		end case;
	end process;



	-----------------------------------------------------------------------------
	-- Exponentiation module instantiation
	-----------------------------------------------------------------------------
	i_exponentiation : entity work.exponentiation
		generic map (
			C_block_size => C_BLOCK_SIZE
		)
		port map (	
			-- handshaking signals
			valid_in       	=> exp_valid_in,
			ready_out      	=> exp_ready_out,
			valid_out      	=> exp_valid_out,
			ready_in       	=> exp_ready_in,

			-- input data
			a			  	=> exp_P_next,
			b 			 	=> exp_R_next,
			c 			 	=> exp_P_next,
			e 				=> exp_e_d,

			--output data
			result_R		=> result_R,
			result_P		=> result_P,

			-- modulus
			n			  	=> key_n_reg,
			n_neg		  	=> n_neg_reg,	

			-- utility
			clk       		=> clk,
			reset_neg  		=> exp_reset_neg,

			-- Internal Signals for testing. Remove when done
			s0          	=> open,
			s1          	=> open,
			s2          	=> open,
			s3          	=> open,
			s4          	=> open,
			s5          	=> open,
			s6          	=> open,
			s7          	=> open,
			s8          	=> open,
			s9          	=> open,
			s10         	=> open,
			s11         	=> open,
			b_minus_n   	=> open,
			b_minus_2n  	=> open,
			c_minus_n   	=> open,
			c_minus_2n  	=> open,
			mux_ctrl_P_out 	=> open,
			mux_ctrl_R_out 	=> open,
			bit_shifted_a  	=> open,
			current_state  	=> exp_current_state,
			counter        	=> exp_counter
		);


	-----------------------------------------------------------------------------
	-- FSM module instantiation
	-----------------------------------------------------------------------------
	rsa_core_fsm: entity work.rsa_core_fsm
		generic map (
			C_BLOCK_SIZE => C_BLOCK_SIZE
		)
		port map (
			-- External Interface Signals
			clk                 => clk,
			reset_neg           => reset_neg,

			-- handshaking signals with external module.
			msgout_ready        => msgout_ready,
			msgout_valid        => msgout_valid,
			msgin_ready         => msgin_ready,
			msgin_valid         => msgin_valid,
			msgin_last          => msgin_last_reg,

			-- handshaking signals with exponentiation module.
			exp_ready_in        => exp_ready_in,
			exp_valid_in        => exp_valid_in,
			exp_ready_out       => exp_ready_out,
			exp_valid_out       => exp_valid_out,
			exp_reset_neg       => exp_reset_neg,

			-- RSA status signal
			rsa_status          => rsa_status,

			-- modulus 
			n                   => key_n_reg,  

			-- exponent bits
			key_e_d_reg         => key_e_d_reg,
			key_e_d_LSB         => exp_e_d,     
			
			current_state       => current_state,

			-- internal signals for testing
			counter             => counter
		);
end rtl;
