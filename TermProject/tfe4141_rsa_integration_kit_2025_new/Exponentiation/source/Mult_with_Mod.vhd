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


entity mult_with_mod is
	generic (
		C_BLOCK_SIZE : INTEGER := 256
	);
	port (
		--input controll
		valid_in	: in STD_LOGIC;
		ready_in	: out STD_LOGIC;

		--ouput controll
		ready_out	: in STD_LOGIC;
		valid_out	: out STD_LOGIC;

		--input data
		a           : in STD_LOGIC_VECTOR ( C_BLOCK_SIZE-1 downto 0 );
	    b           : in STD_LOGIC_VECTOR ( C_BLOCK_SIZE-1 downto 0 );
        c           : in STD_LOGIC_VECTOR ( C_BLOCK_SIZE-1 downto 0 );
		e 			: in STD_LOGIC;
		
		--output data
		result_R 	: inout STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0);
		result_P 	: inout STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0);
		
		--modulus
		n		    : in STD_LOGIC_VECTOR ( C_BLOCK_SIZE - 1 downto 0 );	

		--utility
		clk 		: in STD_LOGIC;
		reset_neg 	: in STD_LOGIC;

		current_state : inout STD_LOGIC_VECTOR ( 1 downto 0 )
	);
end mult_with_mod;


architecture mult_behave of mult_with_mod is
	-------------------------------------------
	-- Signal Declarations
	-------------------------------------------
	
	signal  s0,
			s1,
			s2,
			s3,
			s4,
			s5,
			s6,
			s7,
			s8,
			s9,
			s10,
			s11
		: STD_LOGIC_VECTOR ( C_BLOCK_SIZE + 1 downto 0 );

	signal  bit_shifted_R,
			bit_shifted_P
		: STD_LOGIC_VECTOR ( C_BLOCK_SIZE downto 0 );

	signal  mux_ctrl_P_out,
			mux_ctrl_R_out
		: STD_LOGIC_VECTOR ( 2 downto 0 );

	signal	bit_shifted_n	: STD_LOGIC_VECTOR ( C_BLOCK_SIZE downto 0 );	-- modulus shifted left by 1 bit

begin
	------------------------------------------
	-- FSM module instantiation
	------------------------------------------
	mult_fsm: entity work.mult_with_mod_fsm
		generic map (
			C_BLOCK_SIZE => C_BLOCK_SIZE
		)
		port map (
			reset_neg        		=> reset_neg,
			clk            			=> clk,
			a              			=> a, 
			ready_out      			=> ready_out,
			valid_in       			=> valid_in,
			ready_in       			=> ready_in,
			valid_out      			=> valid_out,
			mux_ctrl_R_in  			=>  s5(C_BLOCK_SIZE+1) &  s4(C_BLOCK_SIZE+1) & s3(C_BLOCK_SIZE+1) & s2(C_BLOCK_SIZE+1),		-- s5  sign bit, s4  sign bit, s3 sign bit, s2 sign bit
			mux_ctrl_P_in  			=> s11(C_BLOCK_SIZE+1) & s10(C_BLOCK_SIZE+1) & s9(C_BLOCK_SIZE+1) & s8(C_BLOCK_SIZE+1),		-- s11 sign bit, s10 sign bit, s9 sign bit, s8 sign bit
			mux_ctrl_R_out 			=> mux_ctrl_R_out,
			mux_ctrl_P_out 			=> mux_ctrl_P_out,
			current_state 			=> current_state
		);
 

	-------------------------------------------
	-- Prepare shifted values for R and P calculations
	-------------------------------------------
	bit_shifted_R <= result_R & '0';
	bit_shifted_P <= result_P & '0';
	bit_shifted_n <= n & '0';

	-------------------------------------------
	-- Calculate summations for R
	-------------------------------------------
	s0  <= '0' & bit_shifted_R;
	s1  <= STD_LOGIC_VECTOR( unsigned( '0' & bit_shifted_R ) + unsigned( "00" & b ) );
	s2  <= STD_LOGIC_VECTOR( unsigned( '0' & bit_shifted_R ) - unsigned( "00" & n ) );  
	s3  <= STD_LOGIC_VECTOR( unsigned( '0' & bit_shifted_R ) + unsigned( "00" & b ) - unsigned( "00" & n ) ); 
	s4  <= STD_LOGIC_VECTOR( unsigned( "0" & bit_shifted_R ) - unsigned( '0' & bit_shifted_n ) );
	s5  <= STD_LOGIC_VECTOR( unsigned( "0" & bit_shifted_R ) + unsigned( "00" & b ) - unsigned( '0' & bit_shifted_n ) );

	-------------------------------------------
	-- Calculate summations for P
	-------------------------------------------
	s6  <= '0' & bit_shifted_P;
	s7  <= STD_LOGIC_VECTOR( unsigned( '0' & bit_shifted_P ) + unsigned( "00" & c ) );
	s8  <= STD_LOGIC_VECTOR( unsigned( '0' & bit_shifted_P ) - unsigned( "00" & n ) );
	s9  <= STD_LOGIC_VECTOR( unsigned( '0' & bit_shifted_P ) + unsigned( "00" & c ) - unsigned( "00" & n ) );
	s10 <= STD_LOGIC_VECTOR( unsigned( '0' & bit_shifted_P ) - unsigned( '0' & bit_shifted_n ) );
	s11 <= STD_LOGIC_VECTOR( unsigned( '0' & bit_shifted_P ) + unsigned( "00" & c ) - unsigned( '0' & bit_shifted_n ) );


	------------------------------------------
	-- Output result selection process
	------------------------------------------
	mult_result: process(clk)
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
								result_R <= s0(C_BLOCK_SIZE-1 downto 0);
							when "001" => 	
								result_R <= s1(C_BLOCK_SIZE-1 downto 0);
							when "010" =>	
								result_R <= s2(C_BLOCK_SIZE-1 downto 0);
							when "011" =>	
								result_R <= s3(C_BLOCK_SIZE-1 downto 0);
							when "100" =>	
								result_R <= s4(C_BLOCK_SIZE-1 downto 0);
							when "101" =>
								result_R <= s5(C_BLOCK_SIZE-1 downto 0);
							when others =>	-- should not occur
								result_R <= (others => '0');
						end case;
					end if;

					case mux_ctrl_P_out is
						when "000" =>
							result_P <= s6(C_BLOCK_SIZE-1 downto 0);
						when "001" =>	
							result_P <= s7(C_BLOCK_SIZE-1 downto 0);
						when "010" =>	
							result_P <= s8(C_BLOCK_SIZE-1 downto 0);
						when "011" =>	
							result_P <= s9(C_BLOCK_SIZE-1 downto 0);
						when "100" =>	
							result_P <= s10(C_BLOCK_SIZE-1 downto 0);
						when "101" =>	
							result_P <= s11(C_BLOCK_SIZE-1 downto 0);
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
end mult_behave;
