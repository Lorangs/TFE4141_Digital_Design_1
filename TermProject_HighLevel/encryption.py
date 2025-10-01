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
        if R >= 2*n:
            R -= 2*n
        elif R >= n:
            R -= n
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

# Test the encryption and decryption algorithm
cipher = encrypt(M, e, n)
decyphered_message = encrypt(cipher, d, n)
print(cipher)
print(decyphered_message)

cipher_v2 = encrypt_v2(M, e, n)
decyphered_message_v2 = encrypt_v2(cipher_v2, d, n)
print(cipher_v2)
print(decyphered_message_v2)
