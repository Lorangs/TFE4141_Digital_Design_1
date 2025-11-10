---------------------------------------------
-- Entity Declaration

-- This module performs modular exponentiation using
-- the blakley method. It computes both R and P values
-- simultaneously to optimize performance.

-- Computes:
-- R = (a * b) mod n, if e == 1, else R = b
-- P = (a * c) mod n

-- The module assumes constant inputs during operation.
-- Do not change inputs until valid_out is high.


---------------------------------------------


library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity exponentiation is
	generic (
		C_block_size : integer := 256
	);
	port (
		--input controll
		valid_in	: in STD_LOGIC;
		ready_in	: out STD_LOGIC;

		--ouput controll
		ready_out	: in STD_LOGIC;
		valid_out	: out STD_LOGIC;

		--input data
		a           : in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
	    b           : in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
        c           : in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
		e 			: in std_logic;
		
		--output data
		result_R 	: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);
		result_P 	: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		--modulus
		n           : in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
		n_neg       : in STD_LOGIC_VECTOR ( C_block_size downto 0 );
         
		--utility
		clk 		: in STD_LOGIC;
		reset_neg 	: in STD_LOGIC;
		
		--internal signals available for testing
		s0          : inout std_logic_vector( C_block_size downto 0 );
        s1          : inout std_logic_vector( C_block_size downto 0 );
        s2          : inout std_logic_vector( C_block_size downto 0 );
        s3          : inout std_logic_vector( C_block_size downto 0 );
        s4          : inout std_logic_vector( C_block_size downto 0 );
        s5          : inout std_logic_vector( C_block_size downto 0 );
        s6          : inout std_logic_vector( C_block_size downto 0 );
        s7          : inout std_logic_vector( C_block_size downto 0 );
        s8          : inout std_logic_vector( C_block_size downto 0 );
        s9          : inout std_logic_vector( C_block_size downto 0 );
        s10         : inout std_logic_vector( C_block_size downto 0 );
        s11         : inout std_logic_vector( C_block_size downto 0 );

		mux_ctrl_P_out : inout std_logic_vector(2 downto 0);
		mux_ctrl_R_out : inout std_logic_vector(2 downto 0);

		bit_shifted_a : inout std_logic_vector( C_block_size-1 downto 0 );

		current_state : inout std_logic_vector(1 downto 0);

		counter : inout std_logic_vector(C_block_size-1 downto 0);

		b_minus_n   : inout STD_LOGIC_VECTOR ( C_block_size downto 0 );
		b_minus_2n  : inout STD_LOGIC_VECTOR ( C_block_size downto 0 );
		c_minus_n   : inout STD_LOGIC_VECTOR ( C_block_size downto 0 );
		c_minus_2n  : inout STD_LOGIC_VECTOR ( C_block_size downto 0 )

	);
end exponentiation;


architecture expBehave of exponentiation is
	-------------------------------------------
	-- Signal Declarations
	-- 
	-- Add any internal signals here when testing is done
	-------------------------------------------

	signal bit_shifted_R 	: STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
	signal bit_shifted_P 	: STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
	signal n_2_neg			: STD_LOGIC_VECTOR ( C_block_size downto 0 );
