import csv
import os

def mult_with_mod_old(a, b, n):
    R = 0
    for i in range(n):
        R = R << 1
        if (a >> (n-1-i) & 1):
            R += b
        if R >= 2*n:  # r = 10 n = 3 ==> R >= 2 * 3 = 6 så då 10-6 = 4,||||| N= 6 -> R = -2  ||||| N = 12 -> R = - 14
            R -= 2*n
        elif R >= n: # R = 10, n = 3 ==> R >= 3 så då e R = 7,         ||||| N = 6 -> 4      ||||| N = 12 -> R = - 2
            R -= n
       # else:       # R = 10, n = 3 ==> R >= 0 så då e R= 10,         ||||| N = 6  -> 10    ||||| N = 12 -> R = 10
       #     R
       # vi ønsker å velge R som ikke er negativ. aka 1 på 255 eller 256 
    return R

def encrypt_old(M, e, n):
    c = 1
    P = M
    for i in range(n):
        if (e >> i) & 1:
            c = mult_with_mod(c, P, n)
        P = mult_with_mod(P ,P ,n)  
    return c

# mulig forbedring av mult_with_mod. Slå sammen to blokker til en.
# a er felles for begge blokkene, b og c er individuelle.
def mult_with_mod_v2(a, b, c, e, n):
    R = 0
    P = 0

    for i in range(256):                              
        R = R << 1
        P = P << 1

        if (a >> (256-1-i) & 1):
            R += b
            P += c

        if R >= 2*n:
            R -= 2*n
        if R >= n:
            R -= n
        if P >= 2*n:
            P -= 2*n
        if P >= n:
            P -= n

    if e == 0:
        R = b 
    return R, P

def encrypt_v2(M, e, n):
    R = 1
    P = M
    for i in range(256):
        x = (e >> i) & 1
        R, P = mult_with_mod_v2(P, R, P, x, n)
    return R

key_N = 0X99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d
e     = 0x0000000000000000000000000000000000000000000000000000000000010001
d     = 0x0cea1651ef44be1f1f1476b7539bed10d73e3aac782bd9999a1e5a790932bfe9
msg   = 0X0a2320202020202020202020203336203a2020544e554f43204547415353454d

def mult_with_mod_print_steps(a, b, c, e, n, path="test_data", filename="multiplication_steps.csv"):
    steps = []
    
    R = 0
    P = 0

    s0 = 0
    s1 = 0
    s2 = 0
    s3 = 0
    s4 = 0
    s5 = 0
    s6 = 0
    s7 = 0
    s8 = 0
    s9 = 0
    s10 = 0
    s11 = 0

    steps.append({
        "step": -1,
        "e_bit": f"\t\t-1",
        "a_bit": f"\t\t-1",
        "R_hex": f"\t0x{R:0{64}x}",
        "P_hex": f"\t0x{P:0{64}x}",
        "s0": f"\t0x{s0:0{64}x}",
        "s1": f"\t0x{s1:0{64}x}",
        "s2": f"\t0x{s2:0{64}x}",
        "s3": f"\t0x{s3:0{64}x}",
        "s4": f"\t0x{s4:0{64}x}",
        "s5": f"\t0x{s5:0{64}x}",
    })

    for i in range(256):
        R = R << 1
        P = P << 1

        s0 = R
        s1 = R + b
        s2 = R - n
        s3 = R + b - n
        s4 = R - 2*n
        s5 = R + b - 2*n
        s6 = P
        s7 = P + c
        s8 = P - n
        s9 = P + c - n
        s10 = P - 2*n
        s11 = P + c - 2*n

        if (a >> (256-1-i) & 1):
            if (s5 >= 0):
                R = s5
            elif (s3 >= 0):
                R = s3
            else:
                R = s1

            if (s11 >= 0):
                P = s11
            elif (s9 >= 0):
                P = s9
            else:
                P = s7
        else:
            if (s4 >= 0):
                R = s4
            elif (s2 >= 0):
                R = s2
            else:
                R = s0
            
            if (s10 >= 0):
                P = s10
            elif (s8 >= 0):
                P = s8
            else:
                P = s6

        steps.append({
            "step": i,
            "e_bit": f"\t\t{e}",
            "a_bit": f"\t\t{(a >> (256-1-i)) & 1}",
            "R_hex": f"\t0x{R:0{64}x}",
            "P_hex": f"\t0x{P:0{64}x}",
            "s0": f"\t0x{s0:0{64}x}",
            "s1": f"\t0x{s1:0{64}x}",
            "s2": f"\t0x{s2:0{64}x}",
            "s3": f"\t0x{s3:0{64}x}",
            "s4": f"\t0x{s4:0{64}x}",
            "s5": f"\t0x{s5:0{64}x}",
        })

    if e == 0:
        R = b

    if not os.path.exists(path):
        os.makedirs(path)
    try:
        with open(f"{path}/{filename}", mode="w", newline='\n', encoding='utf-8') as csvfile:
            fieldnames =    [
                "step",
                "e_bit",
                "a_bit",
                "R_hex",
                "P_hex",
                "s0",
                "s1",
                "s2",
                "s3",
                "s4",
                "s5"
            ]
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(steps)

    except Exception as ex:
        print(f"Error opening file {filename}: {ex}")
    return R, P

def encrypt_print_steps(M, e, n, path="test_data", filename="encrypt_test_01.csv"):
    steps = []

    R = 1
    P = M
    steps.append({
        "iteration": -1,
        "e_bit": f"\t\t-1",
        "R_hex": f"\t0x{R:0{64}x}",
        "P_hex": f"\t0x{P:0{64}x}"
    })

    for i in range(256):
        x = (e >> i) & 1
        R, P = mult_with_mod_print_steps(P, R, P, x, n, path=path, filename=f"multiplication_steps_enc_iter_{i:03}.csv")

        steps.append({
            "iteration": i,
            "e_bit": f"\t\t{x}",
            "R_hex": f"\t0x{R:0{64}x}",
            "P_hex": f"\t0x{P:0{64}x}"
        })

    if not os.path.exists(path):
        os.makedirs(path)

    try:
        with open(f"{path}/{filename}", mode="w", newline='\n', encoding='utf-8') as csvfile:
            fieldnames =    [
                "iteration",
                "e_bit",
                "R_hex",    
                "P_hex"
            ]
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(steps)

    except Exception as ex:
        print(f"Error opening file {filename}: {ex}")
    return R


print(encrypt_print_steps(msg, e, key_N, path="test_data", filename="encryption_steps_01.csv"))



#---------------------------------------------
# The handin version
#---------------------------------------------
def mult_with_mod(a, b, c, e, n, C_block_size):
    R = 0
    P = 0

    for i in range(C_block_size):                              
        R = R << 1
        P = P << 1

        if (a >> (C_block_size-1-i) & 1):
            R += b
            P += c

        if R >= 2*n:
            R -= 2*n
        if R >= n:
            R -= n
        if P >= 2*n:
            P -= 2*n
        if P >= n:
            P -= n

    if e == 0:
        R = b # returning the old value of R
    return R, P


def encrypt(M, key_e, key_n, C_block_size):
    R = 1
    P = M
    for i in range(C_block_size):
        e_i = (key_e >> i) & 1
        R, P = mult_with_mod(P, R, P, e_i, key_n, C_block_size)
    return R
