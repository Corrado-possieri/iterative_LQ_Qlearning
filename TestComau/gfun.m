function g = gfun(gamma,q)

u = [gamma; q];

g1 = u(4)*sin(u(7)) + u(5)*9.81*sin(u(7)+u(8)) + u(6)*9.81*sin(u(7)+u(8)+u(9));
g2 = u(5)*9.81*sin(u(7)+u(8)) + u(6)*9.81*sin(u(7)+u(8)+u(9));
g3 = u(6)*9.81*sin(u(7)+u(8)+u(9));

g = [g1;g2;g3];