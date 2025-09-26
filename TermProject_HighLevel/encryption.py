from tqdm import tqdm

M = 0b1110  # 14 message to be encrypted

p = 11
q = 17
n = p*q


# public key
e = 7

# private key
d = 23

c = M**e % n
print(f"cipher = {c}")

message = c**d % n
print(f"decrypt= {message}")

def mult_with_mod(a, b, n):

    #R_sel = 00
    R = 0
    for i in range(n):
        a = a << 1
        if (a & (1 << 255)):
            R = (R << 1) + b
        else:
            R = (R << 1) 

        #R_sel = 10
        if R >= n:
            R -= n
        if R >= n:
            R -= n
    
    #R_sel = 11 invalid state
    # should trigger reset_n

    return R

def encrypt(M, e, n):
    c = 1
    P = M
    for i in range(n):
        if (e >> i) & 1:
            c = mult_with_mod(P, c, n)
        P = mult_with_mod(P ,P ,n)
    return c


cipher = encrypt(M, e, n)
decyphered_message = encrypt(cipher, d, n)
print(cipher)
print(decyphered_message)