function [IP,ID,IC,ITheta,IPsi,IPhi,IBaseline,Iu,Icost] = iterativeLQR(n,...
    m,T,N,W,Wn,R,xstar,x0,u0,fun,options)
% perform iterative LQR via Q-learning
% n: number of states
% m: number of inputs
% T: samling time
% N: horizon
% W: state weights
% Wn: final state weight
% R: input weight
% xstar: reference signal
% x0: initial condition
% u0: initial control input
% fun: function to integrate
% options: options

if options.accelerated == 1
    [IP,ID,IC,ITheta,IPsi,IPhi,IBaseline,Iu,Icost] = itLQR_acc(n,...
        m,T,N,W,Wn,R,xstar,x0,u0,fun,options);
else
    [IP,ID,IC,ITheta,IPsi,IPhi,IBaseline,Iu,Icost] = itLQR(n,...
        m,T,N,W,Wn,R,xstar,x0,u0,fun,options);
end