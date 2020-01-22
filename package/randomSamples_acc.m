function [baseLine,data] = randomSamples_acc(NumExp,T,N,x0,u0,pert,fun)
% generate random samples
% NumExp: number of experiments
% T: sampling time
% x0: initial condition
% u0: initial guess on the optimal solution
% pert: perturbation
% fun: function to integrate

% simulate the behavior of the plant
baseState = zeros(N,size(x0,1));
baseState(1,:) = x0';
xfin = x0;
for k =1:N-1
    y = xfin + T*fun((k-1)*T,xfin,u0(:,k));
    baseState(k+1,:) = y;
    xfin = y;
end
% save the baseline
baseLine = [baseState,u0'];

% simulate the behavior of the plant with slightly perturbed inputs and
% intiial conditions
data = cell(NumExp,1);
for ii = 1:NumExp
    x = x0 + pert*randn(size(x0));
    u = u0 + pert*randn(size(u0));
    datum = zeros(N,size(x,1));
    datum(1,:) = x';
    xfin = x;
    for k =1:N-1
        y = xfin + T*fun((k-1)*T,xfin,u0(:,k));
        datum(k+1,:) = y;
        xfin = y;
    end
    data{ii} = [datum,u'];
end