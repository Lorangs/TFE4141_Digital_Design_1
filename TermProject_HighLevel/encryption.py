M = 0b1110  # 14 message to be encrypted

p = 11
q = 17
n = p*q

# public key
e = 7

# private key
d = 23

def mult_with_mod(a, b, n):
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

def encrypt(M, e, n):
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
    Q = 0

    for i in range(n):
        R = R << 1
        Q = Q << 1

        if (a >> (n-1-i) & 1):
            R += b
            Q += c

        if R >= 2*n:
            R -= 2*n
        if R >= n:
            R -= n
        if Q >= 2*n:
            Q -= 2*n
        if Q >= n:
            Q -= n

    if e == 0:
        R = b
    return R, Q

def encrypt_v2(M, e, n):
    c = 1
    P = M
    for i in range(n):
        x = (e >> i) & 1
        c, P = mult_with_mod_v2(P, c, P, x, n)
    return c



# Calculate expected cipher and decrypted message
c = M**e % n
message = c**d % n
print(f"cipher = {c}")
print(f"decrypt= {message}")

print("Using mult_with_mod:")
result_r = mult_with_mod(100, 15, 19)
print(f"result R = {result_r}")

result_p = mult_with_mod(100, 11, 19)
print(f"result P = {result_p}")