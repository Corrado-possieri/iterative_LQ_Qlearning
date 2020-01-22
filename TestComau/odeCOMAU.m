function dx = odeCOMAU(~,x,u)
% Dinamics identified on the COMAU SMART3-S2
% A. Calanca, L. M. Capisani, A. Ferrara and L. Magnani, "MIMO Closed Loop Identification of an Industrial Robot," in IEEE Transactions on Control Systems Technology, vol. 19, no. 5, pp. 1214-1224, Sept. 2011. doi: 10.1109/TCST.2010.2077294

gamma = [0.2973;
    10.066;
    87.9151;
    57.0347;
    9.2148;
    0.3163];

% links length
l1 = 0.65;
l2 = 0.6576;
l3 = 0.34;

q = x(1:3);
dq = x(4:6);

tau = u;

B = Bmatrix(gamma,q,l1,l2,l3);
n = nfun(gamma,q,dq,l1,l2,l3);

dotq = dq;
dotdq = B\(tau - n);

dx = [dotq; dotdq];