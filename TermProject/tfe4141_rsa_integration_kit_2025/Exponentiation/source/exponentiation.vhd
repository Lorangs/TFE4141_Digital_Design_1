library ieee;
use ieee.std_logic_1164.all;

entity exponentiation is
	generic (
		C_block_size : integer := 256
	);
	port (
		--input controll
		valid_in	: in STD_LOGIC;
		ready_in	: out STD_LOGIC;

		--input data
		a           : in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
	    b           : in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
        c           : in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
		
		--ouput controll
		ready_out	: in STD_LOGIC;
		valid_out	: out STD_LOGIC;

		--output data
		result_R 	: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);
		result_P 	: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		--modulus
		n           : in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
		n_neg       : in STD_LOGIC_VECTOR ( C_block_size downto 0 );
         
         
		--utility
		clk 		: in STD_LOGIC;
		reset_n 	: in STD_LOGIC;

		-- Internal Signal
		signal s0, s1 ,s2 ,s3 ,s4, s5, s6, s7, s8, s9, s10, s11: std_logic_vector( C_block_size downto 0 );
		signal mux_ctrl_P_out, mux_ctrl_R_out: std_logic_vector(2 downto 0)

	);
end exponentiation;


architecture expBehave of exponentiation is
begin
	-- R Calculations module instantiation
	calc_R: entity work.calculations	
		generic map (
			C_block_size => C_block_size
		)
		port map (
			b       => b,
			n_neg   => n_neg,
			clk     => clk,
			reset_n => reset_n,
			R_new   => result_R,
			s0      => s0,
			s1      => s1,
			s2      => s2,
			s3      => s3,
			s4      => s4,
			s5      => s5
		);

	-- P Calculations module instantiation
	calc_P: entity work.calculations	
		generic map (
			C_block_size => C_block_size
		)
		port map (
			b       => c,
			n_neg   => n_neg,
			clk		=> clk,
			reset_n => reset_n,
			R_new   => result_P,
			s0      => s6,
			s1      => s7,
			s2      => s8,
			s3      => s9,
			s4      => s10,
			s5      => s11
		);

	-- FSM module instantiation
	exp_fsm: entitiy work.exponentiation_fsm
		generic map (
			C_block_size => C_block_size
		)
		port map (
			reset_n         => reset_n,
			clk             => clk,
			n               => n,
			a               => a,
			ready_out       => ready_out,
			valid_in        => valid_in,
			ready_in        => ready_in,
			valid_out       => valid_out,
			mux_ctrl_P_in   => s11[256] & s10[256] & s9[256] & s8[256],
			mux_ctrl_R_in   => s5[256]  & s4[256]  & s3[256] & s2[256],
			mux_ctrl_P_out  => mux_ctrl_P_out,
			mux_ctrl_R_out  => mux_ctrl_R_out,
		);
	
	exp_result: process(clk, reset_n, ready_out, valid_in, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, mux_ctrl_P_out, mux_ctrl_R_out)
	begin
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
			when others =>
				result_R <= (others => '0');
		end case;
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
			when others =>
				result_P <= (others => '0');
		end case;
	end process;	
end expBehave;