begin

	-------------------------------------------
	-- Shifted versions of R, P, and n_neg
	-------------------------------------------
	bit_shifted_R 	<= std_logic_vector( shift_left( unsigned( result_R ), 1) );
	bit_shifted_P 	<= std_logic_vector( shift_left( unsigned( result_P ), 1) );
	n_2_neg 		<= std_logic_vector( shift_left( signed( n_neg ), 1) );

    -------------------------------------------
    -- Calculate summations for R
    -------------------------------------------
    s0  <= std_logic_vector( 		 '0' & bit_shifted_R );
    s1  <= std_logic_vector( signed( '0' & bit_shifted_R ) + signed( '0' & b ) );
    s2  <= std_logic_vector( signed( '0' & bit_shifted_R ) + signed( n_neg ) );
    s3  <= std_logic_vector( signed( '0' & bit_shifted_R ) + signed( b_minus_n ) ); 
    s4  <= std_logic_vector( signed( '0' & bit_shifted_R ) + signed( n_2_neg ) );
    s5  <= std_logic_vector( signed( '0' & bit_shifted_R ) + signed( b_minus_2n ) );

    -------------------------------------------
    -- Calculate summations for P
    -------------------------------------------
    s6  <= std_logic_vector( 		 '0' & bit_shifted_P );
    s7  <= std_logic_vector( signed( '0' & bit_shifted_P ) + signed( '0' & c ) );
    s8  <= std_logic_vector( signed( '0' & bit_shifted_P ) + signed( n_neg ) );
    s9  <= std_logic_vector( signed( '0' & bit_shifted_P ) + signed( c_minus_n ) );
    s10 <= std_logic_vector( signed( '0' & bit_shifted_P ) + signed( n_2_neg ) );
    s11 <= std_logic_vector( signed( '0' & bit_shifted_P ) + signed( c_minus_2n ) );



	-----------------------------------------
	-- Calculate b minus n and b minus 2n, c minus n and c minus 2n
	-- When in RESET state
	-----------------------------------------
	PreCalculations: process(current_state, b, c, n_2_neg, n_neg)
	begin
		if current_state = "00" then  -- RESET state
			b_minus_n   <= std_logic_vector( signed( '0' & b ) + signed( n_neg ) );
			b_minus_2n  <= std_logic_vector( signed( '0' & b ) + signed( n_2_neg ) );
			c_minus_n   <= std_logic_vector( signed( '0' & c ) + signed( n_neg ) );
			c_minus_2n  <= std_logic_vector( signed( '0' & c ) + signed( n_2_neg ) );
		else
			b_minus_n   <= b_minus_n;
			b_minus_2n  <= b_minus_2n;
			c_minus_n   <= c_minus_n;
			c_minus_2n  <= c_minus_2n;
		end if;
	end process;

	------------------------------------------
	-- FSM module instantiation
	------------------------------------------
	exp_fsm: entity work.exponentiation_fsm
		generic map (
			C_block_size => C_block_size
		)
		port map (
			reset_neg        			=> reset_neg,
			clk            			=> clk,
			n		      			=> n,
			a              			=> a,
			bit_shifted_a  			=> bit_shifted_a,
			ready_out      			=> ready_out,
			valid_in       			=> valid_in,
			ready_in       			=> ready_in,
			valid_out      			=> valid_out,
			mux_ctrl_R_in  			=> s5(C_block_size)  & s4(C_block_size)  & s3(C_block_size) & s2(C_block_size),		-- s5  sign bit, s4  sign bit, s3 sign bit, s2 sign bit
			mux_ctrl_P_in  			=> s11(C_block_size) & s10(C_block_size) & s9(C_block_size) & s8(C_block_size),		-- s11 sign bit, s10 sign bit, s9 sign bit, s8 sign bit
			mux_ctrl_R_out 			=> mux_ctrl_R_out,
			mux_ctrl_P_out 			=> mux_ctrl_P_out,
			current_state 			=> current_state,
			counter        			=> counter
		);
	

	------------------------------------------
	-- Output result selection process
	------------------------------------------
	exp_result: process(clk, e, mux_ctrl_P_out, mux_ctrl_R_out, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, current_state)
	begin
		if rising_edge(clk) then
			case current_state is 
				when "00" =>  -- RESET
					result_R <= (others => '0');
					result_P <= (others => '0');

				when "01" =>  -- COUNTING
					if e = '0' then
						result_R <= b;
					
					else
						case mux_ctrl_R_out is
							when "000" =>
								result_R <= s0(C_block_size-1 downto 0);
							when "001" => 	
								result_R <= s1(C_block_size-1 downto 0);
							when "010" =>	
								result_R <= s2(C_block_size-1 downto 0);
							when "011" =>	
								result_R <= s3(C_block_size-1 downto 0);
							when "100" =>	
								result_R <= s4(C_block_size-1 downto 0);
							when "101" =>
								result_R <= s5(C_block_size-1 downto 0);
							when others =>	-- should not occur
								result_R <= (others => '0');
						end case;
					end if;

					case mux_ctrl_P_out is
						when "000" =>
							result_P <= s6(C_block_size-1 downto 0);
						when "001" =>	
							result_P <= s7(C_block_size-1 downto 0);
						when "010" =>	
							result_P <= s8(C_block_size-1 downto 0);
						when "011" =>	
							result_P <= s9(C_block_size-1 downto 0);
						when "100" =>	
							result_P <= s10(C_block_size-1 downto 0);
						when "101" =>	
							result_P <= s11(C_block_size-1 downto 0);
						when others =>	-- should not occur
							result_P <= (others => '0');
					end case;
	
				when "10" =>  -- FINISHED, hold values 
					result_R <= result_R;
					result_P <= result_P;
				
				when others => -- UNUSED
					result_R <= (others => '0');
					result_P <= (others => '0');

			end case;
		end if;
	end process;	
end expBehave;
