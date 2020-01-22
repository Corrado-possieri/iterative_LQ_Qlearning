function n = nfun(gamma,q,dq,l1,l2,l3)

g = gfun(gamma,q);
C = cfun(gamma,q,dq,l1,l2,l3);

Fv = diag([190.4790, 20.9745, 4.6565]);
Fs = diag([66.3430, 14.7050, 8.2911]);

n = g + C*dq + Fv*dq+ Fs*signMod(dq);

