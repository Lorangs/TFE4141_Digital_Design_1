-------------------------------------------------------------------------  -------
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


entity exponentiation is
	generic (
		-- Users to add parameters here
		C_BLOCK_SIZE          : INTEGER := 256
	);
	port (
		-----------------------------------------------------------------------------
		-- Clocks and reset
		-----------------------------------------------------------------------------
		clk                    :  in STD_LOGIC;
		reset_neg              :  in STD_LOGIC;

		-----------------------------------------------------------------------------
		-- Slave msgin interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgin_valid             : in STD_LOGIC;
		-- Slave ready to accept a new message
		msgin_ready             : out STD_LOGIC;
		-- Message that will be sent out of the rsa_msgin module
		msgin_data              :  in STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgin_last              :  in STD_LOGIC;

		-----------------------------------------------------------------------------
		-- Master msgout interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgout_valid            : out STD_LOGIC;
		-- Slave ready to accept a new message
		msgout_ready            :  in STD_LOGIC;
		-- Message that will be sent out of the rsa_msgin module
		msgout_data             : out STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
		-- Indicates boundary of last packet
		msgout_last             : out STD_LOGIC;
 
		-----------------------------------------------------------------------------
		-- Interface to the register block
		-----------------------------------------------------------------------------
		key_e_d                 :  in STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
		key_n                   :  in STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 )
	);
end exponentiation;

architecture exponentiation_behave of exponentiation is
	-----------------------------------------
	-- R and P signals are defined as per the RSA algorithm in high-level description.
	-- R is the result accumulator, P is the base being exponentiated.
	-- See the datasheet for documentation. 
	----------------------------------------
	
	signal result_R			: STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
	signal result_P			: STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
	signal mult_R_next		: STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
	signal mult_P_next		: STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
	signal mult_e_d     	: STD_LOGIC;
	signal mult_valid_in    : STD_LOGIC;
	signal mult_ready_out   : STD_LOGIC;
	signal mult_valid_out   : STD_LOGIC;
	signal mult_ready_in    : STD_LOGIC;
	signal mult_reset_neg   : STD_LOGIC;

	signal key_e_d_reg    	: STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
	signal key_n_reg      	: STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
	signal msgin_data_reg 	: STD_LOGIC_VECTOR( C_BLOCK_SIZE - 1 downto 0 );
	signal msgin_last_reg 	: STD_LOGIC;

	signal current_state    : STD_LOGIC_VECTOR( 1 downto 0 );

begin
	----------------------------
	-- Register input signals. Can be opted out if register block is static.
	----------------------------
	Input_Reg : process (current_state, key_e_d, key_n, msgin_data, msgin_last, key_e_d_reg, key_n_reg, msgin_data_reg, msgin_last_reg)
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
	-- Port data to output when in FINISHED state
	------------------------------
	port_data_out : process (current_state, mult_R_next, msgin_last_reg)
	begin
		case current_state is
			when "11" =>  -- FINISHED
				msgout_data <= mult_R_next;
				msgout_last <= msgin_last_reg;
			
			when others =>
				msgout_data <= (others => '0');
				msgout_last <= msgin_last_reg;
		end case;
	end process;


	----------------------------------
	-- Update mult_R_next and mult_P_next when finished a computation
	----------------------------------
	update_mult_inputs : process (current_state, mult_valid_out, result_R, result_P, msgin_data_reg, mult_R_next, mult_P_next)
	begin
		case current_state is
			when "00" =>  -- LOAD_NEW_MSG
				mult_R_next <= ( 0 => '1', others => '0' );  -- Initialize R to 1
				mult_P_next <= msgin_data_reg;				 -- Load new message into P

			when "10" =>  -- COUNT_FIN_PARTIAL
				mult_R_next <= result_R;
				mult_P_next <= result_P;

			when others => -- COUNT_WAIT, FINISHED
				mult_R_next <= mult_R_next;
				mult_P_next <= mult_P_next;
			
		end case;
	end process;


	-----------------------------------------------------------------------------
	-- mult_with_mod module instantiation
	-----------------------------------------------------------------------------
	i_mult_with_mod : entity work.mult_with_mod
		generic map (
			C_BLOCK_SIZE => C_BLOCK_SIZE
		)
		port map (	
			-- handshaking signals
			valid_in       	=> mult_valid_in,
			ready_out      	=> mult_ready_out,
			valid_out      	=> mult_valid_out,
			ready_in       	=> mult_ready_in,

			-- input data
			a			  	=> mult_P_next,
			b 			 	=> mult_R_next,
			c 			 	=> mult_P_next,
			e 				=> mult_e_d,

			--output data
			result_R		=> result_R,
			result_P		=> result_P,

			-- modulus
			n			  	=> key_n_reg,
			-- utility
			clk       		=> clk,
			reset_neg  		=> mult_reset_neg
		);


	-----------------------------------------------------------------------------
	-- FSM module instantiation
	-----------------------------------------------------------------------------
	rsa_core_fsm: entity work.exponentiation_fsm
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

			-- handshaking signals with Mult_with_mod module.
			mult_ready_in        => mult_ready_in,
			mult_valid_in        => mult_valid_in,
			mult_ready_out       => mult_ready_out,
			mult_valid_out       => mult_valid_out,
			mult_reset_neg       => mult_reset_neg,

			-- exponent bits
			key_e_d_reg         => key_e_d_reg,
			key_e_d_LSB         => mult_e_d,     
			
			current_state       => current_state
		);
end exponentiation_behave;
