function dx = odePendulum(~,x,u)
% dynamical equations of a pendulum

m = 1;
l = 1;
g = 9.8;
mu = 0.01;

dx = [x(2); g/l*sin(x(1)) - mu/(m*l^2)*x(2) + 1/(m*l^2)*u];