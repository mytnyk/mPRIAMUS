function F=bsvrsolversys(epsu,Xl,Yl,Xt,Yt)
%**************************************************
% written by Oleg Mytnyk, (c) 2005-2007
% last revision: 25.03.2006
% LAUNCHER OF SVR ALGORITHM UNDER BAYESIAN FRAMEWORK
% input:  epsu   - input hyperparameters (eps, U)
%         Xl, Yl - learning input/output model variables
%         Xt, Yt - test dataset
% output: F      - vector of optimality equations
%**************************************************

% maximum value
MAX = 100000;

% read hyperparameters:
eps = epsu(1);
U   = epsu(2);

% check their validity:
if (eps > 0.3) || (eps < 0.02) || (U > 100) || (U < 0.001)%(eps < 0.0001)
    F = [MAX; MAX];
    return;
end

% run SVR:
[W,b,alpha,Yestl,OLE,Nsv,Remp]=svr(Xl,Yl,Xt,Yt,eps,U);

% calculate equations:
if (Remp < 1/MAX) || (Nsv == 0)
    F = [MAX; MAX];
    return;   
end

N=length(Yl);
eq1 = -1/(U*Remp) + (1+eps*U);
eq2 = -N/Nsv + (1+eps*U);

F = [eq1; eq2];

return;

%**************************************************