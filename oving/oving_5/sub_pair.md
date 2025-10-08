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
