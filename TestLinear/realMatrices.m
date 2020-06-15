function [rP, rD, rC, rTheta, rPsi, rPhi] = realMatrices(A,B,G,N,W,Wn,R,S,xd)
% compute real matrices
% Ak: state matrix
% Bk: input matrix
% N: horizon
% W: state weight
% Wn: final state weight
% R: input weight
% xstar: reference

% matrices size
n = size(A,1);
m = size(B,2);

% actual matrix values
rP = zeros(n,n,N-1);
rD = zeros(n,N-1);
rC = zeros(N-1,1);
rTheta = zeros(n+m,n+m,N-1);
rPsi = zeros(n+m,N-1);
rPhi = zeros(N-1,1);

% final value to be tracked
xcN = xd(:,N);
% final values
Pp = Wn;
Dp = -2*Wn*xcN;
Cp = xcN'*Wn*xcN;

for k = N-1:-1:1 
    % value of the reference signal
    xc = xd(:,k);
    
    % Riccati iteration
    PpNew = A'*Pp*A + W - A'*Pp*B*((R+B'*Pp*B)\(B'*Pp*A));
    
    DpNew = A'*Dp - 2*W*xc - A'*Pp*B*((R+B'*Pp*B)\(B'*Dp));
    
    CpNew = Cp + trace(G'*Pp*G*S)+ xc'*W*xc...
        -1/4*Dp'*B*((R+B'*Pp*B)\(B'*Dp));
    
    % store the actual matrices
    rP(:,:,k) = PpNew;
    rD(:,k) = DpNew;
    rC(k) = CpNew;
    
    rTheta(:,:,k) = [W+A'*Pp*A, A'*Pp*B; B'*Pp*A, R+B'*Pp*B];
    rPsi(:,k) = [A'*Dp - 2*W*xc; B'*Dp];
    rPhi(k) = Cp + xc'*W*xc;
        
    % iterate updating the matrices
    Pp = PpNew;
    Dp = DpNew;
    Cp = CpNew;
end