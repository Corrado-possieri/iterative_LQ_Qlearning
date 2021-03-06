clear all
close all
clc

% number of states
n = 2;
% number of inputs
m = 1;
% samling time
T = 0.3;
% horizon
N = 10;

% state weights
W = 1e-3*eye(n);
Wn = eye(n); 
% input weights
R = 1e-5*eye(m);
% initial condition
x0 = [0; 0];
% reference signal
xstar = repmat([pi; 0],1,N);

% load options
options = iterativeLQRset('NumIter',50,'pert',1e-6,'NumExp',100,...
    'accelerated',0,'solver','fit','maxLamb',1e18);

% initial guess
u0 = [1, 2, 3, -6, -7, -5, 8, 9, 12, 0];
% evaluate control inputs
% optimfun = @(u) controlCost(u,W,Wn,R,m,N,T,x0,@odePendulum,xstar);
% % initialize u0
% u0 = reshape(fmincon(optimfun,u0(:)),[m,N]);
% perform iterative Q learning
[IP,ID,IC,ITheta,IPsi,IPhi,IBaseline,Iu,Icost] = iterativeLQR(n,...
    m,T,N,W,Wn,R,xstar,x0,u0,@odePendulum,options);

save simPendulum.mat x0 xstar T IP ID IC ITheta IPsi IPhi IBaseline Iu Icost