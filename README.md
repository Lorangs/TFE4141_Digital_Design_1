# TFE4141_Digital_Design_1
Prosjektemne TFE4141 Design av Digitale Systemer 1 ved NTNU.

Gruppemedlemmer:
    Susanne Gripsgård
    Ole-Jakob Schubert
    Lorang Strand





test def mult_with_mod_v2(a, b, c, e, n):
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

mult with mod (100, 15, 11)
a = 1100100


Sykel:
250.        R = 15,    P = 11          , s1 & s7   001 001
250.        R = 45,    P = 33          , s1 & s7   001 001
251.        R = 90,    P = 66          , s0 & s6   000 000
252.        R = 180,   P = 132         , s0 & s6   000 000
253.        R = 119,   P = 19          , s3 & s9   011 011
254.        R = 238,   P = 38          , s0 & s6   000 000
255.        R = 220,   P = 76          , s2 & s6   010 000


