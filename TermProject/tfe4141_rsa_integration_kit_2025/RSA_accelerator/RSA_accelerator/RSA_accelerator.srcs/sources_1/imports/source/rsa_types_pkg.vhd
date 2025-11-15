library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package rsa_types_pkg is
	-- Define array types for testing
	type state_array_t is array (0 to 4 - 1) of STD_LOGIC_VECTOR( 1 downto 0 );
	type data_array_t is array (0 to 4 - 1) of STD_LOGIC_VECTOR( 256 - 1 downto 0 );
	type logic_array_t is array (0 to 4 - 1) of STD_LOGIC;
	type core_queue_t is array (0 to 4 - 1) of INTEGER range 0 to 4 - 1;
	type status_array_t is array (0 to 4 - 1) of STD_LOGIC_VECTOR( 31 downto 0 );
end package rsa_types_pkg;
