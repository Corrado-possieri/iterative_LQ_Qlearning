function cost = controlCost(u,W,Wn,R,m,N,T,x0,fun,xd)
% compute the cost associated to the control inpit
% u: control input
% W: state weight
% Wn: final state weight
% R: input weight
% m: number of inputs
% N: horizon
% T: sampling time
% x0: initial condition
% fun: dynamics
% xd: target state
% ud: target input

% reshape the control input
u = reshape(u,[m,N]);

% simulate the behavior of the plant given the input
state = zeros(N,size(x0,1));
state(1,:) = x0';
xfin = x0;
for k =1:N-1
    [~,y] = ode45(@(t,x) fun(t,x,u(:,k)), [0,T], xfin);
    state(k+1,:) = y(end,:)';
    xfin = y(end,:)';
end

% compute the cost
cost = 0;
for k = 1:N-1
    x = state(k,:)';
    % iteratively construct the cost function
    cost = cost + (x - xd(:,k))'*W*(x - xd(:,k)) ...
        + (u(:,k))'*R*(u(:,k));
end
% add terminal cost
xN = state(N,:)';
cost = cost + (xN - xd(:,N))'*Wn*(xN - xd(:,N));