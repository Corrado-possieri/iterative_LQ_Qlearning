function incrData = reduceData(n,m,baseLine,data)
% compute incremental state and input
% n: number of states
% m: number of inputs
% baseLine: baseLine simulation
% data: simulated data

% baseline state and input
baseState = baseLine(:,1:n);
baseInput = baseLine(:,n+1:n+m);

% number of experiments
K = length(data); 

% incremental dataset
incrData = cell(K,1);
for ii = 1:K
    % isolate the ith datum
    datum = data{ii};
    state = datum(:,1:n);
    inputs = datum(:,n+1:n+m);
    x = state - baseState;
    u = inputs - baseInput;
    incrData{ii} = [x, u];
end