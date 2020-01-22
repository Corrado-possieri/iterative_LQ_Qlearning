function options = iterativeLQRset(varargin)
%POLMINSET Create/alter iterLQR OPTIONS structure.
%   OPTIONS = itLQRset('NAME1',VALUE1,'NAME2',VALUE2,...) creates an integrator
%   options structure OPTIONS in which the named properties have the
%   specified values. Any unspecified properties have default values. 

if (nargin == 0) && (nargout == 0)
  fprintf('         NumExp: [ positive integer {1e2} ]\n');
  fprintf('        NumIter: [ positive integer {1e2} ]\n');
  fprintf('           pert: [ positive scalar {1e-6} ]\n');
  fprintf('           lamb: [ positive scalar  {1e0} ]\n'); 
  fprintf('        multLam: [ positive scalar  {2e0} ]\n');
  fprintf('        minLamb: [ positive scalar {1e-6} ]\n');
  fprintf('        maxLamb: [ positive scalar  {1e6} ]\n');
  fprintf('    accelerated: [ binary 0/1       {0}   ]\n');
  fprintf('         solver: [ string           {cvx} ]\n');
  fprintf('\n');
  return;
end

Names = [
    'NumExp         '
    'NumIter        '
    'pert           '
    'lamb           '
    'multLam        '
    'minLamb        '            
    'maxLamb        '          
    'accelerated    '         
    'solver         '   
    ];
m = size(Names,1);
names = lower(Names);

options.NumExp = 1e2;
options.NumIter = 1e2;
options.pert = 1e-6;
options.lamb = 1e0;
options.multLam = 2;
options.minLamb = 1e-6;
options.maxLamb = 1e6;
options.accelerated = 0;
options.solver = 'cvx';

i = 1;
while i <= nargin
  arg = varargin{i};
  if ischar(arg) || (isstring(arg) && isscalar(arg)) % arg is an option name
    break;
  end
  if ~isempty(arg)                      % [] is a valid options argument
    if ~isa(arg,'struct')
      error(message('MATLAB:polminset:NoPropNameOrStruct', i));
    end
    for j = 1:m
      if any(strcmp(fieldnames(arg),deblank(Names(j,:))))
        val = arg.(deblank(Names(j,:)));
      else
        val = [];
      end
      if ~isempty(val)
        options.(deblank(Names(j,:))) = val;
      end
    end
  end
  i = i + 1;
end
% Convert string arguments and options.
for ii = 1:nargin
    if isstring(varargin{ii}) && isscalar(varargin{ii})
        varargin{ii} = char(varargin{ii});
    end
end

% A finite state machine to parse name-value pairs.
if rem(nargin-i+1,2) ~= 0
  error(message('MATLAB:polminset:ArgNameValueMismatch'));
end
expectval = 0;                          % start expecting a name, not a value
while i <= nargin
  arg = varargin{i};
    
  if ~expectval
    if ~ischar(arg)
      error(message('MATLAB:polminset:NoPropName', i));
    end
    
    lowArg = lower(arg);
    j = strmatch(lowArg,names);
    if isempty(j)                       % if no matches
      error(message('MATLAB:polminset:InvalidPropName', arg));
    elseif length(j) > 1                % if more than one match
      % Check for any exact matches (in case any names are subsets of others)
      k = strmatch(lowArg,names,'exact');
      if length(k) == 1
        j = k;
      else
            matches = deblank(Names(j(1),:));
        for k = j(2:length(j))'
                matches = [matches ', ' deblank(Names(k,:))]; %#ok<AGROW>
        end
            error(message('MATLAB:polminset:AmbiguousPropName',arg,matches));
      end
    end
    expectval = 1;                      % we expect a value next
    
  else
    options.(deblank(Names(j,:))) = arg;
    expectval = 0;
      
  end
  i = i + 1;
end

if expectval
  error(message('MATLAB:polminset:NoValueForProp', arg));
end


end