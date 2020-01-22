function [Theta,Psi,phi] = fitMatrices(n,m,x,u,gamma,solver)
% fit a second order model to data
% n: number of states
% m: number of states
% x: states
% u: inputs
% gamma: samples of teh Q factors
% solver: solver to use

if strcmp(solver,'cvx')
    % fit the matrices using cvx
    % determine the number of samples
    S = size(x,2);

    cvx_solver mosek

    cvx_begin quiet
        % variables definition
        variable th(n+m,n+m) symmetric
        variable ps(n+m,1)
        variable ph
        % iterative construction of the cost function
        cost = 0;
        for s = 1:S
            eta = [x(:,s); u(:,s)];
            gam = gamma(s);
            cost = cost + norm(eta'*th*eta + ps'*eta + ph - gam);
        end
        % constraints about positive definiteness
        th == hermitian_semidefinite(n+m)
        th(n+1:n+m,n+1:n+m) == hermitian_semidefinite(m)
        [ph, 1/2*ps'; 1/2*ps, th] == hermitian_semidefinite(m+n+1)
        % solution of the problem
        minimize cost
    cvx_end
    % save the matrices
    Theta = th;
    Psi = ps;
    phi = ph;
    
elseif strcmp(solver,'fit')
    % fit the matrices performing a linear regression
    eta = [x; u];
    pmod = polyfitn(eta',gamma',2);

    % construct the data
    modelterms = pmod.ModelTerms;
    Theta = zeros(n+m,n+m);
    Psi = zeros(n+m,1);
    phi = 0;
    for ii = 1:size(modelterms,1)
        % find exponents different from 0
        nonZeroExp = find(modelterms(ii,:) ~= 0);
        switch length(nonZeroExp)
            case 0
                % if there is no nonzero term
                phi = pmod.Coefficients(ii);
            case 1
                % if there is one nonzero term
                % value of the exponent
                switch modelterms(ii,nonZeroExp(1))
                    case 1
                        % if it is 1 use it in Psi
                        Psi(nonZeroExp(1)) = pmod.Coefficients(ii);
                    case 2
                        % if it is 2 use it in Theta
                        Theta(nonZeroExp(1),nonZeroExp(1)) =  ...
                            pmod.Coefficients(ii);
                    otherwise
                        error 'exponents are greater than 2'
                end
            case 2
                % use the coefficient to design Theta
                indi = nonZeroExp(1);
                indj = nonZeroExp(2);
                Theta(indi,indj) = pmod.Coefficients(ii)/2;
                Theta(indj,indi) = pmod.Coefficients(ii)/2;
            otherwise
                error 'more than 2 nonzero entries';
        end
    end     
elseif strcmp(solver,'yalmip')
    % use yalmip to solve the fitting problem
    th = sdpvar(n+m);
    ps = sdpvar(n+m,1);
    ph = sdpvar(1);
    
    % determine the number of samples
    S = size(x,2);
    % iterative construction of the cost function
    cost = 0;
    for s = 1:S
        eta = [x(:,s); u(:,s)];
        gam = gamma(s);
        cost = cost + norm(eta'*th*eta + ps'*eta + ph - gam);
    end
    % identify the control hessian
    hes = th(n+1:n+m,n+1:n+m);
    % identify the bias
    bias = [ph, 1/2*ps'; 1/2*ps, th];
    % define the constraints
    constraints = [hes >= 0, th >= 0, bias >= 0];
    % solve the problem
    ops = sdpsettings('solver','mosek','verbose',0);
    optimize(constraints,cost,ops);
    
    % store the obtained matrices
    Theta = value(th);
    Psi = value(ps);
    phi = value(ph);
else
    disp(solver);
    error 'solver nor found'
end