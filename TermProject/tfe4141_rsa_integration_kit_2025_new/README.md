# TFE4141_Digital_Design_1
Prosjektemne TFE4141 Design av Digitale Systemer 1 ved NTNU.

Gruppemedlemmer:
    Susanne Gripsgård
    Ole-Jakob Schubert
    Lorang Strand



Status 12. November 2025

Mult_with_Mod modulen fungerer og gir riktig resultat for uttrykket a*b mod n.

Exponentiation modulen gir også korrekte svar for tester med små tall. Større tall er ikke testet riktig enda.

Det er gjort forsøk for å integrere exponentiation modulen inn i rsa_core som en enkel kjerne, uten suksess. 
rsa_accelerator testbenk forteller oss at vi har ugyldig utdata. Feilsøking pågår.

Videre er det ønske om å integrere flere instanser av exponentiation modulen i rsa_core for å øke kapasiteten til prosjektet. 

    
