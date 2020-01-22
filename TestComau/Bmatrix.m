function B = Bmatrix(gamma,q,l1,l2,l3)

u = [gamma;q];

B11 = u(3) + 2*u(5)*l1*cos(u(8)) + 2*u(6)*l2*cos(u(9)) + 2*u(6)*l1*cos(u(8)+u(9));
B12 = u(5)*l1*cos(u(8))+u(2)+2*u(6)*l2*cos(u(9))+u(6)*l1*cos(u(8)+u(9));
B13 = u(6)*l1*cos(u(8)+u(9)) + u(6)*l2*cos(u(9)) + u(1);
B21 = u(5)*l1*cos(u(8))+u(2)+2*u(6)*l2*cos(u(9))+u(6)*l1*cos(u(8)+u(9));
B22 = u(2) + 2*u(6)*l2*cos(u(9));
B23 = u(1) + u(6)*l2*cos(u(9));
B31 = u(6)*l1*cos(u(8)+u(9)) + u(6)*l2*cos(u(9)) + u(1);
B32 = u(1) + u(6)*l2*cos(u(9));
B33 = u(1);

B = [B11, B21, B31; 
    B12, B22, B32;
    B13, B23, B33];
