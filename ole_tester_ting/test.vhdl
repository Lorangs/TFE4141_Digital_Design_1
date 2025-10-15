-- deciding if R-2n,eller de andre den siste mux for B serien. 
Mux_nr_4_B: process(all)
begin
    -- s5(256) is assumed to be a std_logic; compare with character literals
    if s5(256) = '0' then
        -- build Last_temp_with_B from s1 and s3 (widths must match expected target)
        Last_temp_with_B <= s1 & s3;
    elsif s5(256) = '1' then
        Last_temp_with_B <= s5;
    else
        -- default safe value (adjust as needed for your design)
        Last_temp_with_B <= (others => '0');
    end if;
end process Mux_nr_4_B;


-- Last_temp s0||s1||s2
-- Last_temp_with_B s1||s3||s5

Last_Mux: process(s0||s1||s2, s1||s3||s5, mux_control)
begin 
    -- Use a simple combinational if so the sensitivity is correct
end process; -- placeholder to keep file structure if previous signals are used

Last_Mux: process(all)
begin
    if mux_control = '0' then
        R_new <= Last_temp_with_B;
    elsif mux_control = '1' then
        R_new <= Last_temp;
    else
        -- safe default (change if you want to preserve previous value)
        R_new <= (others => '0');
    end if;
end process Last_Mux;
        --when other



-- 
Mux_nr_2_B: process(s1 , s3 ,s3(256)) -- s3[256]
begin 
    case s5[256] is 
        when "0" => 
            Muxed_s1_s3 <= s1;
        when "1" => 
           Muxed_s1_s3 <= s3;
        when others
            Muxed_s1_s3 <= Muxed_s1_s3  
    end case;
end process Mux_nr_2_B;

-- Deciding between R or R-N. First mux for 
Mux_nr_3_B: process(s1 , s3 ,s3(256)) -- s3[256]
begin 
    case s5[256] is 
        when "0" => 
            Muxed_s1_s3 <= s1;
        when "1" => 
           Muxed_s1_s3 <= s3;
        when others
            Muxed_s1_s3 <= Muxed_s1_s3;  
    end case;
end process Mux_nr_3_B;


-- deciding if R-2n,eller de andre den siste mux for B serien. 
Mux_nr_4_B: process(Muxed_s1_s3 , s5 ,s5(256)) -- s5[256]
begin 
    case s5[256] is 
        when "0" => 
            Muxed_s1_s3_s5 <= Muxed_s1_s3_s5;
        when "1" => 
            Muxed_s1_s3_s5 <= s5;
        when others
            Muxed_s1_s3_s5 <= Muxed_s1_s3_s5; 
    end case;
end process Mux_nr_4_B;


-- Last_temp s0||s1||s2
-- Last_temp_with_B s1||s3||s5

Last_Mux: process(s0||s1||s2, s1||s3||s5, mux_control)
begin 
    case mux_control is
        when "0" => 
            R_new <= Last_temp_with_B;
        when "1" => 
            R_new <= Last_temp;
        when others
            R_new <= R_new 
    end case;
end process Last_Mux;
        --when other