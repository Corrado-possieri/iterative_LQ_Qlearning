function [Theta, Psi, phi, Pk, Dk, Ck, gamma] = trainMatrices(n,m,W,...
    Wn,R,xd,ud,data,solver)
% identify matrices of the Q factors
% n: number of states
% m: number of inputs
% W: state weights
% Wn: final state weights
% R: input weights
% xd: reference state
% ud: reference input
% data: collected incremental data

% number of experiments
S = length(data); 
% length of each experiment
N = size(data{1},1); 

% samples of the cost-to-go
gamma = zeros(S,N-1);
% samples of the increments
x = zeros(n,S,N-1);
xp = zeros(n,S,N-1);
u = zeros(m,S,N-1);

% populate the matrix gamma and the matrices of increments dx and du 
% starting from the final time
k = N-1; 
for s = 1:S
    % read the s-th experiment
    datum = data{s};
    % state at time k
    x(:,s,k) = datum(k,1:n)';
    % next state at time k
    xp(:,s,k) = datum(k+1,1:n)';
    % control input at time k
    u(:,s,k) = datum(k,n+1:end)';
    % sample of the Q factor at time k
    gamma(s,k) = (x(:,s,k) - xd(:,k))'*W*(x(:,s,k) - xd(:,k)) + ...
        (u(:,s,k) - ud(:,k))'*R*(u(:,s,k) - ud(:,k)) + ...
        (xp(:,s,k) - xd(:,k+1))'*Wn*(xp(:,s,k) - xd(:,k+1));
end

% solve the MSE optimization problem to find the matrices Theta, Psi and
% the scalar phi
[ThetaN, PsiN, phiN] = fitMatrices(n,m,squeeze(x(:,:,k)),...
        squeeze(u(:,:,k)),gamma(:,k),solver);

% isolate entries of the matrices
thetaN1 = ThetaN(1:n,1:n);
thetaN2 = ThetaN(1:n,n+1:end);
thetaN3 = ThetaN(n+1:end,n+1:end);
psiN1 = PsiN(1:n);
psiN2 = PsiN(n+1:end);

% compute the cost-to-go matrices
newPf = thetaN1 - thetaN2*(thetaN3\(thetaN2'));
newDf = psiN1 - thetaN2*(thetaN3\(psiN2));
newCf = -1/4*psiN2'*(thetaN3\(psiN2)) + phiN;

% store the matrices into arrays
Theta = zeros(n+m,n+m,N-1);
Psi = zeros(n+m,N-1);
phi = zeros(N-1,1);

Theta(:,:,k) = ThetaN;
Psi(:,k) = PsiN;
phi(k) = phiN;

Pk =  zeros(n,n,N-1);
Dk =  zeros(n,N-1);
Ck =  zeros(N-1,1);

Pk(:,:,k) = newPf;
Dk(:,k) = newDf;
Ck(k) = newCf;

% iterate backward to identify the matrices
for k = N-2: -1: 1
    for s = 1:S
        % read the s-th experiment
        datum = data{s};
        % state at time k
        x(:,s,k) = datum(k,1:n)';
        % next state at time k
        xp(:,s,k) = datum(k+1,1:n)';
        % control input at time k
        u(:,s,k) = datum(k,n+1:end)';
        % sample of the Q factor at time k
        gamma(s,k) = (x(:,s,k) - xd(:,k))'*W*(x(:,s,k) - xd(:,k)) + ...
            (u(:,s,k) - ud(:,k))'*R*(u(:,s,k) - ud(:,k)) ...
            + xp(:,s,k)'*newPf*xp(:,s,k) + newDf'*xp(:,s,k) + newCf;
    end
    
    % find the matrices Theta, Psi and the scalar phi 
    [ThetaK, PsiK, phiK] = fitMatrices(n,m,squeeze(x(:,:,k)),...
        squeeze(u(:,:,k)),gamma(:,k),solver);
    
    % isolate entries of the matrices
    thetaK1 = ThetaK(1:n,1:n);
    thetaK2 = ThetaK(1:n,n+1:end);
    thetaK3 = ThetaK(n+1:end,n+1:end);
    psiK1 = PsiK(1:n);
    psiK2 = PsiK(n+1:end);

    % compute the cost-to-go matrices
    newPf = thetaK1 - thetaK2*(thetaK3\(thetaK2'));
    newDf = psiK1 - thetaK2*(thetaK3\(psiK2));
    newCf = phiK-1/4*psiK2'*(thetaK3\(psiK2));
    
    % store the computed matrices
    Theta(:,:,k) = ThetaK;
    Psi(:,k) = PsiK;
    phi(k) = phiK;
    Pk(:,:,k) = newPf;
    Dk(:,k) = newDf;
    Ck(k) = newCf;
end
