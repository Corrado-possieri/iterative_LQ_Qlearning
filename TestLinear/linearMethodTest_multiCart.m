clear all
close all
clc

% number of iterations
N = 51;

% fix random values for reproducibility
rng(1);

%% Cart data
k0 = 0.33;
h0 = 1.1;
M = 1;

%% Matrices
veh = 3;
Al = diag(-2*k0/M*ones(1,veh)) + diag(k0/M*ones(1,veh-1),1) ...
    + diag(k0/M*ones(1,veh-1),-1);
Al(1,1) = -k0/M;
Al(end,end) = -k0/M;
Ad = diag(-2*h0/M*ones(1,veh)) + diag(h0/M*ones(1,veh-1),1) ...
    + diag(h0/M*ones(1,veh-1),-1);
Ad(1,1) = -h0/M;
Ad(end,end) = -h0/M;
Ac = [zeros(veh),eye(veh); Al, Ad];
Bc = 1/M*[zeros(veh,2); 1, 0; zeros(veh-2,2); 0, 1];
Gc = 1/M*[zeros(veh); eye(veh)];

% sampling time
Ts = 1e-1;

% number of states
n = length(Ac);
% number of inputs
m = size(Bc,2);

% number of experiments
NumExp = 10*(m+n+1)*(m+n+2);

% continuous system
sysC = ss(Ac,[Bc Gc],eye(n),zeros(n,m+veh));
sysD = c2d(sysC,Ts,'zoh');

% discrete time matrices
A = sysD.A;
B = sysD.B(:,1:2);
G = sysD.B(:,3:end);

% state weight
W = 1e2*[eye(veh), zeros(veh);
    zeros(veh,2*veh)];
% final state weight
Wn = 1e2*[eye(veh), zeros(veh);
    zeros(veh,2*veh)];
% input weight
R = 1e-2*eye(m);
% covariance matrix
S = 1e-9*eye(veh);
Ss = chol(S);
% target
discTime = 1:N;
xd = [2*(1:veh)' + cos(2*pi*Ts*discTime);
    zeros(veh,N)];
ud = repmat(zeros(m,1),1,N);

% select random initial conditions and input
u0 = 10*randn(m,N);
x0 = zeros(n,1);
data = genLinData(A,B,G,Ss,x0,u0,NumExp,N);

% train Q factor matrices
tic
[Theta, Psi, phi, Pk, Dk, Ck, gamma] = trainMatrices(n,m,W,Wn,R,...
    xd,ud,data,'fit');
toc

%%
% compute real matrices
[rP, rD, rC, rTheta, rPsi, rPhi] = realMatrices(A,B,G,N,W,Wn,R,S,xd);

%%
% check for errors
for k = 1:N-1
    disp([k,...
        norm(rP(:,:,k)-Pk(:,:,k)), ...
        norm(rD(:,k)-Dk(:,k)), ...
        norm(rC(k)-Ck(k)),...
        norm(rTheta(:,:,k)-Theta(:,:,k)), ...
        norm(rPsi(:,k)-Psi(:,k)), ...
        norm(rPhi(k)-phi(k))]);
end

%%
% reset random stream for reproducibility
rng(1)

% test the closed loop
statecl = zeros(n,N);
% closed loop state
statecl(:,1) = x0;
% closed loop input
inputcl = zeros(m,N);
% cost
cost = 0;
for k = 1:N-1
    x = statecl(:,k);
    % compute input
    Th3 = Theta(n+1:end,n+1:end,k);
    Th2 = Theta(1:n,n+1:end,k);
    Ps2 = Psi(n+1:end,k);
    u = -Th3\(Th2'*x + 1/2*Ps2);
    inputcl(:,k) = u;
    % update cost
    xc = xd(:,k);
    cost = cost + (x-xc)'*W*(x-xc) + u'*R*u;
    w = Ss*randn(length(Ss),1);
    statecl(:,k+1) = A*x + B*u + G*w;
end
% add the final cost
xcn = xd(:,N);
xn = statecl(:,N);
cost = cost + (xn-xcn)'*Wn*(xn-xcn);

% reset random stream for reproducibility
rng(1)
% test the optimal loop
stateStar = zeros(n,N);
% closed loop state
stateStar(:,1) = x0;
% closed loop input
inputStar = zeros(m,N);
% cost
costStar = 0;
for k = 1:N-1
    x = stateStar(:,k);
    % compute input
    rTh3 = rTheta(n+1:end,n+1:end,k);
    rTh2 = rTheta(1:n,n+1:end,k);
    rPs2 = rPsi(n+1:end,k);
    inputStar(:,k) = -rTh3\(rTh2'*x + 1/2*rPs2);
    % update cost
    xc = xd(:,k);
    costStar = costStar + (x-xc)'*W*(x-xc) + u'*R*u;
    w = Ss*randn(length(Ss),1);
    stateStar(:,k+1) = A*x + B*inputStar(:,k) + G*w;
end
% add the final cost
xcn = xd(:,N);
xn = stateStar(:,N);
costStar = costStar + (xn-xcn)'*Wn*(xn-xcn);

%%
figure()
subplot(3,1,1)
plot(Ts*(0:N-1),xd)
subplot(3,1,2)
plot(Ts*(0:N-1),statecl)
subplot(3,1,3)
plot(Ts*(0:N-1),stateStar)

figure()
subplot(2,1,1)
stairs(Ts*(0:N-1),inputcl')
subplot(2,1,2)
stairs(Ts*(0:N-1),inputStar')

save simresults.mat xd Ts statecl stateStar inputcl inputStar 

% estimated cost
P0 = Pk(:,:,1);
D0 = Dk(:,1);
C0 = Ck(1);
disp(cost - costStar)