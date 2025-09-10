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
    return R

result = blakleys_algorithm(a, b, n)
print(result)  # Output the result of the algorithm 