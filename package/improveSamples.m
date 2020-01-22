function NewBaseLine = improveSamples(T,N,x0,...
    Theta,Psi,OldBaseLine,lamb,fun)
% improve random samples
% NumExp: number of experiments
% T: sampling time
% x0: initial condition
% u0: initial guess on the optimal solution
% Theta: quadratic part of the Q factors
% Psi: linear part of the Q factors
% OldBaseLine: old baseline
% fun: function to integrate
% lamb: improvement step LM

% number of states
n = length(x0);

% isolate old input
u0 = OldBaseLine(:,n+1:end)';

% number of inputs
m = size(u0,1);

% set the increment with respect to the baseline to zero
dx = zeros(size(x0));
xfin = x0;
NewBaseLine = zeros(N,n+m);
for k = 1:N-1
    % updated u and x
    Th3 = Theta(n+1:end,n+1:end,k);
    % use the Levenberg-Marquardt approach to modify Th3
    % eigenvalues decomposition
    [V,D] = eig(Th3);
    % set to 0 negative terms on the diagonal
    D(D<0) = 0;
    % add lamb to the diagonal so to avoid too fast descent
    D = D + lamb*eye(size(D));
    % compute the inverse of the modified matrix
    iTh3 = V*(D\(V'));
    Th2 = Theta(1:n,n+1:end,k);
    Ps2 = Psi(n+1:end,k);
    du = -iTh3*(Th2'*dx + 1/2*Ps2);
    % save the baseline
    NewBaseLine(k,:) = [xfin', (u0(:,k)+du)'];
    % simulate the robot behavior
    [~,y] = ode45(@(t,x) fun(t,x,u0(:,k)+du),[(k-1)*T,k*T],xfin);
    % update final x and dx
    xfin = y(end,:)';
    dx = xfin - OldBaseLine(k+1,1:n)';
end
NewBaseLine(N,1:n) = xfin';