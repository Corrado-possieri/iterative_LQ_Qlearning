%--------------------------------------------------------------------------
% Gian Paolo Incremona, Ph.D.
% Assistant Professor
% 
% Dipartimento di Elettronica, Informazione e Bioingegneria
% Politecnico di Milano
% Piazza Leonardo da Vinci, 32 - 20133 Milano (Italy)
% Phone: +39 - 02 2399 9686
% Fax: +39 - 02 2399 3412
% Email: gianpaolo.incremona@polimi.it
%
%==========================================================================
clear
close all
clc

%% Settings
T = 1e-3; % sampling time
tf = 2;  % final time of the simulation

% Parameters identified on the COMAU SMART3-S2
% A. Calanca, L. M. Capisani, A. Ferrara and L. Magnani, "MIMO Closed Loop Identification of an Industrial Robot," in IEEE Transactions on Control Systems Technology, vol. 19, no. 5, pp. 1214-1224, Sept. 2011. doi: 10.1109/TCST.2010.2077294
gamma(1) = 0.2973;
gamma(2) = 10.066;
gamma(3) = 87.9151;
gamma(4) = 57.0347;
gamma(5) = 9.2148;
gamma(6) = 0.3163;

% links length
l1 = 0.65;
l2 = 0.6576;
l3 = 0.34;

%% PD controllers for each joint
% proportional gain
Kp1 = 1e4;
Kp2 = 5e3;
Kp3 = 4e3;
% derivative gain
Kd1 = 1e3;
Kd2 = 5e2;
Kd3 = 200;
% integral gain
Ki1 = 1e1;
Ki2 = 5e1;
Ki3 = 2;


%% Initial conditions: baseline
q0_ = [1.4 0.9 1.1]; % position initial condition
dotq0_ = [0 0 0]; % velocity initial condition


%% Reference trajectory 
% sinusoid
qd_ = [pi/2 pi/4 pi/3]; % amplitude of the sin function for each joint


%% Run simulation for baseline
% Run 1 simulation in closed loop with PD with to achieve the baseline data
disp('Simulation run in closed-loop')
sim('ComauSMARTS2_CL')
disp('done!')

% matrix of states and references
Xcl = [x.signals(1).values x.signals(2).values x.signals(3).values...
          dx.signals(1).values dx.signals(2).values dx.signals(3).values];
% vector inputs
Ucl = [u.signals.values(:,1) u.signals.values(:,2) u.signals.values(:,3)];

%%
figure()
plot(x.time,Xcl(:,1:3))
hold on
plot(x.time(end),qd_,'*')

figure()
plot(x.time,Xcl(:,4:6))

% simulate the behavior of the plant
N = size(Ucl,1);
x0 = [q0_'; dotq0_'];
xt = qd_';
baseState = zeros(N,size(x0,1));
baseState(1,:) = x0';
xfin = x0;
for k =1:N-1
    y = xfin + T*odeCOMAU((k-1)*T,xfin,Ucl(k,:)');
    baseState(k+1,:) = y;
    xfin = y;
end

% simulation error
figure()
plot(baseState-Xcl)

u0 = Ucl';

save nominalInput.mat x0 u0 xt T N