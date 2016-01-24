function [F,g]=bsvrsolvercri(epsu,Xl,Yl,Xt,Yt)
%**************************************************
% written by Oleg Mytnyk, (c) 2005-2007
% last revision: 2.01.2007
% LAUNCHER OF SVR ALGORITHM UNDER BAYESIAN FRAMEWORK
% input:  epsu   - input hyperparameters (eps, U)
%         Xl, Yl - learning input/output model variables
%         Xt, Yt - test dataset
% output: F      - scalar value of bayesian evidence criterion
%         g      - gradient
%**************************************************

% maximum value
MAX = 100000;

% read hyperparameters:
eps = epsu(1);
U   = epsu(2);

if nargout > 1
    g(1)=0;
    g(2)=0;
end
% check their validity:
if (eps > 0.3) || (eps < 0.0001) || (U > 30) || (U < 0.001)
    F = MAX;
    return;
end

% run SVR:
[W,b,alpha,Yestl,OLE,Nsv,Remp]=svr(Xl,Yl,Xt,Yt,eps,U);

% calculate equations:
if (Remp < 1/MAX) || (Nsv == 0)
    F = MAX;
    return;   
end

N=length(Yl);

Rreg = U*N*Remp+0.5*W'*W;
F = Rreg - N*log(U/(2*(1+eps*U)));

if nargout > 1
    g(1)=N*U/(1+eps*U)-U*Nsv;%eps derivative;
    g(2)=N*Remp-N/(U*(1+eps*U));%U derivative;
end

return;

%**************************************************