clear all
close all
clc

% number of states
n = 6;
% number of inputs
m = 3;

% state weights
W = 1e-6*eye(n);
Wn = eye(n); 
% input weights
R = 1e-12*eye(m);

% sampling time
T = 1;
% horizon
N = 4;
% initial guess
u0 = [130 160 200 0
 -100 70 20 0
  -50 50 -20 0];
% initial condition
x0 = zeros(n,1);
% target
xt = [pi/3; pi/4; -pi/3; 0; 0; 0];

% repeated target
xstar = repmat(xt,1,N);

% load options
options = iterativeLQRset('NumIter',1e2,'pert',1e-2,'NumExp',2e2,...
    'accelerated',0,'solver','yalmip','lamb',1e-12,'maxLamb',1e12);

% % initialize u0
% optimfun = @(u) controlCost(u,W,Wn,R,m,N,T,x0,@odeCOMAU,xstar);
% opt = optimoptions('fmincon','MaxFunctionEvaluations',1e4);
% u0 = reshape(fmincon(optimfun,u0(:),[],[],[],[],[],[],[],opt),[m,N]);

% perform iterative Q learning
tic
[IP,ID,IC,ITheta,IPsi,IPhi,IBaseline,Iu,Icost] = iterativeLQR(n,...
    m,T,N,W,Wn,R,xstar,x0,u0,@odeCOMAU,options);
toc

% save simCOMAU.mat x0 xstar T IP ID IC ITheta IPsi IPhi IBaseline Iu Icost