# Assignment 5


## Task 1
```c
uint input(void)
{
    set_ready_in(1);
    while(!valid_in) wait();
    int val = read_bus_in();
    set_ready_in(0)
    return val;
}

void output(uint val)
{
    write_bus_out(val);
    set_valid_out(1);
    while(!ready_out) wait;
    set_valid_out(0);
}

void main(void)
{
    uint input_A, input_B, result;
    while(1)
    {
        input_A = input(); 
        input_B = input();
        result = (input_A > input_B) : input_A - input_B ? input_B - input_A;
        output(result);
    }
}
```

## Task 2 



| **state**   	| **next state** 	| **condition**                    	| **actions**                          	|
|-------------	|----------------	|----------------------------------	|--------------------------------------	|
| read_A      	| read_A         	| valid in = 0                     	| ready in <- 1                        	|
| read_A      	| read_B         	| valid in = 1                     	| ready in <- 1 & write input to reg 0 	|
| read_B      	| read_B         	| valid in = 0                     	| ready in <- 1                        	|
| read_B      	| subAB          	| valid in = 1                     	| ready in <- 1 & write input to reg 1 	|
| subAB       	| wait_output    	| input_greater\|input_equals      	| Data_out = reg_0 - reg_1             	|
| subAB       	| subBA          	| not(input_greater\|input_equals) 	| Data_out = reg_0 - reg_1             	|
| subBA       	| wait_output    	| none                             	| Data_out = reg_1 - reg_0             	|
| wait_output 	| wait_output    	| ready out = 0                    	| valid out = 1                        	|
| wait_output 	| read_A         	| ready out = 1                    	| valid out = 1                        	|

