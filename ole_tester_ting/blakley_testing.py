k = 2       # Number of bits
a = 0b01    # Example input (2 bits)
b = 0b11    # Example input (2 bits)
n = 7       # Modulus


def blakleys_algorithm(a, b, n):
    R = 0
    for i in range(k):
        R = (R << 1) + (a >> (k-1-i) & 1) * b
        if R >= n:
            R -= n
        if R >= n:
            R -= n

    #printing all vlaues
    s0 = R
    s1 = R + b
    s2 = R - n
    s3 = R + b - n
    s4 = R + b - 2*n
    s5 = R + b - 2*n
    
    print(f"a  = {a}")
    print(f"b  = {b}")
    print(f"s0 = R        = {s0}")
    print(f"s1 = R + b    = {s1}")
    print(f"s2 = R - n    = {s2}")
    print(f"s3 = R+b-n    = {s3}")
    print(f"s4 = R+b-2n   = {s4}")
    print(f"s5 = R+b-2n   = {s5}")
    print(f"Fasit = {R}")
    return R

blakleys_algorithm(a,b,n)