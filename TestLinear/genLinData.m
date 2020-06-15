function data = genLinData(A,B,G,Ss,x0,u0,numExp,N)
% generate random linear data
% Ak: state matrix
% Bk: input matrix
% x0: initial condition
% u0: initial output
% numExp: number of experiments
% N: horizon

% initialize dataset
data = cell(numExp,1);

for ii = 1:numExp
    % perform random experiments
    u = u0 + randn(size(u0));
    x = x0 + randn(size(x0));
    y = zeros(length(x0),N);
    y(:,1) = x;
    for k = 2:N
        w = Ss*randn(length(Ss),1);
        y(:,k) = A*y(:,k-1)+B*u(:,k-1)+G*w;
    end
    data{ii} = [y',u'];
end