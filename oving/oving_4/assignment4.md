# Assignment 4
### Task 1
![alt text](image.png)
### task 2
![alt text](image-1.png)

Here the number was calculated using the code and testbench and manually added together. picture shoes the manuall adding. 
### Task 3
First we thought there was 13 inferred flip flops, but after some reading we understand that vivado counts a single bit in a 128 bit instance as one register. 
There was 391 inferred flip flops. 7 in the controller, and 384 in the datapath. - hvorfor 6 i LF????

### Task 4
Calculated from the 200 MHz clock frequency minus the worst negative slack (WNS) from the timing report: 
166 MHz

### Task 5
![alt text](32bit_adder_illustration.png)

### Task 6

Slik kretsen er nå adderers 128 bits på en syklus. Da data inn går på 32 bits må man lese av for 8 sykluser, addere på en syklus, lese ut på 4 sykluser. For at dataen skal kunne leses ut over 4 sykluer må man ha enda et register. For å redusere data critical path ble shift register på utgangen fjernet og adderern addere 32 bits ord. Dermed blir det 8 sykler for å lese inn data 4 sykler for å addere og lese ut dataen. 
Her må controll signalet forandres slik at addderen adderer over fire sykluser i stede for en. Videre kan man fjerne all logikken som styrer shift register på utgangen. 

```VHDL

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
```