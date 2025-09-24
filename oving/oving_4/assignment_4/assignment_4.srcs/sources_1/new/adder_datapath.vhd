----------------------------------------------------------------------------------
-- Company    :  NTNU
-- Engineer   : �ystein Gjermundnes
-- 
-- Module Name: mega_adder_datapath
-- Description:   
--   Datapath for the mega_adder. The datapath consists of shift registers
--   at the inputs and outputs and a large 128 bit adder.
--
--   CHALLENGE 1:
--   Set different synthesis constraints for the max frequency and check how the
--   area of the design changes.
--  
--   CHALLENGE 2: 
--   Can you think of a way to significantly increase the max clock frequency 
--   as well as reducing the area?
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_datapath is
  port (      
    -- Clocks and resets
    clk             : in std_logic;
    reset_n         : in std_logic;
    
    -- Data in interface       
    data_in         : in std_logic_vector (31 downto 0);
    input_reg_en    : in std_logic;
    
    -- Data out interface
    data_out        : out std_logic_vector (31 downto 0);
    output_reg_en   : in std_logic;
    output_reg_load : in std_logic);
        
end adder_datapath;

architecture rtl of adder_datapath is

  -- Signals associated with the input registers
  signal a_r, a_nxt: std_logic_vector(127 downto 0);
  signal b_r, b_nxt: std_logic_vector(127 downto 0);
  
  -- Signals associated with the output registers
  signal y_r:  std_logic_vector(31 downto 0);
  signal y_nxt: std_logic_vector(32 downto 0);
  
  -- Signals associated with the adder
  signal c_in, c_out: std_ulogic; 
  signal temp: std_logic_vector(31 downto 0);
    
begin

  -- ***************************************************************************
  -- Register a_r and b_r
  -- ***************************************************************************
  process (clk, reset_n) begin
    if(reset_n = '0') then
      a_r <= (others => '0');
      b_r <= (others => '0');      
    elsif(clk'event and clk='1') then
      if(input_reg_en ='1') then
        a_r <= a_nxt;
        b_r <= b_nxt;        
      end if;
    end if;
  end process;
    
  process (data_in, a_r, b_r) begin
    a_nxt <= data_in & a_r(127 downto 32);
    b_nxt <= a_r(31 downto 0) & b_r(127 downto 32);
  end process; 

  -- ***************************************************************************
  -- Register y_r
  -- Add the content of a_r and b_r and store it in y_r.
  -- Logic for shifting out the content of y_r to data_out
  -- ***************************************************************************
  
  process (clk, reset_n) begin
    
    if(reset_n = '0') then
        y_r <= (others => '0');
 
    elsif(clk'event and clk='1') then
        if(output_reg_load = '1') then
            temp <= b"0000000000000000000000000000000" & c_in;
            y_nxt <= std_logic_vector(unsigned(a_r(31 downto 0)) + unsigned(b_r(31 downto 0)) + unsigned(temp));
            c_out <= y_nxt(32);
        else
            y_nxt <= y_nxt;
        end if; 
          
        if(output_reg_en ='1') then
            c_in <= c_out;
            y_r <= y_nxt(31 downto 0);
        else 
            y_r <= (others => '0');
        end if;
     end if;   
  end process;
    
  data_out <= y_r;

end rtl;
