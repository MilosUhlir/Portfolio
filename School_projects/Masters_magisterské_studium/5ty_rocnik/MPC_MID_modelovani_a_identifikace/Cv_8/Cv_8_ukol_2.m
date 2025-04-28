
[m1 p1 o1 m2 p2 o2 m3 p3 o3] = cv_8_2();

p = tf('p');
Fp1 = 1/(10*p+1);
Fp2 = (p)/(p+1);
Fp3 = p*p/(p+1)^2/(10*p+1)^2*100;

z = tf('z',1);
F1 = c2d(Fp1,1)
F2 = c2d(Fp2,1)
F3 = c2d(Fp3,1)