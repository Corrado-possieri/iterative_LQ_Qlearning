function [IP,ID,IC,ITheta,IPsi,IPhi,IBaseline,Iu,Icost] = itLQR(n,...
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

% number of experiments
NumExp = options.NumExp;
% number of iterations
NumIter = options.NumIter;
% perrturbation on initial conditions
pert = options.pert;
% initial improvement 
lamb = options.lamb;
% improvement multiplier
multLam = options.multLam;
% minimum and maximum value of lamb
minLamb = options.minLamb;
maxLamb = options.maxLamb;
% solver
solver = options.solver;

% initialization of optimal matrices
IP = cell(NumIter,1);
ID = cell(NumIter,1);
IC = cell(NumIter,1);
ITheta = cell(NumIter,1);
IPsi = cell(NumIter,1);
IPhi = cell(NumIter,1);
IterGamma = cell(NumIter,1);
IBaseline = cell(NumIter,1);
Iu = cell(NumIter,1);
Icost = zeros(NumIter,1);

% evaluate control inputs
optimfun = @(u) controlCost(u,W,Wn,R,m,N,T,x0,fun,xstar);

% generate random guesses
[baseLine,data] = randomSamples(NumExp,T,N,x0,u0,pert,fun);
% compute the cost of the baseLine
oldCost = optimfun(u0);

% generate incremental data
incrData = reduceData(n,m,baseLine,data);

% identify the Q factors
barx = baseLine(:,1:n)';
baru = baseLine(:,n+1:end)';
[Theta, Psi, phi, Pk, Dk, Ck, gamma] = trainMatrices(n,m,W,Wn,R,...
    xstar-barx,-baru,incrData,solver);

% store the computed matrices
IP{1} = Pk;
ID{1} = Dk;
IC{1} = Ck;
ITheta{1} = Theta;
IPsi{1} = Psi;
IPhi{1} = phi;
IterGamma{1} = gamma;
IBaseline{1} = baseLine;
% compute the cost of the baseline
Icost(1) = oldCost;
% store the control input
Iu{1} = u0;

% display the mean evaluated cost-to-go
disp(['Iteration ',num2str(1),':'])
disp('Mean gamma')
disp(mean(IterGamma{1}));
disp('Baseline control input')
disp(u0);
disp('Baseline cost')
disp(Icost(1));
disp(' ')

% set the old baseline
OldBaseline = baseLine;
for iter = 2:NumIter
    % update the baseline and the data with the computed optimal controller
    baseLine = improveSamples(T,N,x0,Theta,Psi,...
        OldBaseline,lamb,fun);
    % new value of the control input
    uNew = baseLine(:,n+1:end)';
    % compute the corresponding value
    newCost = optimfun(uNew);
    
    % if the cost did not decrease 
    if newCost > oldCost
        while lamb < maxLamb && newCost > oldCost
            % mutiply lamb by its factor
            lamb = lamb*multLam;
            disp(['Using larger lamb = ',num2str(lamb)])
            % update the baseline and the data with the new lambda
            baseLine = improveSamples(T,N,x0,Theta,Psi,...
                OldBaseline,lamb,fun);
            % new value of the control input
            uNew = baseLine(:,n+1:end)';
            % compute the corresponding value
            newCost = optimfun(uNew);
        end
        disp(' ')
        
        % if eventually the parameter did not converge
        % interrupt the iterations
        if lamb > maxLamb
            IP(iter:end) = [];
            ID(iter:end) = [];
            IC(iter:end) = [];
            ITheta(iter:end) = [];
            IPsi(iter:end) = [];
            IPhi(iter:end) = [];
            IterGamma(iter:end) = [];
            IBaseline(iter:end) = [];         
            Icost(iter:end) = [];
            Iu(iter:end) = [];
           break; 
        end
    else
        % otherwise divide lamb by its factor
        if lamb > minLamb 
            lamb = lamb/multLam;
            disp(['Using smaller lamb = ',num2str(lamb)])
            disp(' ')
        end
    end
    % generate random guesses about the baseline
    [baseLine,data] = randomSamples(NumExp,T,N,x0,uNew,pert,fun);
    
    % generate incremental data
    incrData = reduceData(n,m,baseLine,data);

    % identify the Q factors
    barx = baseLine(:,1:n)';
    baru = baseLine(:,n+1:end)';
    [Theta, Psi, phi, Pk, Dk, Ck, gamma] = trainMatrices(n,m,W,Wn,R,...
        xstar-barx,-baru,incrData,solver);
    
    % store the obtained matrices
    IP{iter} = Pk;
    ID{iter} = Dk;
    IC{iter} = Ck;
    ITheta{iter} = Theta;
    IPsi{iter} = Psi;
    IPhi{iter} = phi;
    IterGamma{iter} = gamma;
    IBaseline{iter} = baseLine;
    % compute the cost of the baseline
    u = baseLine(1:end,n+1:n+m)';
    Icost(iter) = optimfun(u(:));
    % store the control input
    Iu{iter} = u;
    
    % update the baseLine
    OldBaseline = baseLine;
    oldCost = newCost;
    
    % display the mean evaluated cost-to-go
    disp(['Iteration ',num2str(iter)])
    disp('Mean gamma')
    disp(mean(IterGamma{iter}));
    disp('Baseline control input')
    disp(u);
    disp('Baseline cost')
    disp(Icost(iter));
    disp(' ')
end