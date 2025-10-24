k = 2       # Number of bits
a = 4#0b011    # Example input (3 bits)
b = 10#0b110    # Example input (3 bits)
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

    print(f"a  = {a} = {bin(a)}")
    print(f"b  = {b} = {bin(b)}")
    print(f"s0 = R        = {s0} = {bin(s0)}")
    print(f"s1 = R + b    = {s1} = {bin(s1)}")
    print(f"s2 = R - n    = {s2} = {bin(s2)}")
    print(f"s3 = R+b-n    = {s3} = {bin(s3)}")
    print(f"s4 = R+b-2n   = {s4} = {bin(s4)}")
    print(f"s5 = R+b-2n   = {s5} = {bin(s5)}")
    print(f"Calcultated   = {R } = {bin(R )}")
    return R

blakleys_algorithm(a,b,n)